package com.heeji.picket.dto.response;

import com.heeji.picket.dto.UserDTO;
import lombok.*;

@Getter
@AllArgsConstructor
@RequiredArgsConstructor
public class UserLoginResponse {

    enum LoginStatus {
        SUCCESS, FAIL, DELETED
    }

    @NonNull
    private LoginStatus result;
    private UserDTO userDTO;

    private static final UserLoginResponse FAIL = new UserLoginResponse(LoginStatus.FAIL);

    public static UserLoginResponse success(UserDTO userDTO) {
        return new UserLoginResponse(LoginStatus.SUCCESS, userDTO);
    }

}