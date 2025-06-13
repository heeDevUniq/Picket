package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.hibernate.annotations.Comment;

@Entity
@AllArgsConstructor
@Data
public class SeatGrade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좌석등급고유번호")
    private Long seatGradeId;

    @Column(nullable = false, unique = true)
    @Comment("공연날짜고유번호")
    private Long showDateId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

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