package com.example.pillsgood.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Set;

@Getter @Setter
public class MedicineResult {
    private String interactionResult;
    private boolean taking;
    private Set<String> tabooCause;

    private List<Medicine> medicines;
}
