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
public class ShowDate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("공연날짜고유번호")
    private int showDateId;

    @Column(nullable = false, unique = true)
    @Comment("공연정보고유번호")
    private int showId;

    @CreationTimestamp
    @Column(nullable = false, unique = true)
    @Comment("공연일시")
    private Timestamp showDate;

}