package com.example.pillsgood.service;

import com.example.pillsgood.domain.Drug;
import com.example.pillsgood.domain.Interaction;
import com.example.pillsgood.dto.Medicine;
import com.example.pillsgood.dto.MedicineResult;
import com.example.pillsgood.repository.DrugRepository;
import com.example.pillsgood.repository.InteractionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class DrugService {

    private final DrugRepository drugRepository;
    private final InteractionRepository interactionRepository;

    @Value("${serviceKey}")
    private String serviceKey;


    public boolean returnDisease(List<Integer> drugEdiCode, List<String> diseases) {
        List<Drug> drugs = new ArrayList<>();
        List<String> drugNames = new ArrayList<>();

        for (int code1 = 0; code1 < drugEdiCode.size(); code1++) {
            drugs.add(drugRepository.findByEdiCode(drugEdiCode.get(code1)));
            String underlyingDisease = drugs.get(code1).getUnderlyingDisease();

            boolean isContainDisease = containsDisease(underlyingDisease, diseases);
            if (isContainDisease) {
                drugNames.add(drugs.get(code1).getItemName());
                return false;
            }
        }

        return true;
    }

    public Interaction returnInteraction(int drugEdiCode1, int drugEdiCode2) throws IOException {
        Drug drug1 = drugRepository.findByEdiCode(drugEdiCode1);
        Drug drug2 = drugRepository.findByEdiCode(drugEdiCode2);

        if (drug1 == null || drug1.getChart() == null) {
            loadApi2(drugEdiCode1);
            drug1 = drugRepository.findByEdiCode(drugEdiCode1);
        }
        if (drug2 == null || drug2.getChart() == null) {
            loadApi2(drugEdiCode2);
            drug2 = drugRepository.findByEdiCode(drugEdiCode2);
        }

        Interaction interaction = interactionRepository.findInteractionId(drug1.getId(), drug2.getId());

        return interaction;

    }
    public MedicineResult returnInteractions(List<Integer> drugEdiCode) throws IOException {
        List<Interaction> interactions = new ArrayList<>();
        Set<String> tabooCause = new HashSet<>();
        List<Drug> allDrugs = new ArrayList<>();
        Set<Drug> drugs = new HashSet<>();

        for (int ediCode : drugEdiCode) {
            allDrugs.add(drugRepository.findByEdiCode(ediCode));
        }

        for (int code1 = 0; code1 < drugEdiCode.size() - 1; code1++) {
            for (int code2 = 1; code2 < drugEdiCode.size(); code2++) {
                Interaction interaction = returnInteraction(drugEdiCode.get(code1), drugEdiCode.get(code2));
                if (interaction != null) {
                    interactions.add(interaction);
                }
            }
        }

        for (Interaction interaction : interactions) {
            drugs.add(interaction.getDrugCode1());
            drugs.add(interaction.getDrugCode2());
            tabooCause.add(interaction.getTabooCause());
        }



        String interactionResult = "";
        for (Drug drug : drugs) {
            interactionResult += drug.getItemName() + ", ";
        }
        if (!drugs.isEmpty()) {
            interactionResult += " : 같이 복용하면 안됩니다";
        }

        // MedicineResult 객체를 생성합니다.
        MedicineResult medicineResult = new MedicineResult();

        // 각 Drug 객체를 Medicine 객체로 변환하고, MedicineResult에 추가합니다.
        List<Medicine> medicines = new ArrayList<>();
        for (Drug drug : allDrugs) {
            Medicine medicine = new Medicine();
            medicine.setItemName(drug.getItemName());
            medicine.setEdiCode(drug.getEdiCode());
            medicine.setIngredientName(drug.getIngredientName());
            medicine.setEntpName(drug.getEntpName());
            medicine.setChart(drug.getChart());
            medicine.setStorageMethod(drug.getStorageMethod());
            medicine.setValidTerm(drug.getValidTerm());

            medicines.add(medicine);
        }

        medicineResult.setInteractionResult(interactionResult);
        medicineResult.setMedicines(medicines);
        medicineResult.setTabooCause(tabooCause);

        return medicineResult;
    }

    public Set<Drug> returnInteractionsV1(List<Integer> drugEdiCode) throws IOException {
        List<Interaction> interactions = new ArrayList<>();
        List<String> tabooCause = new ArrayList<>();
        Set<Drug> drugs = new HashSet<>();

        for (int code1 = 0; code1 < drugEdiCode.size() - 1; code1++) {
            for (int code2 = 1; code2 < drugEdiCode.size(); code2++) {
                Interaction interaction = returnInteraction(drugEdiCode.get(code1), drugEdiCode.get(code2));
                if (interaction != null) {
                    interactions.add(interaction);
                }
            }
        }

        for (Interaction interaction : interactions) {
            drugs.add(interaction.getDrugCode1());
            drugs.add(interaction.getDrugCode2());
            tabooCause.add(interaction.getTabooCause());
        }

        return drugs;
    }

//    noTaking = True(질병포함됨, 섭취X), False(질병포함X, 섭취가능)
    public boolean containsDisease(String underlyingDisease, List<String> diseases) {
        boolean noTaking = false;
        for (String disease : diseases) {
            if (underlyingDisease.contains(disease)) {
                noTaking = true;
            }
        }
        return noTaking;
    }


    @Transactional
    public void loadApi2(int ediCode) throws IOException {
        String ediCodeUrl = Integer.toString(ediCode);

        String apiUrl = "https://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService04/getDrugPrdtPrmsnDtlInq03?serviceKey=" + serviceKey +
                "&pageNo=1&numOfRows=1&type=xml&edi_code=" + ediCodeUrl;

        String pythonScriptPath = "D:/project/gdsc/pillsgoodpy/loadapi.py";
        // 파이썬 스크립트에 전달할 인수
        String[] cmd = new String[3];
        cmd[0] = "python"; // 파이썬 실행 명령
        cmd[1] = pythonScriptPath; // 파이썬 스크립트 경로
        cmd[2] = apiUrl; // 파이썬 스크립트에 전달할 인수

        // ProcessBuilder 객체 생성
        ProcessBuilder pb = new ProcessBuilder(cmd);

        Map<String, String> env = pb.environment();
        env.put("PYTHONIOENCODING", "UTF-8");
        // 프로세스 시작
        Process process = pb.start();

        // 파이썬 스크립트의 출력을 읽기 위한 BufferedReader 객체 생성
        BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String ret;
        while ((ret = in.readLine()) != null) {
            System.out.println(ret);
        }



    }

    public List<Integer> manualDrugSearch(List<String> itemNames) {
        List<Integer> drugEdiCode = new ArrayList<>();

        for (String itemName : itemNames) {
            Drug drug = drugRepository.findByName(itemName);
            drugEdiCode.add(drug.getEdiCode());
        }

        return drugEdiCode;
    }

    @Transactional
    public List<String> loadApiDrugSearch(String itemName) throws IOException {
        String apiUrl = "https://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService04/getDrugPrdtPrmsnDtlInq03?serviceKey=" + serviceKey +
                "&pageNo=1&numOfRows=6&type=xml&item_name=" + itemName;

        String pythonScriptPath = "D:/project/gdsc/pillsgoodpy/drug_search.py";
        // 파이썬 스크립트에 전달할 인수
        String[] cmd = new String[3];
        cmd[0] = "python"; // 파이썬 실행 명령
        cmd[1] = pythonScriptPath; // 파이썬 스크립트 경로
        cmd[2] = apiUrl; // 파이썬 스크립트에 전달할 인수

        // ProcessBuilder 객체 생성
        ProcessBuilder pb = new ProcessBuilder(cmd);

        Map<String, String> env = pb.environment();
        env.put("PYTHONIOENCODING", "UTF-8");
        // 프로세스 시작
        Process process = pb.start();

        // 파이썬 스크립트의 출력을 읽기 위한 BufferedReader 객체 생성
        BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String ret;

        List<String> results = new ArrayList<>(); // 결과를 저장할 ArrayList 생성
        while ((ret = in.readLine()) != null) {
            results.add(ret); // 각 줄을 ArrayList에 추가
        }

//        // 결과 출력
//        for (String result : results) {
//            System.out.println(result);
//        }

        log.info("service:{}", results);
        return results;
    }



}
