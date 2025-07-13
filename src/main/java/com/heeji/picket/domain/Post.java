package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("게시물고유번호")
    private Long postId;

    @Column(nullable = false)
    @Comment("구분")
    private String type;

    @Column(nullable = false)
    @Comment("제목")
    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    @Comment("내용")
    private String content;

    @Column(nullable = false)
    @Comment("조회수")
    private int hits;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

    @UpdateTimestamp
    @Column(nullable = true)
    @Comment("수정일시")
    private Timestamp updateDate;

    @Comment("수정자id")
    private Integer updateId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "insert_id")
    private User user;

}