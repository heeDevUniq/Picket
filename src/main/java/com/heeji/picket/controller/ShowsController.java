package com.heeji.picket.controller;

import com.heeji.picket.service.SeatGradeService;
import com.heeji.picket.service.SeatService;
import com.heeji.picket.service.ShowDateService;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;

import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/shows")
public class ShowsController {

    private static final Logger logger = LoggerFactory.getLogger(ShowsController.class);

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
    public String index(Model model, @PathVariable String genre) {
        logger.debug("shows index진입");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("genre", genre);
        // 선택 장르별 공연 목록
        List<Map<String, Object>> shows = showsService.list(params);
        model.addAttribute("shows", shows);
        return "shows/index";
    }

    @GetMapping("/view/{showId}")
    public String view(Model model, @PathVariable Long showId, HttpSession session, @RequestParam Map<String, Object> params) {
        logger.debug("shows view 진입");
        System.out.println("확인 : " + showId);
        params.put("showId", showId);
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
    public String getTickets(Model model, @RequestParam Map<String, Object> params) {
        logger.debug("getTickets 진입");
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
    public String payment(Model model, @RequestParam Map<String, Object> params, @RequestParam Long showId, @RequestParam Long showDateId, @RequestParam Long[] seatArrays) {
        logger.debug("payment 진입");
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
        logger.debug("myList 진입");
        return "myShows/index";
    }

    @GetMapping("/my/write")
    public String myWrite(Model model) {
        logger.debug("myWrite 진입");
        return "myShows/write";
    }

}
