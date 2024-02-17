package com.sgasol.webapi.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "pill_result")
@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PillResult {

    // 낱알 등록 컬럼
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator="pill_result_index_seq")
    @SequenceGenerator(
            name="pill_result_index_seq",
            sequenceName="pill_result_index_seq",
            allocationSize = 1,
            initialValue = 0
    )
    @JsonIgnore
    private Long index;         // 테이블 인덱스

    @JsonIgnore
    @Column (name = "pi_index")
    private long piIndex;

    private short rank;

    private String code;

    private Double accuracy;

    private String image_link;

    private String name;

    private String cls_name;

    private String href;

}
