package com.sgasol.webapi.pill;

import com.sgasol.webapi.model.PillInfo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PillInfoRepository extends JpaRepository<PillInfo, Long>, PillInfoRepositoryCustom {

    public List<PillInfo> findByImagehashesLike(String hash);

}
