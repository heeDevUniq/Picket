package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@Data
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("알림고유번호")
    private Long noticeId;

    @Column(nullable = false)
    @Comment("공연정보고유번호")
    private Long showId;

    @Column(nullable = false)
    @Comment("알림유형")
    private String type;

    @Column(nullable = false)
    @Comment("수신자id")
    private String receiverId;

    @Column(nullable = false)
    @Comment("발송일시")
    private Timestamp sentDate;

    @Comment("발송성공여부")
    private String isSuccess;

}