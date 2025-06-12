package com.heeji.picket.controller;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Log4j2
@RequestMapping("/shows")
public class ShowsController {

    @GetMapping("/list")
    public String list(Model model) {
        log.debug("shows index진입");
        return "shows/index";
    }

    @GetMapping("/view")
    public String view(Model model) {
        log.debug("shows view 진입");
        return "shows/view";
    }

    @GetMapping("/{step}/getTickets")
    public String getTickets(Model model, @PathVariable String step) {
        log.debug("getTickets 진입");
        return "shows/popup/" + step;
    }

    @GetMapping("/my/list")
    public String myList(Model model) {
        log.debug("myList 진입");
        return "myShows/index";
    }

    @GetMapping("/my/write")
    public String myWrite(Model model) {
        log.debug("myWrite 진입");
        return "myShows/write";
    }

}
