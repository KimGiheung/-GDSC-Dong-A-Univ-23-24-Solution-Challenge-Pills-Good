package com.sgasol.webapi.pill;

import com.sgasol.webapi.model.PillInfo;

import java.util.List;

public interface PillInfoRepositoryCustom {

    public List<PillInfo> findMyPill();

//    public PillInfo findByPi_image_hash(String hash);
}
