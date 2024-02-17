package com.sgasol.webapi.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ResponseJson<T> {
    private int code;
    private String message;
    private boolean check = true;
    private List<PillResult> response;
}
