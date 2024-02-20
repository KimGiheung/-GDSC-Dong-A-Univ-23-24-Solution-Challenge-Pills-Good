package com.example.pillsgood.service;

import com.example.pillsgood.domain.Disease;
import com.example.pillsgood.domain.Drug;
import com.example.pillsgood.domain.Interaction;
import com.example.pillsgood.dto.Medicine;
import com.example.pillsgood.dto.MedicineResult;
import com.example.pillsgood.exception.DrugNotFoundException;
import com.example.pillsgood.repository.DiseaseRepository;
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
    private final DiseaseRepository diseaseRepository;

    @Value("${serviceKey}")
    private String serviceKey;


    public String getDiseaseResult(List<Integer> drugEdiCode, List<String> diseases) {
        List<Drug> drugs = new ArrayList<>();
        List<String> drugNames = new ArrayList<>();

        for (int code1 = 0; code1 < drugEdiCode.size(); code1++) {
            drugs.add(drugRepository.findByEdiCode(drugEdiCode.get(code1)));
            String underlyingDisease = drugs.get(code1).getUnderlyingDisease();
            boolean isContainDisease = false;
            if (!underlyingDisease.isEmpty() && !diseases.isEmpty()) {
                isContainDisease = isDiseaseIncluded(underlyingDisease, diseases);
            }

            if (isContainDisease) {
                drugNames.add(drugs.get(code1).getItemName());
            }
        }


        String constitutionResult = "";
        int j = 0;
        for (String drug : drugNames) {
            constitutionResult += drug;
            if (j < drugNames.size() - 1) {
                constitutionResult += ", ";
            }
            j++;
        }
        if (!drugNames.isEmpty()) {
            constitutionResult += " : 기저질환으로 인해 복용하면 안됩니다";
        }


        return constitutionResult;
    }

    public List<String> getRelatedDiseaseNames(String diseaseName) {
        List<String> diseaseNames = new ArrayList<>();

        List<Disease> diseases = diseaseRepository.findByName(diseaseName);
        if (diseases.isEmpty()) {
            diseaseNames.add(diseaseName);
        }

        for (Disease disease : diseases) {
            diseaseNames.add(disease.getDiseaseName());
        }

        return diseaseNames;
    }

    public Interaction getInteraction(int drugEdiCode1, int drugEdiCode2) throws IOException {
        Drug drug1 = drugRepository.findByEdiCode(drugEdiCode1);
        Drug drug2 = drugRepository.findByEdiCode(drugEdiCode2);

        if (drug1 == null || drug1.getChart() == null || drug1.getUnderlyingDisease().isEmpty()) {
            loadApi(drugEdiCode1);
            drug1 = drugRepository.findByEdiCode(drugEdiCode1);
        }
        if (drug2 == null || drug2.getChart() == null || drug1.getUnderlyingDisease().isEmpty()) {
            loadApi(drugEdiCode2);
            drug2 = drugRepository.findByEdiCode(drugEdiCode2);
        }

        Interaction interaction = interactionRepository.findInteractionId(drug1.getId(), drug2.getId());

        return interaction;

    }

    public MedicineResult getInteractionResult(List<Integer> drugEdiCode) throws IOException {
        List<Interaction> interactions = new ArrayList<>();
        Set<String> tabooCause = new HashSet<>();
        List<Drug> allDrugs = new ArrayList<>();
        Set<Drug> drugs = new HashSet<>();

        for (int ediCode : drugEdiCode) {
            allDrugs.add(drugRepository.findByEdiCode(ediCode));
        }

        for (int code1 = 0; code1 < drugEdiCode.size() - 1; code1++) {
            for (int code2 = 1; code2 < drugEdiCode.size(); code2++) {
                Interaction interaction = getInteraction(drugEdiCode.get(code1), drugEdiCode.get(code2));
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
        int j = 0;
        for (Drug drug : drugs) {
            interactionResult += drug.getItemName();
            if (j < drugs.size() - 1) {
                interactionResult += ", ";
            }
            j++;
        }
        if (!drugs.isEmpty()) {
            interactionResult += " : 같이 복용하면 안됩니다";
        }

        MedicineResult medicineResult = new MedicineResult();

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
            List<String> effectList = Arrays.asList(drug.getEffect().split(", "));

            for (int i = 0; i < effectList.size(); i++) {
                effectList.set(i, effectList.get(i).replace("\"", ""));
            }
            medicine.setEffect(effectList);

            List<String> usageList = Arrays.asList(drug.getUsage().split(", "));
            for (int i = 0; i < usageList.size(); i++) {
                usageList.set(i, usageList.get(i).replace("\"", ""));
            }
            medicine.setUsage(usageList);

            List<String> underlyingDiseases = Arrays.asList(drug.getUnderlyingDisease().split(", "));
            for (int i = 0; i < underlyingDiseases.size(); i++) {
                underlyingDiseases.set(i, underlyingDiseases.get(i).replace("\"", ""));
            }
            medicine.setUnderlyingDisease(underlyingDiseases);

            medicines.add(medicine);
        }

        medicineResult.setInteractionResult(interactionResult);
        medicineResult.setMedicines(medicines);
        medicineResult.setTabooCause(tabooCause);

        return medicineResult;
    }

    public boolean isDiseaseIncluded(String underlyingDisease, List<String> diseases) {
        boolean noTaking = false;
        if (underlyingDisease != null) {
            for (String disease : diseases) {
                if (underlyingDisease.contains(disease)) {
                    noTaking = true;
                }
            }
        }

        return noTaking;
    }


    public List<Integer> manualDrugSearch(List<String> itemNames) throws IOException {
        List<Integer> drugEdiCode = new ArrayList<>();


        for (String itemName : itemNames) {
            Drug drug = drugRepository.findByName(itemName);
            if (drug == null || drug.getChart() == null || drug.getUnderlyingDisease().isEmpty()) {
                loadApi(itemName);
                drug = drugRepository.findByName(itemName);
                if (drug == null) {
                    throw new DrugNotFoundException("drug's ediCode not found: " + itemName);
                }
            }

            drugEdiCode.add(drug.getEdiCode());
        }
        log.info("manualDrugSearch:{}", drugEdiCode);
        return drugEdiCode;
    }


    @Transactional
    public void loadApi(int ediCode) throws IOException {
        String ediCodeUrl = Integer.toString(ediCode);

        String apiUrl = "https://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService04/getDrugPrdtPrmsnDtlInq03?serviceKey=" + serviceKey +
                "&pageNo=1&numOfRows=1&type=xml&edi_code=" + ediCodeUrl;

        String pythonScriptPath = "D:/project/gdsc/pillsgoodpy/loadapi.py";

        String[] cmd = new String[3];
        cmd[0] = "python";
        cmd[1] = pythonScriptPath;
        cmd[2] = apiUrl;

        ProcessBuilder pb = new ProcessBuilder(cmd);

        Map<String, String> env = pb.environment();
        env.put("PYTHONIOENCODING", "UTF-8");
        Process process = pb.start();

        BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String ret;
        while ((ret = in.readLine()) != null) {
            System.out.println(ret);
        }
    }

    @Transactional
    public void loadApi(String itemName) throws IOException {
        String apiUrl = "https://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService04/getDrugPrdtPrmsnDtlInq03?serviceKey=" + serviceKey +
                "&pageNo=1&numOfRows=1&type=xml&item_name=" + itemName;

        String pythonScriptPath = "D:/project/gdsc/pillsgoodpy/loadapi.py";

        String[] cmd = new String[3];
        cmd[0] = "python";
        cmd[1] = pythonScriptPath;
        cmd[2] = apiUrl;

        ProcessBuilder pb = new ProcessBuilder(cmd);

        Map<String, String> env = pb.environment();
        env.put("PYTHONIOENCODING", "UTF-8");
        Process process = pb.start();

        BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String ret;
        while ((ret = in.readLine()) != null) {
            System.out.println(ret);
        }

    }

    @Transactional
    public List<String> loadApiDrugSearch(String itemName) throws IOException {
        String apiUrl = "https://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService04/getDrugPrdtPrmsnDtlInq03?serviceKey=" + serviceKey +
                "&pageNo=1&numOfRows=6&type=xml&item_name=" + itemName;

        String pythonScriptPath = "D:/project/gdsc/pillsgoodpy/drug_search.py";

        String[] cmd = new String[3];
        cmd[0] = "python";
        cmd[1] = pythonScriptPath;
        cmd[2] = apiUrl;

        ProcessBuilder pb = new ProcessBuilder(cmd);

        Map<String, String> env = pb.environment();
        env.put("PYTHONIOENCODING", "UTF-8");
        Process process = pb.start();

        BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String ret;

        List<String> results = new ArrayList<>();
        while ((ret = in.readLine()) != null) {
            results.add(ret);
        }
        return results;
    }



}
