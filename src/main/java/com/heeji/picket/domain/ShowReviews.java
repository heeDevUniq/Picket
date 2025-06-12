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
public class ShowReviews {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("공연정보고유번호")
    private int showReviewId;

    @Comment("공연정보고유번호")
    private int showId;

    @Comment("내용")
    private Clob info;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

    @Column(nullable = false)
    @Comment("등록자id")
    private int insertId;

}