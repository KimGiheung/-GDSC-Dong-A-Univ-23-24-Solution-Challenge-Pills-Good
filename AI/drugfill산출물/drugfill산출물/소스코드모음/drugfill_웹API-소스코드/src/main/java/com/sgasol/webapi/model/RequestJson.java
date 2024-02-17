package com.sgasol.webapi.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class RequestJson implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<MultipartFile> image;
    private List<String> image_hash;
    private String shape;
    private String f_text;
    private String b_text;
    private List drug_code;
}
