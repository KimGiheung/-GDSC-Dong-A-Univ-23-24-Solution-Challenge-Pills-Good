package com.sgasol.webapi.controller;

import com.sgasol.webapi.common.ImageProcessing;
import com.sgasol.webapi.dto.Metadata;
import com.sgasol.webapi.model.PillInfo;
import com.sgasol.webapi.model.PillResult;
import com.sgasol.webapi.model.RequestJson;
import com.sgasol.webapi.model.ResponseJson;
import com.sgasol.webapi.pill.PillInfoRepository;
import com.sgasol.webapi.pill.PillResultRepository;
import com.sgasol.webapi.service.MainService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/pill")
public class MainController {

    private static Logger logger = LoggerFactory.getLogger(MainController.class);

    @Autowired
    private MainService mainService;

    @Autowired
    private PillInfoRepository pillInfoRepository;

    @Autowired
    private PillResultRepository pillResultRepository;

    @PostMapping(value = "/v1.0/recognition")
    public ResponseEntity<?> recognition(@ModelAttribute RequestJson request
    ) {
        StopWatch stopWatch = new StopWatch();
        ResponseJson<PillResult> reponse = new ResponseJson<>();
        List<PillResult> result;
        int i;

        String shape = request.getShape();
        List<MultipartFile> image = request.getImage();
        List image_hash = request.getImage_hash();


        List file_path = new ArrayList();
        StringBuilder fileName;

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        Date now = new Date();

        // 파라미터 검사
        shape = shape.trim().toLowerCase();

        if (!(shape.equals("circle") ||
                shape.equals("ellipse") ||
                shape.equals("diamond") ||
                shape.equals("triangle") ||
                shape.equals("rectangle") ||
                shape.equals("square") ||
                shape.equals("pentagon") ||
                shape.equals("hexagon") ||
                shape.equals("octagon") ||
                shape.equals("etc"))) {
            logger.error("Shape 파라미터가 존재하지 않습니다.");
            reponse.setCode(500);
            reponse.setMessage("파라미터 오류");
            reponse.setCheck(false);
            return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        // 이미지 업로드
        // 1. 해쉬 검사
        // 2. 이미지 파일 업로드
        String compareHash;
        i = 0;

        for (MultipartFile multipartFile : image) {
            stopWatch.start();
            try {
                compareHash = mainService.md5sum(multipartFile.getBytes());
            } catch (Exception e) {
                logger.error("해당 파일의 MD5 값을 추출 할 수 없습니다.");
                reponse.setCode(500);
                reponse.setMessage("해당 파일의 MD5 값을 추출 할 수 없습니다.");
                reponse.setCheck(false);
                return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            /* 이미지 파일과 해시정보가 불일치 할 경우 - 추후 검증 필요 */
            if (!image_hash.contains(compareHash)) {
                logger.error(multipartFile.getOriginalFilename() + "이미지 파일과 해시가 일치 하지 않습니다.");
//                reponse.setCode(500);
//                reponse.setMessage(multipartFile.getOriginalFilename() + "이미지 파일과 해시가 일치 하지 않습니다.");
//                reponse.setCheck(false);
//                return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
            }

            fileName = new StringBuilder();
            fileName.append(image_hash.get(0));
            fileName.append("_");
            fileName.append(shape);
            fileName.append("_");
            fileName.append(dateFormat.format(now));
            fileName.append("_");
            fileName.append(i + 1);
            fileName.append(".jpg");

            i++;    /* 이미지 숫자 증가 */

            file_path.add(fileName.toString()); /* 메타데이터 파일 경로 저장 */

            /* 이미지 파일 업로드 */
            try {
                if (mainService.upload(multipartFile.getBytes(), "/var/upload/" + fileName.toString()) == false) {
                    logger.error("이미지 파일 업로드에 실패하였습니다.");
                    reponse.setCode(500);
                    reponse.setMessage("이미지 파일 업로드에 실패하였습니다.");
                    reponse.setCheck(false);
                    return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
                }
            } catch (IOException e) {
                logger.error("이미지 파일 업로드에 실패하였습니다.");
                reponse.setCode(500);
                reponse.setMessage("이미지 파일 업로드에 실패하였습니다.");
                reponse.setCheck(false);
                return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            stopWatch.stop();
            logger.info(i + "번째 이미지 저장 {}", stopWatch.getLastTaskTimeMillis());
        }

        // 메타데이터 파일 생성
        // 1. 메타데이터 추출
        // 2. 메타데이터 저장
        stopWatch.start();
        Metadata metadata = new Metadata();
        metadata.setShape(shape);

        if (request.getB_text().length() != 0) {
            metadata.setB_text(request.getB_text());
        }

        if (request.getF_text().length() != 0) {
            metadata.setF_text(request.getF_text());
        }

        if (request.getDrug_code() != null) {
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append("[");
            i = 0;
            for (Object s : request.getDrug_code()) {
                if (i != 0) stringBuffer.append(",");
                stringBuffer.append(s.toString());
                i++;
            }
            stringBuffer.append("]");
            metadata.setDrug_code(stringBuffer.toString());
        }

        fileName = new StringBuilder();
        fileName.append(image_hash.get(0));
        fileName.append("_");
        fileName.append(shape);
        fileName.append("_");
        fileName.append(dateFormat.format(now));
        fileName.append(".txt");

        file_path.add(fileName.toString()); /* 메타데이터 파일 경로 저장 */

        if (mainService.save(metadata.toString(), "/var/upload/" + fileName.toString()) == false) {
            logger.error("메타데이터 파일 저장에 실패하였습니다.");
            reponse.setCode(500);
            reponse.setMessage("메타데이터 파일 저장에 실패하였습니다.");
            reponse.setCheck(false);
            return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        stopWatch.stop();
        logger.info("메타데이터 생성 {}" , stopWatch.getLastTaskTimeMillis());

        // 명령어 실행
        // 1. 명령어 실행
        // 2. 명령어 결과 반환
        stopWatch.start();
        StringBuffer command = new StringBuffer();
        String jsonData;
        command.append("/usr/bin/python3");
        command.append(" ");
        command.append("/data/PillMain.pyc");
        command.append(" ");
        command.append("/var/upload/" + file_path.get(0));
        command.append(" ");
        command.append("/var/upload/" + file_path.get(1));
        command.append(" ");
        command.append("/var/upload/" + file_path.get(2));
        jsonData = mainService.execute(command.toString());
        stopWatch.stop();
        logger.info("명령어 실행 {}" , stopWatch.getLastTaskTimeMillis());

        stopWatch.start();
        try {
            result = mainService.convert(jsonData);
        } catch (IOException | NullPointerException e) {
            logger.error("JSON 형 변환을 실패하였습니다.");
            reponse.setCode(500);
            reponse.setMessage("JSON 형 변환을 실패하였습니다. command= " + command.toString() + ",command_result=" + jsonData);
            reponse.setCheck(false);
            return new ResponseEntity<>(reponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        stopWatch.stop();
        logger.info("JSON 변환 {}" , stopWatch.getLastTaskTimeMillis());

        // 데이터베이스 저장
        // 1. 낱알 정보 테이블 저장
        // 2. 낱알 결과 테이블 저장
        stopWatch.start();
        PillInfo pillInfo = new PillInfo();
        pillInfo.setReg_time(LocalDateTime.now());
        pillInfo.setImagehashes(image_hash.get(0).toString() + "_" + image_hash.get(1).toString());
        pillInfo.setShape(shape);
        pillInfo = pillInfoRepository.save(pillInfo);

        long index = pillInfo.getIndex();

        List<PillResult> resultNew = new ArrayList<>();

        try {
            result = ImageProcessing.detail_v1(result);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 낱알 상세정보 추가 및 데이터베이스 저장
        for (PillResult pr : result) {
            pr.setPiIndex(index);
            pr.setCode(null);
            resultNew.add(pr);
        }
        stopWatch.stop();
        logger.info("낱알 인식 상세정보 업데이트 {}" , stopWatch.getLastTaskTimeMillis());

        pillResultRepository.saveAll(resultNew);

        // 인식 결과 요청 결과 반환
        reponse.setCode(200);
        reponse.setMessage("성공");
        reponse.setCheck(true);
        reponse.setResponse(result);
        return new ResponseEntity<>(reponse, HttpStatus.OK);
    }

    @GetMapping("/v1.0/reconnect/{image_hash}")
    public ResponseEntity<?> reconnect(@PathVariable String image_hash) {
        ResponseJson<Object> response;
        List<PillInfo> pillInfos = pillInfoRepository.findByImagehashesLike(image_hash);
        List<PillResult> pillResults;

        if (pillInfos.size() == 0) {
            response = new ResponseJson<>();
            logger.error("분석 정보가 존재하지 않습니다.");
            response.setCode(500);
            response.setMessage("분석 정보가 존재하지 않습니다.");
            response.setCheck(true);
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
        }

        long index = pillInfos.get(0).getIndex();

        pillResults = pillResultRepository.findByPiIndex(index);

        if (pillResults.size() == 0) {
            response = new ResponseJson<>();
            logger.error("낱알 분석 진행 중입니다.");
            response.setCode(202);
            response.setMessage("낱알 분석 진행 중입니다.");
            response.setCheck(true);
            return new ResponseEntity<>(response, HttpStatus.ACCEPTED);
        }

        response = new ResponseJson<>();
        response.setCode(200);
        response.setMessage("성공");
        response.setCheck(true);
        response.setResponse(pillResults);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
