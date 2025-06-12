package com.heeji.picket.controller;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Log4j2
public class BoardController {

    @GetMapping("/notice")
    public String notice(Model model) {
        log.debug("notice index 진입");
        model.addAttribute("boardType", "notice");
        return "board/index";
    }

    @GetMapping("/open")
    public String open(Model model) {
        log.debug("open index 진입");
        model.addAttribute("boardType", "open");
        return "board/index";
    }

    @GetMapping("/{boardType}/view")
    public String view(Model model, @PathVariable String boardType) {
        log.debug("board view 진입");
        model.addAttribute("boardType", boardType);
        return "board/view";
    }

    @GetMapping("/{boardType}/write")
    public String write(Model model, @PathVariable String boardType) {
        log.debug("board write 진입");
        model.addAttribute("boardType", boardType);
        return "board/write";
    }

}
