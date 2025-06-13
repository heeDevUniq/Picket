package com.heeji.picket.controller.api;

import com.heeji.picket.domain.User;
import com.heeji.picket.dto.request.UserDeleteRequest;
import com.heeji.picket.dto.request.UserLoginRequest;
import com.heeji.picket.dto.request.UserUpdateRequest;
import com.heeji.picket.dto.response.UserLoginResponse;
import com.heeji.picket.service.PostService;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/post/api")
@Log4j2
public class PostRestController {

    private final PostService postService;

    public PostRestController(PostService postService) {
        this.postService = postService;
    }
//
//    @PostMapping("/sign-up")
//    @ResponseStatus(HttpStatus.CREATED)
//    public void signUp(@RequestBody User user) {
//        userService.register(user);
//    }
//
//    @PostMapping("/sign-in")
//    public HttpStatus login(@RequestBody UserLoginRequest userLoginRequest, HttpSession session) {
//        System.out.println("진입!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!userLoginRequest: " + userLoginRequest);
//        ResponseEntity<UserLoginResponse> responseEntity = null;
//        String userEmail = userLoginRequest.getEmail();
//        String password = userLoginRequest.getPassword();
//        User user = userService.login(userEmail, password);
//        if (user != null) {
//            SessionUtil.setLoginUser(session, user);
//            userLoginResponse = UserLoginResponse.success(user);
//            log.info("로그인 성공, user: {}", user);
//            responseEntity = new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK);
//        } else {
//            log.error("로그인 실패, user: {}", user);
//            return HttpStatus.NOT_FOUND;
//        }
//        return HttpStatus.OK;
//    }
//
//    @GetMapping("/my-info")
//    public User memberInfo(HttpSession session) {
//        String loginEmail = (String)SessionUtil.getLoginUser(session).get("LOGIN_EMAIL");
//        return userService.findUser(loginEmail);
//    }
//
//    @PutMapping("/logout")
//    public void logout(HttpSession session) {
//        SessionUtil.clearSession(session);
//    }
//
//    @PatchMapping("/update")
//    public ResponseEntity<UserLoginResponse> updatePassword(@RequestBody UserUpdateRequest userUpdateRequest, HttpSession session) {
//        ResponseEntity<UserLoginResponse> resposneEntity = null;
//        String userEmail = (String)SessionUtil.getLoginUser(session).get("LOGIN_EMAIL");
//        String beforePassword = userUpdateRequest.getBeforePassword();
//        String afterPassword = userUpdateRequest.getAfterPassword();
//        try {
//            userService.updatePassword(userEmail, beforePassword, afterPassword);
//            resposneEntity.ok(new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK));
//        } catch(IllegalArgumentException e) {
//            log.error("updatePassword 실패, params : {}", userEmail, beforePassword, afterPassword);
//            resposneEntity = new ResponseEntity<UserLoginResponse>(HttpStatus.BAD_REQUEST);
//        }
//        return resposneEntity;
//    }
//
//    @DeleteMapping
//    public ResponseEntity<UserLoginResponse> delete(@RequestBody UserDeleteRequest userDeleteRequest, HttpSession session) {
//        ResponseEntity<UserLoginResponse> resposneEntity = null;
//        String userEmail = userDeleteRequest.getUserEmail();
//        try {
//            userService.delete(userEmail, userDeleteRequest.getPassword());
//            resposneEntity = new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK);
//        } catch(RuntimeException e) {
//            log.error("회원 삭제 실패, params : {}", userEmail, userDeleteRequest.getPassword());
//            resposneEntity = new ResponseEntity<UserLoginResponse>(HttpStatus.BAD_REQUEST);
//        }
//        SessionUtil.clearSession(session);
//        return resposneEntity;
//    }
//
//    @PostMapping("/chkDupl")
//    @ResponseBody
//    public int chkDupl(@RequestBody Map<String, Object> params) {
//        int retNum = 0;
//        User user = userService.findUser(params.get("email").toString());
//        if (user != null) {
//            retNum = 1;
//        }
//        return retNum;
//    }
}
