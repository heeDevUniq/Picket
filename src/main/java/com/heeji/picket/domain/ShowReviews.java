package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class ShowReviews {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("리뷰고유번호")
    private Long reviewId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @Comment("내용")
    private String content;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

    @UpdateTimestamp
    @Comment("수정일시")
    private Timestamp updateDate;

    @Comment("수정자id")
    private Integer updateId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "insert_id")
    private User user;
    
}