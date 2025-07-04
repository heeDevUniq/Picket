package com.heeji.picket.controller;

import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j2
public class UserController {

    @GetMapping("/login")
    public String loginForm() {
        log.debug("login진입");
        return "user/login";
    }

    @GetMapping("/signup")
    public String register(Model model) {
        log.debug("register진입");
        if(model.containsAttribute("email")) {
            String email = (String) model.getAttribute("email");
            model.addAttribute("providerType", "kakao");
        }
        return "user/signup";
    }

    @GetMapping("/myTickets")
    public String myTickets(HttpSession session) {
        log.debug("myTickets진입");
        return this.sessionCheck(session, "user/myTickets");
    }

    @GetMapping("/myInfo")
    public String myInfo(HttpSession session) {
        log.debug("myInfo진입");
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
