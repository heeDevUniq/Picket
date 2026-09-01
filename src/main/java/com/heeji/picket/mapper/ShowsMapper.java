package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ShowsMapper {

    List<Map<String, Object>> list(Map<String, Object> params);

    int count(Map<String, Object> params);

    // 공연명/장소 키워드 검색
    List<Map<String, Object>> search(Map<String, Object> params);

    Map<String, Object> info(Map<String, Object> params);

}