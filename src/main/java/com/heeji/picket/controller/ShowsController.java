package com.heeji.picket.controller;

import com.heeji.picket.domain.Shows;
import com.heeji.picket.service.SeatGradeService;
import com.heeji.picket.service.SeatService;
import com.heeji.picket.service.ShowDateService;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.utils.SessionUtil;

import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@Log4j2
@RequestMapping("/shows")
public class ShowsController {

    @Autowired
    ShowsService showsService;

    @Autowired
    ShowDateService showDateService;
    
    @Autowired
    ShowLikesService showLikesService;
    
    @Autowired
    UserAlarmService userAlarmService;
    
    @Autowired
    ShowReviewsService showReviewsService;
    
    @Autowired
    SeatGradeService seatGradeService;
    
    @Autowired
    SeatService seatService;

    @GetMapping("/list/{genre}")
    public String index(Model model, @PathVariable String genre, @RequestBody Map<String, Object> params) {
        log.debug("shows index진입");
        // 선택 장르별 공연 목록
        List<HashMap<String, Object>> shows = showsService.list(params);
        model.addAttribute("shows", shows);
        return "shows/index";
    }

    @GetMapping("/view/{showsId}")
    public String view(Model model, @PathVariable Long showsId, HttpSession session, @RequestBody Map<String, Object> params) {
        log.debug("shows view 진입");
        // 이 공연 상세정보
        model.addAttribute("show", showsService.info(params));
        // 이 공연 날짜 목록
        model.addAttribute("showDates", showDateService.list(params));
        // 이 공연에 대한 좋아요 총 개수
        model.addAttribute("likeCount", showLikesService.likeTotCnt(params));
        // 이 공연에 대한 로그인 사용자의 좋아요 여부
        model.addAttribute("likeMyCount", showLikesService.likeYn(params));
        // 이 공연에 대한 로그인 사용자의 알림 여부
        model.addAttribute("alarmMyCount", userAlarmService.alarmYn(params));
        // 이 공연에 대한 리뷰 목록
        // model.addAttribute("reviews", showReviewsService.findAllByShowId(params));
        return "shows/view";
    }

    @GetMapping("/getTickets")
    public String getTickets(Model model, @RequestBody Map<String, Object> params) {
        log.debug("getTickets 진입");
        model.addAttribute("showDateId", params.get("showDateId"));
        // 이 공연 상세정보
        model.addAttribute("show", showDateService.info(params));
        // 이 공연 등급 목록
        model.addAttribute("grades", seatGradeService.list(params));
        // 좌석 목록
        model.addAttribute("seats", seatService.list(params));
        return "shows/popup/step01";
    }

    @PostMapping("/payment")
    public String payment(Model model, @RequestBody Map<String, Object> params, @RequestParam Long showId, @RequestParam Long showDateId, @RequestParam Long[] seatArrays) {
        log.debug("payment 진입");
        System.out.println("///////////////// 확인 : " + showId);
        System.out.println("///////////////// 확인 : " + showDateId);
        for(Long seat : seatArrays) {
            System.out.println("///////////////// 확인 : " + seat);
        }
        model.addAttribute("showDateId", showDateId);
        // 이 공연 상세정보
        model.addAttribute("show", showsService.info(params));
        // 사용자가 선택한 좌석 목록
        // model.addAttribute("seats", seatService.findSeatsWithSeatGradeBySeatIdIn(seatArrays));
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
