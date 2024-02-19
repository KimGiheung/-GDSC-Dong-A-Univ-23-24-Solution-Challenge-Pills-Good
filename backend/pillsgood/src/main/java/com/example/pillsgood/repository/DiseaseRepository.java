package com.example.pillsgood.repository;

import com.example.pillsgood.domain.Disease;
import com.example.pillsgood.domain.Drug;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class DiseaseRepository {

    final private EntityManager em;


    public void save(Disease disease) {
        em.persist(disease);
    }

    public List<Disease> findByName(String diseaseName) {
        try {
            return em.createQuery("select d from Disease d where d.diseaseName LIKE :diseaseName order by length(d.diseaseName)", Disease.class)
                    .setParameter("diseaseName", "%" + diseaseName + "%")
                    .getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
}
