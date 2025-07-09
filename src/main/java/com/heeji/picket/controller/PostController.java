package com.heeji.picket.controller;

import com.heeji.picket.domain.Post;
import com.heeji.picket.service.PostService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    public String view(HttpSession session, Model model, @PathVariable String postType, @PathVariable Long postId) {
        log.debug("post view 진입");
        // 조회수 증가
        postService.increaseViewCount(postId);
        model.addAttribute("post", postService.findById(postId));
        model.addAttribute("postType", postType);
        return "post/view";
    }

    @GetMapping("/{postType}/write/{postId}")
    public String write(Model model, @PathVariable String postType, @PathVariable Long postId) {
        log.debug("post write 진입");
        model.addAttribute("post", postService.findById(postId));
        model.addAttribute("postType", postType);
        return "post/write";
    }

    @PostMapping("/{postType}/save")
    @ResponseBody
    public Post save(@RequestBody Post post, @PathVariable String postType) {
        return postService.save(post);
    }

    @PostMapping("/{postType}/delete")
    @ResponseBody
    public int delete(@RequestBody Post post, @PathVariable String postType) {
        return postService.deleteById(post.getPostId());
    }

}