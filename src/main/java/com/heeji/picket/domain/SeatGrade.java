package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Clob;
import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@Data
public class SeatGrade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좌석등급고유번호")
    private int seatGradeId;

    @Column(nullable = false, unique = true)
    @Comment("공연날짜고유번호")
    private int showDateId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private int showId;

    @Column(nullable = false)
    @Comment("좌석개수")
    private int seatCount;

    @Column(nullable = false)
    @Comment("가격")
    private int price;

    @Column(nullable = false, unique = true)
    @Comment("등급명")
    private String gradeName;

}