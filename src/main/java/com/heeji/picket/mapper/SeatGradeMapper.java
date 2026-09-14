package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SeatGradeMapper {

    List<Map<String, Object>> list(Map<String, Object> params);


    int insert(Map<String, Object> params);

    int deleteByShowId(Long showId);


    // 수정 화면용 등급 구성
    List<Map<String, Object>> listByShowId(Long showId);

}