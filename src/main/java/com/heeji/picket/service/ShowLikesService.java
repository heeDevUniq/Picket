package com.heeji.picket.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowLikesMapper;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ShowLikesService {

    @Autowired
    private ShowLikesMapper showLikesRepository;

    // 좋아요하기
    public int like(Map<String, Object> params) {
        int likeYn = showLikesRepository.likeYn(params);

        if (likeYn > 0) {
            // 이미 좋아요 되어있으면 삭제
            showLikesRepository.delete(params);
            return 0;
        } else {
            // 좋아요 안 되어 있으면 등록
            return showLikesRepository.insert(params);
        }
    }

    // 특정 공연에 로그인 유저의 좋아요 여부 조회
    public int likeYn(Map<String, Object> params) {
        return showLikesRepository.likeYn(params);
    }

    // 공연별 좋아요 수 조회
    public int likeTotCnt(Map<String, Object> params) {
        return showLikesRepository.likeTotCnt(params);
    }

    // 유저의 좋아요 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params) {
        return showLikesRepository.list(params);
    }
    
    // 유저의 좋아요 개수 조회
    public int likeCnt(Map<String, Object> params) {
        return showLikesRepository.likeCnt(params);
    }

}