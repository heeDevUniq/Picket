package com.heeji.picket.controller;

import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j2
public class MainController {

    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        return index(session, model);
    }

    @GetMapping("/index")
    public String index(HttpSession session, Model model) {
        log.debug("index진입");
        model.addAttribute("session", SessionUtil.getLoginUser(session));
        return "index";
    }

}
