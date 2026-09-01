package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PostMapper {

    // 목록 (페이징)
    List<Map<String, Object>> list(Map<String, Object> params);

    // 전체 건수
    int count(Map<String, Object> params);

    // 상세
    Map<String, Object> info(Map<String, Object> params);

    // 조회수 증가
    int increaseViewCount(Map<String, Object> params);

    // 등록
    int insert(Map<String, Object> params);

    // 수정
    int update(Map<String, Object> params);

    // 삭제
    int delete(Map<String, Object> params);
    
}