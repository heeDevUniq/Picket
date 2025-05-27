package com.heeji.picket.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;

import java.sql.Timestamp;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Comment("회원고유번호")
    private int userId;

    @Column(nullable = false, unique = true)
    @Comment("이메일")
    private String email;

    @Column(nullable = false)
    @Comment("비밀번호")
    private String password;

    @Column(nullable = false)
    @Comment("권한")
    @ColumnDefault("'user'")
    private String role;

    @Column(nullable = false)
    @Comment("이름")
    private String name;

    @Comment("전화번호")
    private int phoneNumber;

    @Comment("주소")
    private String address;

    @Comment("상세주소")
    private String detailAddress;

    @Comment("탈퇴여부")
    private String isDeleted;

    @Comment("탈퇴일시")
    private Timestamp deleteDate;

    @Comment("소셜로그인구분")
    private String providerType;

    @Comment("소셜로그인아이디")
    private String providerId;

    @CreationTimestamp
    @Column(nullable = false)
    @Comment("등록일시")
    private Timestamp insertDate;

    @UpdateTimestamp
    @Comment("수정일시")
    private Timestamp updateDate;

}
