package com.example.pillsgood.controller;

import com.example.pillsgood.domain.Disease;
import com.example.pillsgood.domain.Drug;
import com.example.pillsgood.dto.Medicine;
import com.example.pillsgood.dto.MedicineResult;
import com.example.pillsgood.dto.Patient;
import com.example.pillsgood.dto.PatientName;
import com.example.pillsgood.repository.DiseaseRepository;
import com.example.pillsgood.service.DrugService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.json.JSONParser;
import org.apache.tomcat.util.json.ParseException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class PillController {

    private final DrugService drugService;

    @PostMapping("/v1/patient")
    public Result createPatient(@RequestBody Patient patient) throws IOException {


//        GetResultRes getResultRes = resultProvider.getResult(resultId);
        // patientDto 객체에 접근하여 필요한 작업 수행
        // 예를 들어, 데이터베이스에 저장하거나 다른 서비스로 전달 등

        // 약물 상호작용과 복용 가능 여부를 확인합니다.
        boolean taking = drugService.returnDisease(patient.getPills(), patient.getConstitution());
        Set<Drug> drugs = drugService.returnInteractionsV1(patient.getPills());

        // MedicineResult 객체를 생성합니다.
        MedicineResult medicineResult = new MedicineResult();
        medicineResult.setTaking(taking);

        // 각 Drug 객체를 Medicine 객체로 변환하고, MedicineResult에 추가합니다.
        List<Medicine> medicines = new ArrayList<>();
        for (Drug drug : drugs) {
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

        medicineResult.setMedicines(medicines);


        return new Result(medicineResult);
    }

    @PostMapping("/v2/patient")
    public Result createPatient2(@RequestBody Patient patient) throws IOException {

        boolean taking = drugService.returnDisease(patient.getPills(), patient.getConstitution());
        MedicineResult medicineResult = drugService.returnInteractions(patient.getPills());

        medicineResult.setTaking(taking);

        return new Result(medicineResult);
    }

    @CrossOrigin
    @PostMapping("/v3/patient")
    public Result createPatient3(@RequestBody Patient patient) throws IOException {

        String constitutionResult = drugService.returnDisease2(patient.getPills(), patient.getConstitution());
        MedicineResult medicineResult = drugService.returnInteractions(patient.getPills());

        medicineResult.setConstitutionResult(constitutionResult);

        if (constitutionResult.isEmpty() && medicineResult.getInteractionResult().isEmpty()) {
            medicineResult.setTaking(true);
        } else {
            medicineResult.setTaking(false);
        }

        return new Result(medicineResult);
    }

    @PostMapping("/v2/manual/patient")
    public Result createManualPatient2(@RequestBody PatientName patientName) throws IOException {

        List<Integer> drugEdiCode = drugService.manualDrugSearch(patientName.getPills());
        boolean taking = drugService.returnDisease(drugEdiCode, patientName.getConstitution());
        MedicineResult medicineResult = drugService.returnInteractions(drugEdiCode);

        medicineResult.setTaking(taking);

        return new Result(medicineResult);
    }

    @CrossOrigin
    @PostMapping("/v3/manual/patient")
    public Result createManualPatient3(@RequestBody PatientName patientName) throws IOException {

        List<Integer> drugEdiCode = drugService.manualDrugSearch(patientName.getPills());
        String constitutionResult = drugService.returnDisease2(drugEdiCode, patientName.getConstitution());
        MedicineResult medicineResult = drugService.returnInteractions(drugEdiCode);

        medicineResult.setConstitutionResult(constitutionResult);

        if (constitutionResult.isEmpty() && medicineResult.getInteractionResult().isEmpty()) {
            medicineResult.setTaking(true);
        } else {
            medicineResult.setTaking(false);
        }

        return new Result(medicineResult);
    }

    @CrossOrigin
    @PostMapping("/v1/drug-research")
    public Result drugResearch(@RequestBody ReqDrugName reqDrugName) throws IOException {
        List<String> drugNames = drugService.loadApiDrugSearch(reqDrugName.drugName);

        log.info("drugNames:{}", drugNames);
        return new Result(drugNames);
    }

    @CrossOrigin
    @PostMapping("/v1/disease-research")
    public Result diseaseResearch(@RequestBody ReqDiseaseName reqDiseaseName) {
        List<String> diseaseNames = drugService.returnDiseaseName(reqDiseaseName.diseaseName);

        log.info("diseaseNames:{}", diseaseNames);
        return new Result(diseaseNames);
    }




    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    static class ReqDrugName {
        String drugName;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    static class ReqDiseaseName {
        String diseaseName;
    }

    @PostMapping("/v1/dummy")
    public Result getPillsDummyData(@RequestBody ReqConsPills request) {
        String result;
        if (request.getPills() == null) {
            result = "약 정보가 존재하지 않습니다.";
        }
        try {


            result = "리팜핀, 니페딕스지속정은 같이 복용하면 안됩니다.";
            return new Result(result);
        } catch (Exception e) {
            log.info("error : {}", e);
        }
        return null;
    }

    @Data
    @AllArgsConstructor
    static class ReqConsPills {
        List<String> constitution;
        List<String> pills;
    }


    @Data
    @AllArgsConstructor
    static class Result<T> {
        private T data;
    }

}
