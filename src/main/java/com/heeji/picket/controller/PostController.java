package com.heeji.picket.controller;

import com.heeji.picket.domain.Post;
import com.heeji.picket.service.PostService;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Log4j2
public class PostController {

    private final PostService postService;

    public PostController(PostService postService) {
        this.postService = postService;
    }

    @GetMapping("/{postType}")
    public String index(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size, @RequestParam(required = false) String keyword, Model model, @PathVariable String postType) {
        log.debug("post index 진입");
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "insertDate"));
        Page<Post> posts = postService.findAllByType(postType, pageable);

        System.out.println("////////////////post index : " + posts);

        model.addAttribute("posts", posts);
        model.addAttribute("postType", postType);
        return "post/index";
    }

    @GetMapping("/{postType}/view/{postId}")
    public String view(Model model, @PathVariable String postType, @PathVariable Long postId) {
        log.debug("post view 진입");
        model.addAttribute("post", postService.findById(postId));
        model.addAttribute("postType", postType);
        return "post/view";
    }

    @GetMapping("/{boardType}/write/{postId}")
    public String write(Model model, @PathVariable String postType, @PathVariable Long postId) {
        log.debug("post write 진입");
        model.addAttribute("postType", postType);
        model.addAttribute("postType", postService.findById(postId));
        return "post/write";
    }

}