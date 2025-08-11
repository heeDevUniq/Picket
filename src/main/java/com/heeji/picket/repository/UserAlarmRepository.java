package com.heeji.picket.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface UserAlarmRepository {

    // 유저가 이미 알람 설정 했는지 조회
    int alarmYn(Map<String, Object> params);

    // 유저의 알람 설정 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params);

    // 유저의 알림 설정 개수 조회
    int alarmCnt(Map<String, Object> params);

    // 알림 등록
    int insert(Map<String, Object> params);

    // 알림 삭제
    int delete(Map<String, Object> params);

}