package com.heeji.picket.controller.api;

import com.heeji.picket.domain.ShowLikes;
import com.heeji.picket.domain.ShowReviews;
import com.heeji.picket.domain.User;
import com.heeji.picket.domain.UserAlarm;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.utils.SessionUtil;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/shows/api")
@Log4j2
public class ShowRestController {

    private final ShowsService showsService;
    private final ShowLikesService showLikesService;
    private final ShowReviewsService showReviewsService;
    private final UserAlarmService userAlarmService;

    public ShowRestController(ShowsService showsService, ShowLikesService showLikesService, ShowReviewsService showReviewsService, UserAlarmService userAlarmService) {
        this.showsService = showsService;
        this.showLikesService = showLikesService;
        this.showReviewsService = showReviewsService;
        this.userAlarmService = userAlarmService;
    }

    @PostMapping("/like")
    @ResponseBody
    public ShowLikes like(Model model, @RequestBody ShowLikes showLikes, HttpSession session) {
        log.debug("like 진입");
        showLikes.setUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID"));
        return showLikesService.like(showLikes);
    }

    
    @PostMapping("/saveReview")
    @ResponseBody
    public ShowReviews saveReview(Model model, @RequestBody ShowReviews showReviews, HttpSession session) {
        log.debug("saveReview 진입");
        showReviews.setUser((User)SessionUtil.getLoginUser(session).get("USER"));
        return showReviewsService.save(showReviews);
    }

    @PostMapping("/delReview")
    @ResponseBody
    public int delReview(Model model, @RequestBody ShowReviews showReviews, HttpSession session) {
        log.debug("delReview 진입");
        showReviews.setUser((User)SessionUtil.getLoginUser(session).get("USER"));
        return showReviewsService.deleteById(showReviews.getReviewId());
    }
    
    @PostMapping("/setAlarm")
    @ResponseBody
    public UserAlarm setAlarm(Model model, @RequestBody UserAlarm userAlarm, HttpSession session) {
        log.debug("setAlarm 진입");
        userAlarm.setUserId((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID"));
        return userAlarmService.setAlarm(userAlarm);
    }

}
