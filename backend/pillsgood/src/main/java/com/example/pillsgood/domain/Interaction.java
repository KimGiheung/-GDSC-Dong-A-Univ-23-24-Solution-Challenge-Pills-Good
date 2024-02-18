package com.example.pillsgood.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Interaction {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "interaction_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "drug_id1")
    private Drug drugCode1;

    @ManyToOne
    @JoinColumn(name = "drug_id2")
    private Drug drugCode2;

    @Lob
    @Column
    private String tabooCause;

}
