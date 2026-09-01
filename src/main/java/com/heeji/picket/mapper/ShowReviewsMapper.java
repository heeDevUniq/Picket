package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ShowReviewsMapper {
    
    // 공연별 리뷰 목록
    List<Map<String, Object>> list(Map<String, Object> params);

    // 등록
    int insert(Map<String, Object> params);

    // 삭제
    int delete(Map<String, Object> params);

}