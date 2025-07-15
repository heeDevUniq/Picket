package com.heeji.picket.controller;

import com.heeji.picket.domain.Shows;
import com.heeji.picket.service.SeatGradeService;
import com.heeji.picket.service.SeatService;
import com.heeji.picket.service.ShowDateService;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
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
    private final ShowDateService showDateService;
    
    private final ShowLikesService showLikesService;
    private final ShowReviewsService showReviewsService;
    
    private final SeatGradeService seatGradeService;
    private final SeatService seatService;

    public ShowsController(ShowsService showsService, ShowDateService showDateService, ShowLikesService showLikesService, ShowReviewsService showReviewsService, SeatGradeService seatGradeService, SeatService seatService) {
        this.showsService = showsService;
        this.showDateService = showDateService;

        this.showLikesService = showLikesService;
        this.showReviewsService = showReviewsService;

        this.seatGradeService = seatGradeService;
        this.seatService = seatService;
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
        // 이 공연 날짜 목록
        model.addAttribute("showDates", showDateService.findByShowId(showsId));
        // 이 공연에 대한 좋아요 총 개수
        model.addAttribute("likeCount", showLikesService.countByShowId(showsId));
        // 이 공연에 대한 리뷰 목록
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "insertDate"));
        model.addAttribute("reviews", showReviewsService.findAllByShowId(showsId, pageable));
        return "shows/view";
    }

    @GetMapping("/getTickets")
    public String getTickets(Model model, @RequestParam Long showDateId) {
        log.debug("getTickets 진입");
        Long showId = showDateService.findShowIdByShowDateId(showDateId);
        model.addAttribute("showDateId", showDateId);
        // 이 공연 상세정보
        model.addAttribute("show", showsService.findById(showId));
        // 이 공연 등급 목록
        model.addAttribute("grades", seatGradeService.findByShowDateId(showDateId));
        // 좌석 목록
        model.addAttribute("seats", seatService.findByShowDateId(showDateId));
        return "shows/popup/step01";
    }

    @PostMapping("/payment")
    public String payment(Model model, @RequestParam Long showId, @RequestParam Long showDateId, @RequestParam String[] seatArrays) {
        log.debug("payment 진입");
        System.out.println("///////////////// 확인 : " + showId);
        System.out.println("///////////////// 확인 : " + showDateId);
        System.out.println("///////////////// 확인 : " + seatArrays[0] + " / " + seatArrays[1]);
        model.addAttribute("showDateId", showDateId);
        // 이 공연 상세정보
        model.addAttribute("show", showsService.findById(showId));
        return "shows/popup/step02";
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
