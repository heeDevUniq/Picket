package com.heeji.picket.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository {

    // 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params);

    // 상세 조회
    HashMap<String, Object> info(Map<String, Object> params);

    // 조회수 증가
    int increaseViewCount(Map<String, Object> params);

    // 공지사항/예매안내 등록
    int insert(Map<String, Object> params);

    // 공지사항/예매안내 수정
    int update(Map<String, Object> params);

    // 공지사항/예매안내 삭제
    int delete(Map<String, Object> params);
    
}