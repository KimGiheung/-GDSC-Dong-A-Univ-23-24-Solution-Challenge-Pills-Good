package com.example.pillsgood.repository;

import com.example.pillsgood.domain.Drug;
import com.example.pillsgood.domain.Interaction;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class InteractionRepository {

    private final EntityManager em;
    private final DrugRepository drugRepository;

    public Interaction findOne(Long id) {
        return em.find(Interaction.class, id);
    }

    public Interaction findInteractionId(Long drugId1, Long drugId2) {
        try {
            return em.createQuery("select i from Interaction i where (i.drugCode1.id = :drugId1 and i.drugCode2.id = :drugId2) or (i.drugCode1.id = :drugId2 and i.drugCode2.id = :drugId1)", Interaction.class)
                    .setParameter("drugId1", drugId1)
                    .setParameter("drugId2", drugId2)
                    // 쿼리를 실행하고 결과를 Interaction 타입으로 반환합니다.
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }

    }



}
