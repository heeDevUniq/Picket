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
import com.heeji.picket.utils.HtmlSanitizer;
import com.heeji.picket.utils.SessionUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PostController {

    private static final Logger logger = LoggerFactory.getLogger(PostController.class);

    @Autowired
    PostService postService;

    @GetMapping("/{postType:notice|open}")
    public String index(Model model, HttpSession session, @PathVariable("postType") String postType, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "keyword", required = false) String keyword) {
        logger.debug("post index 진입, postType : {}, page : {}, keyword : {}", postType, page, keyword);
        Map<String, Object> params = new HashMap<>();
        params.put("postType", postType);
        params.put("keyword", keyword);
        model.addAttribute("posts", postService.list(params, page, size));
        model.addAttribute("postType", postType);
        model.addAttribute("canWrite", isSeller(session));
        model.addAttribute("keyword", keyword);
        // 목록에서 NEW 배지 기준
        model.addAttribute("nowMillis", System.currentTimeMillis());
        return "post/index";
    }

    @GetMapping("/{postType:notice|open}/view/{postId}")
    public String view(Model model, HttpSession session, @PathVariable("postType") String postType, @PathVariable("postId") Long postId) {
        logger.debug("post view 진입, postId : {}", postId);
        Map<String, Object> params = new HashMap<>();
        params.put("postType", postType);
        params.put("postId", postId);
        postService.increaseViewCount(params);

        Map<String, Object> post = postService.info(params);
        model.addAttribute("post", post);
        model.addAttribute("postType", postType);
        // 수정·삭제 버튼은 글쓴이에게만
        model.addAttribute("canEdit", isOwner(session, post));
        return "post/view";
    }

    @GetMapping("/{postType:notice|open}/write/{postId}")
    public String write(Model model, HttpSession session, HttpServletRequest request, @PathVariable("postType") String postType, @PathVariable("postId") Long postId) {
        logger.debug("post write 진입, postId : {}", postId);
        if (!SessionUtil.isLogin(session)) {
            SessionUtil.setReturnUrl(session, request.getRequestURI());
            return "redirect:/login";
        }
        if (!isSeller(session)) {
            return "redirect:/" + postType;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("postId", postId);
        params.put("postType", postType);

        Map<String, Object> post = postService.info(params);
        if (post != null && !isOwner(session, post)) {
            return "redirect:/" + postType + "/view/" + postId;
        }
        model.addAttribute("post", post);
        model.addAttribute("postType", postType);
        return "post/write";
    }

    @PostMapping("/{postType:notice|open}/save")
    @ResponseBody
    public int save(HttpSession session, @PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        logger.debug("post save 진입, postId : {}", params.get("postId"));
        if (!isSeller(session)) {
            logger.warn("게시글 저장 권한 없음, loginId : {}", SessionUtil.getLoginId(session));
            return 0;
        }
        params.put("postType", postType);
        params.put("loginId", SessionUtil.getLoginId(session));

        // 수정이면 글쓴이만
        Map<String, Object> post = postService.info(params);
        if (post != null && !isOwner(session, post)) {
            logger.warn("게시글 수정 권한 없음, postId : {}, loginId : {}", params.get("postId"), SessionUtil.getLoginId(session));
            return 0;
        }
        params.put("content", HtmlSanitizer.clean((String) params.get("content")));
        return postService.save(params);
    }

    @PostMapping("/{postType:notice|open}/delete")
    @ResponseBody
    public int delete(HttpSession session, @PathVariable("postType") String postType, @RequestBody Map<String, Object> params) {
        logger.debug("post delete 진입, postId : {}", params.get("postId"));
        if (!isSeller(session)) {
            return 0;
        }
        params.put("postType", postType);

        Map<String, Object> post = postService.info(params);
        if (post == null || !isOwner(session, post)) {
            logger.warn("게시글 삭제 권한 없음, postId : {}, loginId : {}", params.get("postId"), SessionUtil.getLoginId(session));
            return 0;
        }
        return postService.deleteById(params);
    }

    // 공지·예매오픈안내는 운영 글이라 티켓셀러만
    private boolean isSeller(HttpSession session) {
        return SessionUtil.isLogin(session) && "seller".equals(session.getAttribute("LOGIN_ROLE"));
    }

    private boolean isOwner(HttpSession session, Map<String, Object> post) {
        Long loginId = SessionUtil.getLoginId(session);
        if (loginId == null || post == null || post.get("insertId") == null) {
            return false;
        }
        return loginId.longValue() == ((Number) post.get("insertId")).longValue();
    }

}
