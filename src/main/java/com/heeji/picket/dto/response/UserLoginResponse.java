package com.heeji.picket.dto.response;

import com.heeji.picket.domain.User;
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
    private User user;

    private static final UserLoginResponse FAIL = new UserLoginResponse(LoginStatus.FAIL);

    public static UserLoginResponse success(User user) {
        return new UserLoginResponse(LoginStatus.SUCCESS, user);
    }

}