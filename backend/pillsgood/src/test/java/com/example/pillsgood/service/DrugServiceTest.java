package com.example.pillsgood.service;

import com.example.pillsgood.domain.Drug;
import com.example.pillsgood.domain.Interaction;
import com.example.pillsgood.dto.MedicineResult;
import com.example.pillsgood.repository.DiseaseRepository;
import com.example.pillsgood.repository.DrugRepository;
import com.example.pillsgood.repository.InteractionRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@SpringBootTest
class DrugServiceTest {

    @Autowired
    DrugRepository drugRepository;
    @Autowired
    InteractionRepository interactionRepository;
    @Autowired
    DrugService drugService;
    @Autowired
    DiseaseRepository diseaseRepository;

    @Test
    void API_불러오기() throws IOException {
        //given
        int ediCode = 642100410;
        drugService.loadApi(ediCode);

        int ediCode2 = 641801140;
        drugService.loadApi(ediCode2);
    }

    @Test
    void 약_검색_API_불러오기() throws IOException {
        //given
        String itemName = "리팜핀";
        drugService.loadApiDrugSearch(itemName);

    }

    @Test
    void 약_ID_검색() {
        Drug drug1 = drugRepository.findByEdiCode(642100410);
        System.out.println(drug1.getItemName());
    }

    @Test
    void returnInteractionTest() throws IOException {
        Drug drug1 = drugRepository.findByEdiCode(642100410);
        Drug drug2 = drugRepository.findByEdiCode(641801140);
        Interaction interaction = drugService.getInteraction(drug1.getEdiCode(), drug2.getEdiCode());
        System.out.println(interaction.getId());
    }
    @Test
    void returnInteractionsTest() throws IOException {
        Drug drug1 = drugRepository.findByEdiCode(642100410);
        Drug drug2 = drugRepository.findByEdiCode(641801140);
        Interaction interaction = drugService.getInteraction(drug1.getEdiCode(), drug2.getEdiCode());
        System.out.println(interaction.getId());
    }


    @Test
    void containsDiseaseTest() {
        String underlyingDisease = "\t\"1) 담도 폐색증 환자\", \"2) 중증의 간장애 환자, 황달환자\", \"3) 이 약의 성분에 과민반응의 병력이 있는 환자\", \"4) 인디나비르, 사퀴나비르, 넬피나비르, 암프레나비르를 투여중인 환자\", \"5) 미숙아, 신생아\", \"6) 프라지콴텔의 치료적 유효 혈중농도에 도달하지 못할 수도 있으므로 프라지콴텔 투여 환자에게 이 약은 금지됨. 프라지콴텔로 즉각 치료가 필요한 이 약 투여 환자에 대해 대체 약제가 고려되어야 한다. 그러나 프라지콴텔 치료가 필요한 경우 이 약은 프라지콴텔 투여 4주 전에 중단되어야 한다. 그 후 이 약 치료는 프라지콴텔 치료 완료 1일 후에 개시될 수 있다.\"";
        List<String> diseases = Arrays.asList("환자아님", "심장기능저하", "무좀");
        boolean isContain = drugService.isDiseaseIncluded(underlyingDisease, diseases);
        System.out.println(isContain);

    }

    @Test
    void returnDiseaseTest2() {
        List<Integer> drugEdiCode = Arrays.asList(642100410, 641801140, 665507731, 643300600, 643502200);
        List<String> diseases = Arrays.asList("정상", "심장기능저하", "무좀");

        boolean isContain = drugService.isDiseaseIncluded("\\t\\\"1) 담도 폐색증 환자\\\", \\\"2) 중증의 간장애 환자, 황달환자\\\"", diseases);
        System.out.println("isContain" + isContain);
        String disease = drugService.getDiseaseResult(drugEdiCode, diseases);
        System.out.println(disease);

        if (disease.isEmpty()) {
            System.out.println("정상임");
        }

    }

    @Test
    void returnInteraction_상호작용수정() throws IOException {
        List<Integer> drugEdiCode = Arrays.asList(642100410, 641801140, 665507731, 643300600, 643502200);
        List<String> diseases = Arrays.asList("환자아님", "심장기능저하", "무좀");
        MedicineResult medicineResult = drugService.getInteractionResult(drugEdiCode);
        System.out.println(medicineResult);
    }

    @Test
    void 스트링에서_리스트로_변환() {
        Drug drug = drugRepository.findByEdiCode(665507731);
        System.out.println("drugEffect:" + drug.getEffect());
        List<String> effectList = Arrays.asList(drug.getEffect().split(", "));

        System.out.println("result:" + effectList);
        for (String s : effectList) {
            System.out.println(s);
        }
    }

    @Test
    void 질병검색() {
        List<String> diseaseNames = drugService.getRelatedDiseaseNames("폐색증");

        System.out.println(diseaseNames);
    }

}