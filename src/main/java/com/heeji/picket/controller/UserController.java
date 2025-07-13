package com.heeji.picket.controller;

import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j2
public class UserController {

    private final UserService userService;
    private final ShowsService showsService;
    private final ShowLikesService showLikesService;
    private final UserAlarmService userAlarmService;
    

    public UserController(UserService userService, ShowsService showsService, ShowLikesService showLikesService, UserAlarmService userAlarmService) {
        this.userService = userService;
        this.showsService = showsService;
        this.showLikesService = showLikesService;
        this.userAlarmService = userAlarmService;
    }

    // 로그인 화면
    @GetMapping("/login")
    public String loginForm() {
        log.debug("login진입");
        return "user/login";
    }

    // 회원가입 화면
    @GetMapping("/signup")
    public String register(Model model) {
        log.debug("register진입");
        if(model.containsAttribute("email")) {
            String email = (String) model.getAttribute("email");
            model.addAttribute("providerType", "kakao");
        }
        return "user/signup";
    }

    // 나의 예매/취소 내역
    @GetMapping("/myTickets")
    public String myTickets(HttpSession session, Model model) {
        log.debug("myTickets진입");
        model.addAttribute("myLikeCount", showLikesService.countByUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        model.addAttribute("myAlarmCount", userAlarmService.countByUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return this.sessionCheck(session, "user/myTickets");
    }

    // 나의 관심 공연 목록
    @GetMapping("/myLikes")
    public String myLikes(HttpSession session, Model model) {
        log.debug("myLikes");
        model.addAttribute("myLikeCount", showLikesService.countByUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        model.addAttribute("myAlarmCount", userAlarmService.countByUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return this.sessionCheck(session, "user/myLikes");
    }
    
    // 나의 티켓팅 알림 목록
    @GetMapping("/myAlarms")
    public String myAlarms(HttpSession session, Model model) {
        log.debug("myAlarms");
        model.addAttribute("myLikeCount", showLikesService.countByUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        model.addAttribute("myAlarmCount", userAlarmService.countByUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return this.sessionCheck(session, "user/myAlarms");
    }

    // 회원정보수정
    @GetMapping("/myInfo")
    public String myInfo(HttpSession session, Model model) {
        log.debug("myInfo진입");
        model.addAttribute("user", userService.findUser(SessionUtil.getLoginUser(session).get("LOGIN_EMAIL").toString()));
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
