package com.heeji.picket.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.heeji.picket.service.PostService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PostController {

    private static final Logger logger = LoggerFactory.getLogger(PostController.class);

    @Autowired
    PostService postService;

    @GetMapping("/{postType}")
    public String index(Model model, @PathVariable("postType") String postType) {
        logger.debug("post index 진입");
        Map<String, Object> params = new HashMap<>();
        params.put("postType", postType);
        model.addAttribute("posts", postService.list(params));
        model.addAttribute("postType", postType);
        return "post/index";
    }

    @GetMapping("/{postType}/view")
    public String view(HttpSession session, Model model, @PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        logger.debug("post view 진입");
        params.put("postType", postType);
        // 조회수 증가
        postService.increaseViewCount(params);
        model.addAttribute("post", postService.info(params));
        model.addAttribute("postType", postType);
        return "post/view";
    }

    @GetMapping("/{postType}/write/{postId}")
    public String write(Model model, @PathVariable("postType") String postType, @PathVariable("postId") Long postId) {
    	Map<String, Object> params = new HashMap<>();
        logger.debug("post write 진입");
        params.put("postId", postId);
        params.put("postType", postType);
        model.addAttribute("post", postService.info(params));
        model.addAttribute("postType", postType);
        return "post/write";
    }

    @PostMapping("/{postType}/save")
    @ResponseBody
    public int save(@PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        params.put("postType", postType);
        return postService.save(params);
    }

    @PostMapping("/{postType}/delete")
    @ResponseBody
    public int delete(@PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        params.put("postType", postType);
        return postService.deleteById(params);
    }

}