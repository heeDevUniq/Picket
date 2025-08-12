package com.heeji.picket.controller.api;

import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.utils.SessionUtil;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpSession;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


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

    @PostMapping("/like")
    @ResponseBody
    public int like(Model model, HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("like 진입");
        params.put("userId", ((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return showLikesService.like(params);
    }

    
    @PostMapping("/saveReview")
    @ResponseBody
    public int saveReview(Model model, HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("saveReview 진입");
        params.put("userId", ((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return showReviewsService.save(params);
    }

    @PostMapping("/delReview")
    @ResponseBody
    public int delReview(Model model, HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("delReview 진입");
        params.put("userId", ((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return showReviewsService.delete(params);
    }
    
    @PostMapping("/setAlarm")
    @ResponseBody
    public int setAlarm(Model model, HttpSession session, @RequestBody Map<String, Object> params) {
        logger.debug("setAlarm 진입");
        params.put("userId", ((Long)SessionUtil.getLoginUser(session).get("LOGIN_ID")));
        return userAlarmService.setAlarm(params);
    }

}
