package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Clob;
import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@Data
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("게시물고유번호")
    private int postId;

    @Column(nullable = false)
    @Comment("구분")
    private String type;

    @Column(nullable = false)
    @Comment("제목")
    private String title;

    @Comment("내용")
    private Clob content;

    @Column(nullable = false)
    @Comment("조회수")
    @ColumnDefault("0")
    private int hits;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

    @Column(nullable = false)
    @Comment("등록자id")
    private int insertId;

    @UpdateTimestamp
    @Comment("수정일시")
    private Timestamp updateDate;

    @Comment("수정자id")
    private int updateId;

}