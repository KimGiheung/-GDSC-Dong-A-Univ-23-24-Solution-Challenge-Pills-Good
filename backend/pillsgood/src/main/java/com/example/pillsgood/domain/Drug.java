package com.example.pillsgood.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Drug {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "drug_id")
    private Long id;

    @Column(nullable = true)
    private int ediCode;
    private String itemName;
    private String ingredientCode;
    private String ingredientName;
    private String entpName;

    @Enumerated(EnumType.STRING)
    private DrugReimbursement reimbursement;

    private String chart;
    private String storageMethod;
    private String validTerm;

    @Lob
    @Column
    private String effect;
    @Lob
    @Column
    private String usage;
    @Lob
    @Column
    private String underlyingDisease;

}
