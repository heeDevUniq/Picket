package com.heeji.picket.dto.request;

import lombok.Data;
import lombok.NonNull;

import java.util.Date;

@Data
public class UserLoginRequest {

    @NonNull
    private String userEmail;

    @NonNull
    private String password;

}