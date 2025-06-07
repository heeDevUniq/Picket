package com.heeji.picket.controller;

import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Map;

@Controller
@Log4j2
public class UserController {

    @GetMapping("/login")
    public String loginForm() {
        log.debug("login진입");
        return "user/login";
    }

    @GetMapping("/signup")
    public String register(HttpSession session, Model model) {
        log.debug("register진입");
        System.out.println("///////// register진입 ////////// : " + session);
        Map<String, Object> userMap = null;
        if (session != null) {
            userMap = SessionUtil.getLoginUser(session);
            System.out.println("///////// userMap ////////// : " + userMap);
        }
        model.addAttribute("session", userMap);
        return "user/signup";
    }

}
