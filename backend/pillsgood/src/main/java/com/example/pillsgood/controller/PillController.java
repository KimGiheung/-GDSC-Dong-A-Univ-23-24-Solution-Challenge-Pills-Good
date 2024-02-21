package com.example.pillsgood.controller;

import com.example.pillsgood.dto.MedicineResult;
import com.example.pillsgood.dto.Patient;
import com.example.pillsgood.dto.PatientName;
import com.example.pillsgood.exception.DrugNotFoundException;
import com.example.pillsgood.service.DrugService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class PillController {

    private final DrugService drugService;

    @CrossOrigin
    @PostMapping("/v3/patient")
    public Result createPatient3(@RequestBody Patient patient) throws IOException {
        String constitutionResult = drugService.getDiseaseResult(patient.getPills(), patient.getConstitution());
        MedicineResult medicineResult = drugService.getInteractionResult(patient.getPills());

        medicineResult.setConstitutionResult(constitutionResult);
        log.info("status:{}, drug:{}", constitutionResult, medicineResult.getInteractionResult());

        if (constitutionResult.isEmpty() && medicineResult.getInteractionResult().isEmpty()) {
            medicineResult.setTaking(true);
        } else {
            medicineResult.setTaking(false);
        }

        if (constitutionResult.isEmpty()) {
            medicineResult.setConstitutionResult("복용해도 됩니다");

        }
        if (medicineResult.getInteractionResult().isEmpty()) {
            medicineResult.setInteractionResult("같이 복용해도 됩니다");
        }

        return new Result(medicineResult);
    }


    @CrossOrigin
    @PostMapping("/v3/manual/patient")
    public Result createManualPatient3(@RequestBody PatientName patientName) throws IOException {
        try {
            List<Integer> drugEdiCode = drugService.manualDrugSearch(patientName.getPills());
            String constitutionResult = drugService.getDiseaseResult(drugEdiCode, patientName.getConstitution());
            MedicineResult medicineResult = drugService.getInteractionResult(drugEdiCode);

            medicineResult.setConstitutionResult(constitutionResult);

            if (constitutionResult.isEmpty() && medicineResult.getInteractionResult().isEmpty()) {
                medicineResult.setTaking(true);
            } else {
                medicineResult.setTaking(false);
            }

            if (constitutionResult.isEmpty()) {
                medicineResult.setConstitutionResult("복용해도 됩니다");
            }
            if (medicineResult.getInteractionResult().isEmpty()) {
                medicineResult.setInteractionResult("같이 복용해도 됩니다");
            }

            return new Result(medicineResult);
        } catch (DrugNotFoundException e) {
            return new Result("EDI code for the drug could not be found");
        }


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
        List<String> diseaseNames = drugService.getRelatedDiseaseNames(reqDiseaseName.diseaseName);

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
