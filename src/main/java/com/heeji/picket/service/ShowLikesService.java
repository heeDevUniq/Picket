package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowLikesMapper;

@Service
public class ShowLikesService {

    @Autowired
    private ShowLikesMapper showLikesRepository;

    // 좋아요 토글
    public int like(Map<String, Object> params) {
        int likeYn = showLikesRepository.likeYn(params);

        if (likeYn > 0) {
            // 이미 좋아요됨 -> 취소
            showLikesRepository.delete(params);
            return 0;
        } else {
            return showLikesRepository.insert(params);
        }
    }

    // 좋아요 여부
    public int likeYn(Map<String, Object> params) {
        return showLikesRepository.likeYn(params);
    }

    // 공연별 좋아요 수
    public int likeTotCnt(Map<String, Object> params) {
        return showLikesRepository.likeTotCnt(params);
    }

    // 내 관심공연 목록
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return showLikesRepository.list(params);
    }
    
    // 내 관심공연 수
    public int likeCnt(Map<String, Object> params) {
        return showLikesRepository.likeCnt(params);
    }

}