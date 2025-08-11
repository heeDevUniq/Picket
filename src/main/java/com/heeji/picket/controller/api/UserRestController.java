package com.heeji.picket.controller.api;

import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/user/api")
@Log4j2
public class UserRestController {

    @Autowired
    UserService userService;

    @PostMapping("/sign-up")
    @ResponseStatus(HttpStatus.CREATED)
    public void signUp(@RequestBody Map<String, Object> params) {
        userService.register(params);
    }

    @PostMapping("/sign-in")
    public void login(HttpSession session, @RequestBody Map<String, Object> params) {
        Map<String, Object> info = userService.login(params);
        if (info != null) {
            SessionUtil.setLoginUser(session, info);
            log.info("로그인 성공, user: {}", params);
        } else {
            log.error("로그인 실패, user: {}", params);
        }
    }

    @GetMapping("/my-info")
    public Map<String, Object> memberInfo(HttpSession session) {
        Map<String, Object> userInfo = (Map<String, Object>)SessionUtil.getLoginUser(session).get("USER");
        return userService.info(userInfo);
    }

    @PutMapping("/logout")
    public void logout(HttpSession session) {
        SessionUtil.clearSession(session);
    }

    @PatchMapping("/update")
    public int updatePassword(HttpSession session, @RequestBody Map<String, Object> params) {
        int retNum = 0;
        params.put("email", (String)SessionUtil.getLoginUser(session).get("LOGIN_EMAIL"));
        try {
            userService.updatePassword(params);
            retNum = 1;
        } catch(IllegalArgumentException e) {
            log.error("updatePassword 실패, params : {}", params);
        }
        return retNum;
    }

    @DeleteMapping
    public int delete(HttpSession session, @RequestBody Map<String, Object> params) {
        int retNum = 0;
        try {
            userService.delete(params);
            retNum = 1;
        } catch(RuntimeException e) {
            log.error("회원 삭제 실패, params : {}", params);
        }
        SessionUtil.clearSession(session);
        return retNum;
    }

    @PostMapping("/chkDupl")
    @ResponseBody
    public int chkDupl(@RequestBody Map<String, Object> params) {
        int retNum = 0;
        Map<String, Object> info = userService.info(params);
        if (info != null) {
            retNum = 1;
        }
        return retNum;
    }
}
