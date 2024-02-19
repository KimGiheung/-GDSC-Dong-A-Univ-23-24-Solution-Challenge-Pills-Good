package com.example.pillsgood.dto;

import com.example.pillsgood.domain.DrugReimbursement;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Lob;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter @Setter
public class Medicine {

    private String itemName;
    private int ediCode;
    private String ingredientName;
    private String entpName;
    private String chart;
    private String storageMethod;
    private String validTerm;
    private List<String> effect;
    private List<String> usage;
    private List<String> underlyingDisease;
}
