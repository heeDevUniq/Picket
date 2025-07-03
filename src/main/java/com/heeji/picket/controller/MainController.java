package com.heeji.picket.controller;

import com.heeji.picket.domain.Shows;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Log4j2
public class MainController {

    private final ShowsService showsService;

    public MainController(ShowsService showsService) {
        this.showsService = showsService;
    }

    @GetMapping("/")
    public String home(Model model) {
        return index(0, 10, model);
    }

    @GetMapping("/index")
    public String index(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size, Model model) {
        log.debug("index진입");
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "insertDate"));
        Page<Shows> shows = showsService.findAll(pageable);
        model.addAttribute("shows", shows);
        return "index";
    }

}
