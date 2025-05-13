package com.heeji.picket.dto.request;

import lombok.Data;
import lombok.NonNull;

@Data
public class UserUpdateRequest {

    @NonNull
    private String beforePassword;

    @NonNull
    private String afterPassword;

}
