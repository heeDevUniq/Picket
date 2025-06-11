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
    public String register(Model model) {
        log.debug("register진입");
        if(model.containsAttribute("email")) {
            String email = (String) model.getAttribute("email"); // 직접 getAttribute()는 안 됨, 아래처럼 꺼내야 함
        }
        return "user/signup";
    }

}
