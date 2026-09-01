package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserAlarmMapper {

    // 알림 설정 여부
    int alarmYn(Map<String, Object> params);

    // 내 알림 목록
    List<Map<String, Object>> list(Map<String, Object> params);

    // 내 알림 수
    int alarmCnt(Map<String, Object> params);

    // 등록
    int insert(Map<String, Object> params);

    // 삭제
    int delete(Map<String, Object> params);

}