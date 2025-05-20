package com.heeji.picket.controller;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j2
public class MainController {

    @GetMapping("/")
    public String home() {
        return index();
    }

    @GetMapping("/index")
    public String index() {
        log.debug("index진입");
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        log.debug("login진입");
        return "login";
    }

}
