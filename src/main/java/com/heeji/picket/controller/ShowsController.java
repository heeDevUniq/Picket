package com.heeji.picket.controller;

import com.heeji.picket.domain.Post;
import com.heeji.picket.domain.Shows;
import com.heeji.picket.service.PostService;
import com.heeji.picket.service.ShowsService;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Log4j2
@RequestMapping("/shows")
public class ShowsController {

    private final ShowsService showsService;

    public ShowsController(ShowsService showsService) {
        this.showsService = showsService;
    }

    @GetMapping("/list/{genre}")
    public String index(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size, Model model, @PathVariable String genre) {
        log.debug("shows index진입");
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "insertDate"));
        Page<Shows> shows = showsService.findAllByGenre(genre, pageable);
        model.addAttribute("shows", shows);
        return "shows/index";
    }

    @GetMapping("/view/{showsId}")
    public String view(Model model, @PathVariable Long showsId) {
        log.debug("shows view 진입");
        model.addAttribute("show", showsService.findById(showsId));
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
