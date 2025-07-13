package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ShowDate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("공연날짜고유번호")
    private Long showDateId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("공연일시")
    private Timestamp showDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "showId", nullable = false, insertable = false, updatable = false)
    private Shows shows;

    @OneToMany(mappedBy = "showDate", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SeatGrade> seatGrades = new ArrayList<>();
}