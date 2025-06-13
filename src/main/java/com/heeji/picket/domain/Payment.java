package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@Data
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("결제고유번호")
    private Long paymentId;

    @Column(nullable = false)
    @Comment("좌석등급고유번호")
    private Long seatGradeId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @Column(nullable = false)
    @Comment("결제수단")
    private String method;

    @Column(nullable = false)
    @Comment("PG사응답코드")
    private String pgCode;

    @Column(nullable = false, unique = true)
    @Comment("결제번호")
    private int paymentCode;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("결제일시")
    private Timestamp paidDate;

    @Column(nullable = false)
    @Comment("결제자id")
    private int paidId;

    @Comment("결제취소일시")
    private Timestamp canceledDate;

}