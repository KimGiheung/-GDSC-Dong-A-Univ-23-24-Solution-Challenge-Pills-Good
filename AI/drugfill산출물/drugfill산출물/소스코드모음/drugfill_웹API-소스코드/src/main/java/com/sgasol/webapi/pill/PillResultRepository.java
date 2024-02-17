package com.sgasol.webapi.pill;

import com.sgasol.webapi.model.PillResult;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PillResultRepository extends JpaRepository<PillResult, Long> {

    public List<PillResult> findByPiIndex(long index);
}
