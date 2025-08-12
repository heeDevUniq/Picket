package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ShowReviewsMapper {
    
    // 공연 별 리뷰 목록 조회
    List<Map<String, Object>> list(Map<String, Object> params);

    // 리뷰 등록
    int insert(Map<String, Object> params);

    // 리뷰 삭제
    int delete(Map<String, Object> params);

}