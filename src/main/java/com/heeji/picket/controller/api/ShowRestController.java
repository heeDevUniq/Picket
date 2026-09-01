package com.heeji.picket.controller.api;

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
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;


@RestController
@RequestMapping("/shows/api")
public class ShowRestController {

    private static final Logger logger = LoggerFactory.getLogger(ShowRestController.class);

    @Autowired
    ShowsService showsService;

    @Autowired
    ShowLikesService showLikesService;

    @Autowired
    ShowReviewsService showReviewsService;

    @Autowired
    UserAlarmService userAlarmService;

    // 메인 랭킹 탭 전환용
    @GetMapping("/list")
    public List<Map<String, Object>> list(@RequestParam(value = "genre", required = false) String genre) {
        Map<String, Object> params = new HashMap<>();
        params.put("genre", genre);
        return showsService.list(params);
    }

    // 자동완성
    @GetMapping("/search")
    public List<Map<String, Object>> search(@RequestParam(value = "keyword", required = false) String keyword) {
        return showsService.search(keyword, 8);
    }

    @PostMapping("/like")
    public int like(HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("like 진입, params : {}", params);
        this.setLoginId(session, params);
        return showLikesService.like(params);
    }

    @PostMapping("/saveReview")
    public int saveReview(HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("saveReview 진입, params : {}", params);
        this.setLoginId(session, params);
        return showReviewsService.save(params);
    }

    @PostMapping("/delReview")
    public int delReview(HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("delReview 진입, params : {}", params);
        this.setLoginId(session, params);
        return showReviewsService.delete(params);
    }

    @PostMapping("/setAlarm")
    public int setAlarm(HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("setAlarm 진입, params : {}", params);
        this.setLoginId(session, params);
        return userAlarmService.setAlarm(params);
    }

    // 비로그인이면 401
    private void setLoginId(HttpSession session, Map<String, Object> params) {
        Long loginId = SessionUtil.getLoginId(session);
        if (loginId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        params.put("userId", loginId);
    }

}
