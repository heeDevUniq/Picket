package com.heeji.picket.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.repository.UserAlarmRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class UserAlarmService {

    @Autowired
    private UserAlarmRepository showAlarmRepository;

    // 티켓팅 알람 설정
    public int setAlarm(Map<String, Object> params) {
        // 유저가 이미 알람 설정 했는지 조회
        int alarmYn = showAlarmRepository.alarmYn(params);

        if (alarmYn > 0) {
            // 이미 설정 되어있으면 삭제
            return showAlarmRepository.delete(params);
        } else {
            // 설정 안 되어 있으면 추가
            return showAlarmRepository.insert(params);
        }
    }

    // 특정 공연에 로그인 유저의 알람 여부 조회
    public int alarmYn(Map<String, Object> params) {
        return showAlarmRepository.alarmYn(params);
    }

    // 유저의 알람 개수 조회
    public int alarmCnt(Map<String, Object> params) {
        return showAlarmRepository.alarmCnt(params);
    }

    // 유저의 알람 설정 목록 조회
    public List<HashMap<String, Object>> list(Map<String, Object> params) {
        return showAlarmRepository.list(params);
    }

}