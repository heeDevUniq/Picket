package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowReviewsMapper;

@Service
public class ShowReviewsService {

    @Autowired
    private ShowReviewsMapper showReviewsRepository;

    // 공연 별 리뷰 조회
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return showReviewsRepository.list(params);
    }

    // 리뷰 등록
    public int save(Map<String, Object> params) {
        return showReviewsRepository.insert(params);
    }

    // 리뷰 삭제
    public int delete(Map<String, Object> params) {
        return showReviewsRepository.delete(params);
    }

}