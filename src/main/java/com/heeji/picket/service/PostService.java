package com.heeji.picket.service;

import com.heeji.picket.domain.Post;
import com.heeji.picket.repository.PostRepository;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Log4j2
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Transactional(readOnly = true)
    public Page<Post> findAllByType(String postType, Pageable pageable) {
        return postRepository.findAllByType(postType, pageable);
    }

    public Post findById(Long id) {
        return postRepository.findById(id).orElse(null);
    }

    public void increaseViewCount(Long postId) {
        postRepository.increaseViewCount(postId);
    }

    public Post save(Post post) {
        if (post.getPostId() == null) {
            return postRepository.save(post);
        }

        Optional<Post> existingPostOpt = postRepository.findById(post.getPostId());

        if (existingPostOpt.isPresent()) {
            Post existingPost = existingPostOpt.get();
            existingPost.setTitle(post.getTitle());
            existingPost.setContent(post.getContent());
            return postRepository.save(existingPost);
        } else {
            return postRepository.save(post);
        }
    }

    public int deleteById(Long id) {
        int delNum = 0;
        if (postRepository.existsById(id)) {
            postRepository.deleteById(id);
            delNum = 1;
        }
        return delNum;
    }

}