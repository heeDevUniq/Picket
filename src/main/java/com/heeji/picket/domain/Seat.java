package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Seat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좌석고유번호")
    private Long seatId;

    @Column(nullable = false, unique = true)
    @Comment("좌석등급고유번호")
    private Long seatGradeId;

    @Column(nullable = false, unique = true)
    @Comment("공연날짜고유번호")
    private Long showDateId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @Column(nullable = false, unique = true)
    @Comment("열")
    private String rowName;

    @Column(nullable = false, unique = true)
    @Comment("좌석번호")
    private Integer seatNumber;

    @Column(nullable = false)
    @Comment("예매상태")
    @ColumnDefault("'available'")
    private String seatStatus;

    @Comment("예매번호")
    private String bookedNumber;

    @CreationTimestamp
    @Comment("예매일시")
    private Timestamp bookedDate;

    @Comment("예매자id")
    private Integer bookedId;

}