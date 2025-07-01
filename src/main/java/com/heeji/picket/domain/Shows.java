package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Shows {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("공연정보고유번호")
    private Long showId;

    @Column(nullable = false)
    @Comment("공연명")
    private String title;

    @Column(nullable = false)
    @Comment("공연장소")
    private String place;

    @Comment("장르")
    private String genre;

    @Comment("주최/주관사")
    private String host;

    @Comment("문의")
    private String contact;

    @Comment("관람연령")
    private String ageLimit;

    @Column(nullable = false)
    @Comment("예매오픈일시")
    private Timestamp openDate;

    @Column(nullable = false)
    @Comment("취소마감일시")
    private Timestamp isDeleted;

    @Lob
    @Column(columnDefinition = "TEXT")
    @Comment("공연정보")
    private String info;

    @Column(nullable = false)
    @Comment("포스터링크")
    private String posterLink;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

    @Column(nullable = false)
    @Comment("등록자id")
    private Integer insertId;

    @UpdateTimestamp
    @Comment("수정일시")
    private Timestamp updateDate;

    @Comment("수정자id")
    private Integer updateId;

}