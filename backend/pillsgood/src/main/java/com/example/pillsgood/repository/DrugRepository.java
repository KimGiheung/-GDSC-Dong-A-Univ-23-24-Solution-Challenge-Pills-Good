package com.example.pillsgood.repository;

import com.example.pillsgood.domain.Drug;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class DrugRepository {

    private final EntityManager em;

    public Drug findByEdiCode(int ediCode) {
        try {
            return em.createQuery("select d from Drug d where d.ediCode = :ediCode", Drug.class)
                    .setParameter("ediCode", ediCode)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public Drug findByName(String itemName) {
        try {
            return em.createQuery("select d from Drug d where d.itemName LIKE :itemName", Drug.class)
                    .setParameter("itemName", "%" + itemName + "%")
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

}
