package com.heeji.picket.controller;

import com.heeji.picket.domain.Post;
import com.heeji.picket.service.PostService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@Log4j2
public class PostController {

    @Autowired
    PostService postService;

    @GetMapping("/{postType}")
    public String index(Model model, @PathVariable String postType, @RequestBody Map<String, Object> params) {
        log.debug("post index 진입");
        params.put("postType", postType);
        List<HashMap<String, Object>> posts = postService.list(params);

        System.out.println("////////////////post index : " + posts);

        model.addAttribute("posts", posts);
        model.addAttribute("postType", postType);
        return "post/index";
    }

    @GetMapping("/{postType}/view")
    public String view(HttpSession session, Model model, @PathVariable String postType, @RequestBody Map<String, Object> params) {
        log.debug("post view 진입");
        params.put("postType", postType);
        // 조회수 증가
        postService.increaseViewCount(params);
        model.addAttribute("post", postService.info(params));
        model.addAttribute("postType", postType);
        return "post/view";
    }

    @GetMapping("/{postType}/write")
    public String write(Model model, @PathVariable String postType, @RequestBody Map<String, Object> params) {
        log.debug("post write 진입");
        params.put("postType", postType);
        model.addAttribute("post", postService.info(params));
        model.addAttribute("postType", postType);
        return "post/write";
    }

    @PostMapping("/{postType}/save")
    @ResponseBody
    public int save(@PathVariable String postType, @RequestBody Map<String, Object> params) {
        params.put("postType", postType);
        return postService.save(params);
    }

    @PostMapping("/{postType}/delete")
    @ResponseBody
    public int delete(@PathVariable String postType, @RequestBody Map<String, Object> params) {
        params.put("postType", postType);
        return postService.deleteById(params);
    }

}