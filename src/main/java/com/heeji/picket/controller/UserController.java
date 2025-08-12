package com.heeji.picket.controller;

import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    UserService userService;
    
    @Autowired
    ShowsService showsService;
    
    @Autowired
    ShowLikesService showLikesService;
    
    @Autowired
    UserAlarmService userAlarmService;

    // 로그인 화면
    @GetMapping("/login")
    public String loginForm() {
        logger.debug("login진입");
        return "user/login";
    }

    // 회원가입 화면
    @GetMapping("/signup")
    public String register(Model model) {
        logger.debug("register진입");
        if(model.containsAttribute("email")) {
            String email = (String) model.getAttribute("email");
            model.addAttribute("providerType", "kakao");
        }
        return "user/signup";
    }

    // 나의 예매/취소 내역
    @GetMapping("/myTickets")
    public String myTickets(HttpSession session, Model model, @RequestBody Map<String, Object> params) {
        logger.debug("myTickets진입");
        params.put("userId", (Long)SessionUtil.getLoginUser(session).get("LOGIN_ID"));
        model.addAttribute("myLikeCount", showLikesService.likeCnt(params));
        model.addAttribute("myAlarmCount", userAlarmService.alarmCnt(params));
        return this.sessionCheck(session, "user/myTickets");
    }

    // 나의 관심 공연 목록
    @GetMapping("/myLikes")
    public String myLikes(HttpSession session, Model model, @RequestBody Map<String, Object> params) {
        logger.debug("myLikes");
        params.put("userId", (Long)SessionUtil.getLoginUser(session).get("LOGIN_ID"));
        model.addAttribute("myLikeCount", showLikesService.likeCnt(params));
        model.addAttribute("myAlarmCount", userAlarmService.alarmCnt(params));
        return this.sessionCheck(session, "user/myLikes");
    }
    
    // 나의 티켓팅 알림 목록
    @GetMapping("/myAlarms")
    public String myAlarms(HttpSession session, Model model, @RequestBody Map<String, Object> params) {
        logger.debug("myAlarms");
        params.put("userId", (Long)SessionUtil.getLoginUser(session).get("LOGIN_ID"));
        model.addAttribute("myLikeCount", showLikesService.likeCnt(params));
        model.addAttribute("myAlarmCount", userAlarmService.alarmCnt(params));
        return this.sessionCheck(session, "user/myAlarms");
    }

    // 회원정보수정
    @GetMapping("/myInfo")
    public String myInfo(HttpSession session, Model model, @RequestBody Map<String, Object> params) {
        logger.debug("myInfo진입");
        params.put("email", (Long)SessionUtil.getLoginUser(session).get("LOGIN_EMAIL"));
        model.addAttribute("user", userService.info(params));
        return this.sessionCheck(session, "user/myInfo");
    }

    public String sessionCheck(HttpSession session, String returnUrl) {
        if (SessionUtil.getLoginUser(session).get("LOGIN_EMAIL") == null || "".equals(SessionUtil.getLoginUser(session).get("LOGIN_EMAIL"))) {
            return "user/login";
        } else {
            return returnUrl;
        }
    }

}
