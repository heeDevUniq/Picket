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
public class ShowDate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("공연날짜고유번호")
    private Long showDateId;

    @Column(nullable = false, unique = true)
    @Comment("공연정보고유번호")
    private Long showId;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("공연일시")
    private Timestamp showDate;

}