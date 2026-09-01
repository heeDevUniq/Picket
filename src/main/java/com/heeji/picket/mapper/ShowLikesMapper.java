package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ShowLikesMapper {

    // 좋아요 여부
    int likeYn(Map<String, Object> params);

    // 공연별 좋아요 수
    int likeTotCnt(Map<String, Object> params);

    // 내 관심공연 목록
    List<Map<String, Object>> list(Map<String, Object> params);

    // 내 관심공연 수
    int likeCnt(Map<String, Object> params);

    // 등록
    int insert(Map<String, Object> params);

    // 삭제
    int delete(Map<String, Object> params);

}