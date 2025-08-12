package com.heeji.picket.repository;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface ShowReviewsRepository {
    
    // 공연 별 리뷰 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params);

    // 리뷰 등록
    int insert(Map<String, Object> params);

    // 리뷰 삭제
    int delete(Map<String, Object> params);

}