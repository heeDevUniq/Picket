package com.heeji.picket.service;

import com.heeji.picket.repository.PostRepository;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Log4j2
public class PostService {

    @Autowired
    private PostRepository postRepository;

    public List<HashMap<String, Object>> list(Map<String, Object> params) {
        return postRepository.list(params);
    }

    public HashMap<String, Object> info(Map<String, Object> params) {
        return postRepository.info(params);
    }

    public void increaseViewCount(Map<String, Object> params) {
        postRepository.increaseViewCount(params);
    }

    public int save(Map<String, Object> params) {
        HashMap<String, Object> info = postRepository.info(params);

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