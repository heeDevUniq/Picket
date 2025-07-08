package com.heeji.picket.controller;

import com.heeji.picket.domain.ShowLikes;
import com.heeji.picket.domain.Shows;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
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
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@Log4j2
@RequestMapping("/shows")
public class ShowsController {

    private final ShowsService showsService;
    private final ShowLikesService showLikesService;
    private final ShowReviewsService showReviewsService;
    

    public ShowsController(ShowsService showsService, ShowLikesService showLikesService, ShowReviewsService showReviewsService) {
        this.showsService = showsService;
        this.showLikesService = showLikesService;
        this.showReviewsService = showReviewsService;
    }

    @GetMapping("/list/{genre}")
    public String index(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size, Model model, @PathVariable String genre) {
        log.debug("shows index진입");
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "insertDate"));
        // 선택 장르별 공연 목록
        Page<Shows> shows = showsService.findAllByGenre(genre, pageable);
        model.addAttribute("shows", shows);
        return "shows/index";
    }

    @GetMapping("/view/{showsId}")
    public String view(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size, Model model, @PathVariable Long showsId) {
        log.debug("shows view 진입");
        // 이 공연 상세정보
        model.addAttribute("show", showsService.findById(showsId));
        // 이 공연에 대한 좋아요 총 개수
        model.addAttribute("likeCount", showLikesService.countByShowId(showsId));
        // 이 공연에 대한 리뷰 목록
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "insertDate"));
        model.addAttribute("reviews", showReviewsService.findAllByShowId(showsId, pageable));
        return "shows/view";
    }

    @GetMapping("/getTickets")
    public String getTickets(Model model, @RequestBody Map<String, Object> params) {
        log.debug("getTickets 진입");
        return "shows/popup/step01";
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
