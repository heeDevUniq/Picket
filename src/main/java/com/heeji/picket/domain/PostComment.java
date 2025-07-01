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
public class PostComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("댓글고유번호")
    private Long postCommentId;

    @Column(nullable = false)
    @Comment("게시물고유번호")
    private Long postId;

    @Comment("내용")
    private String content;

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