package com.heeji.picket.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface ShowLikesRepository {

    // 특정 공연에 대해 유저가 이미 좋아요 했는지 조회
    int likeYn(Map<String, Object> params);

    // 공연 별 좋아요 수 조회
    int likeTotCnt(Map<String, Object> params);

    // 유저의 좋아요 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params);

    // 유저의 좋아요 수 조회
    int likeCnt(Map<String, Object> params);

    // 좋아요 등록
    int insert(Map<String, Object> params);

    // 좋아요 삭제
    int delete(Map<String, Object> params);

}