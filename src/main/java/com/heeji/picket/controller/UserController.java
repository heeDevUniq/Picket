package com.heeji.picket.controller;

import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    UserService userService;

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
        // 소셜 로그인 시 flash attribute 로 email/providerType 전달
        if (!model.containsAttribute("providerType")) {
            model.addAttribute("providerType", "");
        }
        return "user/signup";
    }

    // 나의 예매/취소 내역
    @GetMapping("/myTickets")
    public String myTickets(HttpSession session, Model model) {
        logger.debug("myTickets진입");
        if (!SessionUtil.isLogin(session)) {
            return "redirect:/login";
        }
        this.setMyCount(session, model);
        return "user/myTickets";
    }

    // 나의 관심 공연 목록
    @GetMapping("/myLikes")
    public String myLikes(HttpSession session, Model model) {
        logger.debug("myLikes진입");
        if (!SessionUtil.isLogin(session)) {
            return "redirect:/login";
        }
        Map<String, Object> params = this.setMyCount(session, model);
        model.addAttribute("likes", showLikesService.list(params));
        return "user/myLikes";
    }

    // 나의 티켓팅 알림 목록
    @GetMapping("/myAlarms")
    public String myAlarms(HttpSession session, Model model) {
        logger.debug("myAlarms진입");
        if (!SessionUtil.isLogin(session)) {
            return "redirect:/login";
        }
        Map<String, Object> params = this.setMyCount(session, model);
        model.addAttribute("alarms", userAlarmService.list(params));
        return "user/myAlarms";
    }

    // 회원정보수정
    @GetMapping("/myInfo")
    public String myInfo(HttpSession session, Model model) {
        logger.debug("myInfo진입");
        if (!SessionUtil.isLogin(session)) {
            return "redirect:/login";
        }
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("email", SessionUtil.getLoginEmail(session));
        model.addAttribute("user", userService.info(params));
        return "user/myInfo";
    }

    // 마이페이지 공통 카운트
    private Map<String, Object> setMyCount(HttpSession session, Model model) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", SessionUtil.getLoginId(session));
        model.addAttribute("myLikeCount", showLikesService.likeCnt(params));
        model.addAttribute("myAlarmCount", userAlarmService.alarmCnt(params));
        return params;
    }

}
