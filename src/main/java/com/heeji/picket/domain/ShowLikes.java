package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ShowLikes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좋아요고유번호")
    private Long likeId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @Column(nullable = false)
    @Comment("회원고유번호")
    private Long userId;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

}