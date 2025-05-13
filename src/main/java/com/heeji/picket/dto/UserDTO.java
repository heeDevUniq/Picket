package com.heeji.picket.dto;

import lombok.Data;

import java.util.Date;

@Data
public class UserDTO {

    private enum Status {
        DEFAULT, ADMIN, DELETED
    }

    private int id;
    private String userId;
    private String password;
    private String name;
    private String birth;
    private String email;
    private String phoneNumber;
    private String gender;
    private String address;
    private String detailAddress;
    private String certiYn;
    private boolean isAdmin;
    private Date createTime;
    private boolean isWithDraw;
    private Status status;
    private Date updateTime;

}
