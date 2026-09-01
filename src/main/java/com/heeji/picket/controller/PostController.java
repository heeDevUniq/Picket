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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.heeji.picket.service.PostService;
import com.heeji.picket.utils.SessionUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class PostController {

    private static final Logger logger = LoggerFactory.getLogger(PostController.class);

    @Autowired
    PostService postService;

    @GetMapping("/{postType:notice|open}")
    public String index(Model model, @PathVariable("postType") String postType, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size) {
        logger.debug("post index 진입, postType : {}, page : {}", postType, page);
        Map<String, Object> params = new HashMap<>();
        params.put("postType", postType);
        model.addAttribute("posts", postService.list(params, page, size));
        model.addAttribute("postType", postType);
        return "post/index";
    }

    @GetMapping("/{postType:notice|open}/view/{postId}")
    public String view(Model model, @PathVariable("postType") String postType, @PathVariable("postId") Long postId) {
        logger.debug("post view 진입, postId : {}", postId);
        Map<String, Object> params = new HashMap<>();
        params.put("postType", postType);
        params.put("postId", postId);
        postService.increaseViewCount(params);
        model.addAttribute("post", postService.info(params));
        model.addAttribute("postType", postType);
        return "post/view";
    }

    @GetMapping("/{postType:notice|open}/write/{postId}")
    public String write(Model model, @PathVariable("postType") String postType, @PathVariable("postId") Long postId) {
        logger.debug("post write 진입, postId : {}", postId);
        Map<String, Object> params = new HashMap<>();
        params.put("postId", postId);
        params.put("postType", postType);
        model.addAttribute("post", postService.info(params));
        model.addAttribute("postType", postType);
        return "post/write";
    }

    @PostMapping("/{postType:notice|open}/save")
    @ResponseBody
    public int save(HttpSession session, @PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        logger.debug("post save 진입, params : {}", params);
        if (!SessionUtil.isLogin(session)) {
            return 0;
        }
        params.put("postType", postType);
        params.put("loginId", SessionUtil.getLoginId(session));
        return postService.save(params);
    }

    @PostMapping("/{postType:notice|open}/delete")
    @ResponseBody
    public int delete(HttpSession session, @PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        logger.debug("post delete 진입, params : {}", params);
        if (!SessionUtil.isLogin(session)) {
            return 0;
        }
        params.put("postType", postType);
        return postService.deleteById(params);
    }

}
