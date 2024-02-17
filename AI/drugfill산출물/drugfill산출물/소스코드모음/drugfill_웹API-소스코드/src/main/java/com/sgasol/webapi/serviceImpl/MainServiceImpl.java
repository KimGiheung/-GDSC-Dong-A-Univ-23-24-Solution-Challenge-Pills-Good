package com.sgasol.webapi.serviceImpl;

import com.sgasol.webapi.common.ImageProcessing;
import com.sgasol.webapi.model.PillResult;
import com.sgasol.webapi.service.MainService;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Service
public class MainServiceImpl implements MainService {

    @Override
    public String md5sum(byte[] bytea) throws Exception {
        return ImageProcessing.md5sum(bytea);
    }

    @Override
    public boolean upload(byte[] bytea, String filePath) {
        return ImageProcessing.upload(bytea, filePath);
    }

    @Override
    public String execute(String command) {
        return ImageProcessing.execute(command);
    }

    @Override
    public List<PillResult> convert(String jsonString) throws IOException {
        return ImageProcessing.convert(jsonString);
    }

    @Override
    public boolean save(String content, String filePath) {
        return ImageProcessing.save(content, filePath);
    }

}
