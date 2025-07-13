package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.Comment;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SeatGrade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좌석등급고유번호")
    private Long seatGradeId;

    @Column(nullable = false)
    @Comment("공연날짜고유번호")
    private Long showDateId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @Column(nullable = false)
    @Comment("좌석개수")
    private Integer seatCount;

    @Column(nullable = false)
    @Comment("가격")
    private Integer price;

    @Column(nullable = false)
    @Comment("등급명")
    private String gradeName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "showDateId", nullable = false, insertable = false, updatable = false)
    private ShowDate showDate;
    
    @OneToMany(mappedBy = "seatGrade", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Seat> seats = new ArrayList<>();
    
}