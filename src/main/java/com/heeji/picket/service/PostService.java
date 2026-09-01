package com.heeji.picket.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.PostMapper;
import com.heeji.picket.utils.Paging;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PostService {

    @Autowired
    private PostMapper postRepository;

    public Map<String, Object> list(Map<String, Object> params, Integer page, Integer size) {
        int[] ps = Paging.apply(params, page, size);
        int total = postRepository.count(params);
        List<Map<String, Object>> list = postRepository.list(params);
        return Paging.wrap(list, total, ps[0], ps[1]);
    }

    public Map<String, Object> info(Map<String, Object> params) {
        if (toPostId(params) == null) {
            return null;
        }
        return postRepository.info(params);
    }

    public void increaseViewCount(Map<String, Object> params) {
        if (toPostId(params) == null) {
            return;
        }
        postRepository.increaseViewCount(params);
    }

    public int save(Map<String, Object> params) {
        if (this.info(params) != null) {
            return postRepository.update(params);
        } else {
            return postRepository.insert(params);
        }
    }

    public int deleteById(Map<String, Object> params) {
        int delNum = 0;
        if (this.info(params) != null) {
            postRepository.delete(params);
            delNum = 1;
        }
        return delNum;
    }

    // 신규 등록 시 postId 가 빈 문자열로 넘어오므로 Long 으로 정규화
    private Long toPostId(Map<String, Object> params) {
        Object raw = params.get("postId");
        if (raw == null || raw.toString().trim().isEmpty()) {
            params.put("postId", null);
            return null;
        }
        try {
            Long postId = Long.valueOf(raw.toString().trim());
            params.put("postId", postId);
            return postId;
        } catch (NumberFormatException e) {
            params.put("postId", null);
            return null;
        }
    }

}
