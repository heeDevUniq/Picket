package com.heeji.picket.controller;

import com.heeji.picket.service.SeatGradeService;
import com.heeji.picket.service.SeatService;
import com.heeji.picket.service.ShowDateService;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.utils.SessionUtil;

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

    // 장르 코드 -> 화면 표기
    private static final Map<String, String> GENRE_LABELS = Map.of(
            "musical", "뮤지컬/연극",
            "concert", "콘서트",
            "classic", "클래식/무용",
            "exhibit", "전시/행사",
            "festival", "페스티벌");

    @GetMapping("/list/{genre}")
    public String index(Model model, @PathVariable("genre") String genre, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size) {
        logger.debug("shows index 진입, genre : {}, page : {}", genre, page);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("genre", genre);
        // 장르별 목록
        Map<String, Object> paged = showsService.pagedList(params, page, size == null ? 12 : size);
        model.addAttribute("paging", paged);
        model.addAttribute("shows", paged.get("list"));
        model.addAttribute("genre", genre);
        model.addAttribute("genreLabel", GENRE_LABELS.getOrDefault(genre, "티켓"));
        // JSP 오픈 여부 비교용
        model.addAttribute("nowMillis", System.currentTimeMillis());
        return "shows/index";
    }

    @GetMapping("/view/{showId}")
    public String view(Model model, @PathVariable("showId") Long showId, HttpSession session) {
        logger.debug("shows view 진입, showId : {}", showId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", showId);
        // 좋아요/알림은 로그인 회원 기준
        params.put("userId", SessionUtil.getLoginId(session));

        model.addAttribute("show", showsService.info(params));
        model.addAttribute("showDates", showDateService.list(params));
        model.addAttribute("likeCount", showLikesService.likeTotCnt(params));
        model.addAttribute("likeMyCount", showLikesService.likeYn(params));
        model.addAttribute("alarmMyCount", userAlarmService.alarmYn(params));
        model.addAttribute("reviews", showReviewsService.list(params));
        return "shows/view";
    }

    @GetMapping("/getTickets")
    public String getTickets(Model model, @RequestParam("showDateId") Long showDateId) {
        logger.debug("getTickets 진입, showDateId : {}", showDateId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showDateId", showDateId);
        model.addAttribute("showDateId", showDateId);
        // 선택한 날짜의 공연 정보
        model.addAttribute("show", showDateService.info(params));
        model.addAttribute("grades", seatGradeService.list(params));
        model.addAttribute("seats", seatService.list(params));
        return "shows/popup/step01";
    }

    @PostMapping("/payment")
    public String payment(Model model, @RequestParam("showId") Long showId, @RequestParam("showDateId") Long showDateId, @RequestParam(value = "seatArrays", required = false) Long[] seatArrays) {
        logger.debug("payment 진입, showId : {}, showDateId : {}", showId, showDateId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", showId);
        params.put("showDateId", showDateId);

        model.addAttribute("showDateId", showDateId);
        // 선택한 날짜의 공연 정보
        model.addAttribute("show", showDateService.info(params));
        if (seatArrays != null && seatArrays.length > 0) {
            model.addAttribute("seats", seatService.selectedSeatList(seatArrays));
        }
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
