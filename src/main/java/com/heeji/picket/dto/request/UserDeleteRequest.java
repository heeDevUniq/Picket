package com.heeji.picket.dto.request;

import lombok.Data;
import lombok.NonNull;

@Data
public class UserDeleteRequest {

    @NonNull
    private String userEmail;

    @NonNull
    private String password;

}
