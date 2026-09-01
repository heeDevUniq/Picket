package com.heeji.picket.controller.api;

import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/user/api")
public class UserRestController {

    private static final Logger logger = LoggerFactory.getLogger(UserRestController.class);

    @Autowired
    UserService userService;

    @PostMapping("/sign-up")
    public Map<String, Object> signUp(@RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        try {
            userService.register(params);
            result.put("success", true);
        } catch (IllegalArgumentException e) {
            logger.error("회원가입 실패, email : {}, msg : {}", params.get("email"), e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @PostMapping("/sign-in")
    public Map<String, Object> login(HttpSession session, @RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> info = userService.login(params);
            SessionUtil.setLoginUser(session, info);
            logger.info("로그인 성공, email : {}", params.get("email"));
            result.put("success", true);
            result.put("returnUrl", "/index");
        } catch (IllegalArgumentException e) {
            logger.error("로그인 실패, email : {}, msg : {}", params.get("email"), e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @GetMapping("/my-info")
    public Map<String, Object> memberInfo(HttpSession session) {
        String email = SessionUtil.getLoginEmail(session);
        if (email == null) {
            return null;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("email", email);
        Map<String, Object> info = userService.info(params);
        if (info != null) {
            // 비밀번호 해시는 응답에서 제외
            info.remove("password");
        }
        return info;
    }

    @PutMapping("/logout")
    public void logout(HttpSession session) {
        SessionUtil.clearSession(session);
    }

    // 이름/연락처/주소/알림수신 저장
    @PatchMapping("/profile")
    public int updateProfile(HttpSession session, @RequestBody Map<String, Object> params) {
        String email = SessionUtil.getLoginEmail(session);
        if (email == null) {
            return 0;
        }
        params.put("email", email);
        params.remove("password");
        try {
            userService.updateProfile(params);
            return 1;
        } catch (RuntimeException e) {
            logger.error("프로필 저장 실패, email : {}, msg : {}", email, e.getMessage());
            return 0;
        }
    }

    @PatchMapping("/update")
    public int updatePassword(HttpSession session, @RequestBody Map<String, Object> params) {
        int retNum = 0;
        String email = SessionUtil.getLoginEmail(session);
        if (email == null) {
            return retNum;
        }
        params.put("email", email);
        try {
            userService.updatePassword(params);
            retNum = 1;
        } catch (RuntimeException e) {
            logger.error("updatePassword 실패, email : {}, msg : {}", email, e.getMessage());
        }
        return retNum;
    }

    @DeleteMapping
    public int delete(HttpSession session, @RequestBody Map<String, Object> params) {
        int retNum = 0;
        String email = SessionUtil.getLoginEmail(session);
        if (email == null) {
            return retNum;
        }
        // 본인 계정만 탈퇴 가능하도록 세션 이메일 사용
        params.put("email", email);
        try {
            userService.delete(params);
            retNum = 1;
            SessionUtil.clearSession(session);
        } catch (RuntimeException e) {
            logger.error("회원 삭제 실패, email : {}, msg : {}", email, e.getMessage());
        }
        return retNum;
    }

    @PostMapping("/chkDupl")
    public int chkDupl(@RequestBody Map<String, Object> params) {
        int retNum = 0;
        Map<String, Object> chkParams = new HashMap<>();
        chkParams.put("email", params.get("email"));
        if (userService.info(chkParams) != null) {
            retNum = 1;
        }
        return retNum;
    }
}
