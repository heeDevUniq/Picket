package com.heeji.picket.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.PostMapper;

import java.util.List;
import java.util.Map;

@Service
public class PostService {

    @Autowired
    private PostMapper postRepository;

    public List<Map<String, Object>> list(Map<String, Object> params) {
        return postRepository.list(params);
    }

    public Map<String, Object> info(Map<String, Object> params) {
        return postRepository.info(params);
    }

    public void increaseViewCount(Map<String, Object> params) {
        postRepository.increaseViewCount(params);
    }

    public int save(Map<String, Object> params) {
        Map<String, Object> info = postRepository.info(params);

        if (info != null) {
            return postRepository.update(params);
        } else {
            return postRepository.insert(params);
        }
    }

    public int deleteById(Map<String, Object> params) {
        int delNum = 0;
        if (postRepository.info(params) != null) {
            postRepository.delete(params);
            delNum = 1;
        }
        return delNum;
    }

}