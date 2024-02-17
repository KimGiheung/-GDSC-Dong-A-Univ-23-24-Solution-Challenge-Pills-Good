package com.sgasol.webapi.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Metadata {
    private String shape;       /* 낱알 형태 */
    private String f_text;      /* 낱알 전면 각인 */
    private String b_text;      /* 낱알 전면 후면 */
    private String drug_code;   /* 약정원코드 문자열 */

    public Metadata() {
        shape = "none";
        f_text = "none";
        b_text = "none";
        drug_code = "none";
    }

    @Override
    public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append("shape");
        buffer.append("\t");
        buffer.append("f_text");
        buffer.append("\t");
        buffer.append("b_text");
        buffer.append("\t");
        buffer.append("drug_code");

        buffer.append("\n");

        buffer.append(shape);
        buffer.append("\t");
        buffer.append(f_text);
        buffer.append("\t");
        buffer.append(b_text);
        buffer.append("\t");
        buffer.append(drug_code);

        return buffer.toString();
    }

}
