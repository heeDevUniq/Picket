package com.heeji.picket.controller;

import com.heeji.picket.dto.UserDTO;
import com.heeji.picket.dto.request.UserDeleteRequest;
import com.heeji.picket.dto.request.UserLoginRequest;
import com.heeji.picket.dto.request.UserUpdateRequest;
import com.heeji.picket.dto.response.UserInfoResponse;
import com.heeji.picket.dto.response.UserLoginResponse;
import com.heeji.picket.service.impl.UserServiceImpl;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;
import lombok.extern.log4j.Log4j2;
import org.apache.catalina.User;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@Log4j2
public class UserController {

    private final UserServiceImpl userService;
    private static UserLoginResponse userLoginResponse;

    public UserController(UserServiceImpl userService) {
        this.userService = userService;
    }

    @PostMapping("/sign-up")
    @ResponseStatus(HttpStatus.CREATED)
    public void signUp(@RequestBody UserDTO userDTO) {
        if (UserDTO.hasNullDataBeforeRegister(userDTO)) {
            log.error("회원가입 실패, params : {}", userDTO);
            throw new IllegalArgumentException("회원가입 실패, params : " + userDTO);
        } else {
            log.info("회원가입 요청: {}", userDTO);
            userService.register(userDTO);
        }
    }

    @PostMapping("/sign-in")
    public HttpStatus login(@RequestBody UserLoginRequest userLoginRequest, HttpSession session) {
        System.out.println("진입!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!userLoginRequest: " + userLoginRequest);
        System.out.println("userId: " + userLoginRequest.getUserId());
        System.out.println("password: " + userLoginRequest.getPassword());
        ResponseEntity<UserLoginResponse> responseEntity = null;
        String userId = userLoginRequest.getUserId();
        String password = userLoginRequest.getPassword();
        UserDTO userInfo = userService.login(userId, password);
        if (userInfo != null) {
            session.setAttribute("userId", userId);
            session.setAttribute("isAdmin", userInfo.isAdmin());
            userLoginResponse = UserLoginResponse.success(userInfo);
            if (userInfo.getStatus() == (UserDTO.Status.ADMIN)) {
                SessionUtil.setLoginAdminId(session, userId);
            } else {
                SessionUtil.setLoginMemberId(session, userId);
            }
            log.info("로그인 성공, userId: {}", userId);
            responseEntity = new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK);
        } else if (userInfo == null) {
            log.error("로그인 실패, userId: {}", userId);
            return HttpStatus.NOT_FOUND;
        } else {
            throw new RuntimeException("Login ERROR! 유저 정보 없거나 지원되지 않는 유저입니다.");
        }
        return HttpStatus.OK;
    }

    @GetMapping("/my-info")
    public UserInfoResponse memberInfo(HttpSession session) {
        String userId = SessionUtil.getLoginMemberId(session);
        if (userId == null) {
            userId = SessionUtil.getLoginAdminId(session);
        }
        UserDTO memberInfo = userService.getUserInfo(userId);
        return new UserInfoResponse(memberInfo);
    }

    @PutMapping("/logout")
    public void logout(HttpSession session) {
        SessionUtil.clearSession(session);
    }

    @PatchMapping("/update-password")
    public ResponseEntity<UserLoginResponse> updatePassword(@RequestBody UserUpdateRequest userUpdateRequest, HttpSession session) {
        ResponseEntity<UserLoginResponse> resposneEntity = null;
        UserLoginResponse UserLoginResponse = null;
        String userId = SessionUtil.getLoginMemberId(session);
        String beforePassword = userUpdateRequest.getBeforePassword();
        String afterPassword = userUpdateRequest.getAfterPassword();

        try {
            userService.updatePassword(userId, beforePassword, afterPassword);
            resposneEntity.ok(new ResponseEntity<UserLoginResponse>(UserLoginResponse, HttpStatus.OK));
        } catch(IllegalArgumentException e) {
            log.error("updatePassword 실패, params : {}", userId, beforePassword, afterPassword);
            resposneEntity = new ResponseEntity<UserLoginResponse>(HttpStatus.BAD_REQUEST);
        }
        return resposneEntity;
    }

    @DeleteMapping
    public ResponseEntity<UserLoginResponse> delete(@RequestBody UserDeleteRequest userDeleteRequest, HttpSession session) {
        ResponseEntity<UserLoginResponse> resposneEntity = null;
        String userId = SessionUtil.getLoginMemberId(session);
        try {
            userService.deleteId(userId, userDeleteRequest.getPassword());
            resposneEntity = new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK);
        } catch(RuntimeException e) {
            log.error("회원 삭제 실패, params : {}", userId, userDeleteRequest.getPassword());
            resposneEntity = new ResponseEntity<UserLoginResponse>(HttpStatus.BAD_REQUEST);
        }
        SessionUtil.clearSession(session);
        return resposneEntity;
    }

}
