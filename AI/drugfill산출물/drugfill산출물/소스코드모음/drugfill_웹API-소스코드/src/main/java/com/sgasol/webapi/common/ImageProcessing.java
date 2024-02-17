package com.sgasol.webapi.common;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sgasol.webapi.model.PillResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.io.*;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ImageProcessing {
    private static Logger logger = LoggerFactory.getLogger(ImageProcessing.class);

    /* 파일 업로드 기능 */
    public static boolean upload(byte[] bytea, String target) {
        try {
            File file = new File(target);
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(bytea);
            fos.close();

        } catch (IOException e) {
            logger.error("IOException");
            return false;
        }
        return true;
    }

    /* Base64 해시정보 추출 */
    public static String md5sum(byte[] bytea) throws Exception {
        String result;
        MessageDigest m = MessageDigest.getInstance("MD5");
        byte[] digest = m.digest(bytea);
        result = new BigInteger(1, digest).toString(16);
        return result;
    }

    /* 문자열 추출 json -> list */
    public static List<PillResult> convert(String jsonString) throws IOException {
        List<PillResult> result = new ArrayList<>();
        ObjectMapper mapper = new ObjectMapper();

        result = mapper.readValue(jsonString, mapper.getTypeFactory().constructCollectionType(ArrayList.class, PillResult.class));

        return result;
    }

    /* 명령어 실행 */
    public static String execute(String command) {
        String result = null;
        Process p;

        try {
            p = Runtime.getRuntime().exec(command);
            p.waitFor();
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
                result = line;
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        logger.debug("execute.command = " + result);
        return result;
    }

    /* 낱알 상세정보 추가 -  */
    public static PillResult detail(PillResult pillResult) throws Exception {
        String apiKey = "2d9a336454344c4cac9cd0524e6c0f68";
        WebClient webClient = WebClient.create("http://api.health.kr");

        MultiValueMap<String, String> params;

        params = new LinkedMultiValueMap<>();
        params.add("drug_code", pillResult.getCode());
        params.add("rt", "json");
        params.add("key", apiKey);

        Mono<String> reponse = webClient.get()
                .uri(it -> it.path("/crontiers/druginfo.api").queryParams(params).build())
                .retrieve()
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(10));       // 타임아웃 대기시간 10초

        String jsonString = reponse.block();

        /* 요청 결과 파싱 */
        Map<String, Object> map;
        ArrayList list;
        ObjectMapper mapper = new ObjectMapper();

        map = mapper.readValue(jsonString, new TypeReference<Map<String, Object>>() {
        });
        list = (ArrayList) map.get("api.health.kr");
        map = (Map<String, Object>) list.get(0);

        pillResult.setName(map.get("drug_name").toString());
        pillResult.setCls_name(map.get("print_type").toString());
        pillResult.setImage_link(map.get("idfy_img").toString());
        pillResult.setHref(map.get("detail_url").toString());
//
        return pillResult;
    }

    public static List<PillResult> detail_v1(List<PillResult> result) throws Exception {
        String apiKey = "2d9a336454344c4cac9cd0524e6c0f68";
        WebClient webClient = WebClient.create("http://api.health.kr");

        StringBuilder drug_code = new StringBuilder();

        for (PillResult pr : result) {
            if (pr.getCode() != null) {
                drug_code.append(pr.getCode());
                drug_code.append(",");
            }
        }


        MultiValueMap<String, String> params;

        params = new LinkedMultiValueMap<>();
        params.add("drug_code", drug_code.toString());
        params.add("rt", "json");
        params.add("key", apiKey);

        Mono<String> reponse = webClient.get()
                .uri(it -> it.path("/crontiers/druginfo.api").queryParams(params).build())
                .retrieve()
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(10));       // 타임아웃 대기시간 10초

        String jsonString = reponse.block();

        // Reponse 파싱
        Map<String, Object> map;
        ArrayList list;
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> m;

        map = mapper.readValue(jsonString, new TypeReference<Map<String, Object>>() {
        });
        list = (ArrayList) map.get("api.health.kr");

        for (int i = 0; i < list.size(); i++) {
            m = (Map<String, Object>) list.get(i);
            result.get(i).setName(m.get("drug_name").toString());
            result.get(i).setCls_name(m.get("print_type").toString());
            result.get(i).setImage_link(m.get("idfy_img").toString());
            result.get(i).setHref(m.get("detail_url").toString());
        }
        return result;
    }

    public static boolean save(String content, String target) {
        byte[] bytea = content.getBytes();
        try {
            File file = new File(target);
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(bytea);
            fos.close();

        } catch (IOException e) {
            logger.error("IO Exception");
            return false;
        }
        return true;
    }
}
