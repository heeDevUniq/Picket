package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.UserAlarmMapper;

@Service
public class UserAlarmService {

    @Autowired
    private UserAlarmMapper showAlarmRepository;

    // 알림 토글
    public int setAlarm(Map<String, Object> params) {
        int alarmYn = showAlarmRepository.alarmYn(params);

        if (alarmYn > 0) {
            // 이미 설정됨 -> 해제 (0 반환)
            showAlarmRepository.delete(params);
            return 0;
        } else {
            return showAlarmRepository.insert(params);
        }
    }

    // 알림 설정 여부
    public int alarmYn(Map<String, Object> params) {
        return showAlarmRepository.alarmYn(params);
    }

    // 내 알림 수
    public int alarmCnt(Map<String, Object> params) {
        return showAlarmRepository.alarmCnt(params);
    }

    // 내 알림 목록
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return showAlarmRepository.list(params);
    }

}