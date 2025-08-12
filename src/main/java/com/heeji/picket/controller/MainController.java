package com.heeji.picket.controller;

import com.heeji.picket.service.ShowsService;
import lombok.extern.log4j.Log4j2;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j2
public class MainController {

    private final ShowsService showsService;

    public MainController(ShowsService showsService) {
        this.showsService = showsService;
    }

    @GetMapping("/")
    public String home(Model model) {
        return index(model);
    }

    @GetMapping("/index")
    public String index(Model model) {
        log.debug("index진입");
        Map<String, Object> params = new HashMap<String, Object>();
        List<HashMap<String, Object>> shows = showsService.list(params);
        model.addAttribute("shows", shows);
        return "index";
    }

}
