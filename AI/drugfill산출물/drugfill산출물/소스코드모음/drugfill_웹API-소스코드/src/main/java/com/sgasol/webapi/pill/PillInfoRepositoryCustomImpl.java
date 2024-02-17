package com.sgasol.webapi.pill;

import com.sgasol.webapi.model.PillInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.List;

@Repository
@Transactional
public class PillInfoRepositoryCustomImpl implements PillInfoRepositoryCustom {

    @Autowired
    EntityManager entityManager;

    @Override
    public List<PillInfo> findMyPill() {
        return entityManager.createQuery("SELECT p FROM PillInfo as p", PillInfo.class).getResultList();
    }
}
