package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ShowsMapper {

    List<Map<String, Object>> list(Map<String, Object> params);

    // 메인 오픈예정
    List<Map<String, Object>> openSoon(Map<String, Object> params);

    int count(Map<String, Object> params);

    // 공연명/장소 키워드 검색
    List<Map<String, Object>> search(Map<String, Object> params);

    Map<String, Object> info(Map<String, Object> params);


    // 티켓셀러 본인 공연
    List<Map<String, Object>> mine(Map<String, Object> params);

    int mineCount(Map<String, Object> params);

    int insert(Map<String, Object> params);

    int update(Map<String, Object> params);

    int softDelete(Map<String, Object> params);


    // 업로드 포스터 고아 파일 판별용
    List<String> allPosterLinks();

}