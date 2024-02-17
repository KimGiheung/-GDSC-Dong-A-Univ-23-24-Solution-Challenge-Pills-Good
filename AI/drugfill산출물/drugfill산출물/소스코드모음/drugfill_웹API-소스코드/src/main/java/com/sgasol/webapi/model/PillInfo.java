package com.sgasol.webapi.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "pill_info")
@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PillInfo {

    // 낱알 등록 컬럼
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pill_info_index_seq")
    @SequenceGenerator(
            name = "pill_info_index_seq",
            sequenceName = "pill_info_index_seq",
            allocationSize = 1, initialValue = 0
    )
    @JsonIgnore
    private Long index;         // 테이블 인덱스

    @Column(name = "image_hashes")
    private String imagehashes;    // 이미지 파일 해쉬 정보 (65자리)

    private String shape;       // 낱알 제형

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    @CreationTimestamp
    private LocalDateTime reg_time;    // 데이터베이스 등록 시간

    private short status;       // 진행 상태 (-1 : 실패, 0 : 등록 및 준비, 1 : 완료)

    // 분석결과 저장 컬럼

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    @UpdateTimestamp
    private LocalDateTime end_time;    // 인식 종료 시간

}
