package com.heeji.picket.dto;

import lombok.Data;

import java.util.Date;

@Data
public class UserDTO {

    public enum Status {
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

    public UserDTO() {
    }

    public static boolean hasNullDataBeforeRegister(UserDTO userDTO) {
        return userDTO.getUserId() == null || userDTO.getPassword() == null || userDTO.getName() == null ||
                userDTO.getBirth() == null || userDTO.getEmail() == null || userDTO.getPhoneNumber() == null ||
                userDTO.getGender() == null;
    }

}
