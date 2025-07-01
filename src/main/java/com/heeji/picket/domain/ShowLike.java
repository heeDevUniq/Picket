package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class ShowLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("좋아요고유번호")
    private Long postLikeId;

    @Column(nullable = false, unique = true)
    @Comment("공연정보고유번호")
    private Long showId;

    @CreationTimestamp
    @Column(nullable = false, unique = true)
    @Comment("등록일시")
    private Timestamp insertDate;

}