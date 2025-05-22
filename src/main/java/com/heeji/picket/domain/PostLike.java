package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@Data
public class PostLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좋아요고유번호")
    private int postLikeId;

    @Column(nullable = false, unique = true)
    @Comment("게시물고유번호")
    private int postId;

    @CreationTimestamp
    @Column(nullable = false, unique = true)
    @Comment("등록일시")
    private Timestamp insertDate;

}