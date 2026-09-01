package com.heeji.picket.controller;

import com.heeji.picket.controller.api.ShowRestController;
import com.heeji.picket.service.ShowsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MainController {

    private static final Logger logger = LoggerFactory.getLogger(MainController.class);

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
        logger.debug("index진입");
        Map<String, Object> params = new HashMap<String, Object>();
        List<Map<String, Object>> shows = showsService.list(params);
        model.addAttribute("shows", shows);
        model.addAttribute("nowMillis", System.currentTimeMillis());
        return "index";
    }

    // 키워드 검색 결과
    @GetMapping("/search")
    public String search(Model model, @RequestParam(value = "keyword", required = false) String keyword) {
        logger.debug("search 진입, keyword : {}", keyword);
        List<Map<String, Object>> results = showsService.search(keyword, 60);
        model.addAttribute("keyword", keyword == null ? "" : keyword.trim());
        model.addAttribute("shows", results);
        model.addAttribute("nowMillis", System.currentTimeMillis());
        return "search";
    }

}
