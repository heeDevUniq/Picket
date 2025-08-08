package com.heeji.picket.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.UserAlarm;
import com.heeji.picket.repository.UserAlarmRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class UserAlarmService {

    @Autowired
    private UserAlarmRepository showAlarmRepository;

    // 티켓팅 알람 설정
    public UserAlarm setAlarm(UserAlarm userAlarm) {
        System.out.println("진입!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        System.out.println("showId = " + userAlarm.getShowId() + ", userId = " + userAlarm.getUserId());
        // 유저가 이미 알람 설정 했는지 조회
        Optional<UserAlarm> existingAlarm = showAlarmRepository.findByShowIdAndUserId(userAlarm.getShowId(), userAlarm.getUserId());

        if (existingAlarm.isPresent()) {
            // 이미 설정 되어있으면 삭제
            showAlarmRepository.delete(existingAlarm.get());
            return null;
        } else {
            // 설정 안 되어 있으면 추가
            return showAlarmRepository.save(userAlarm);
        }
    }

    // 특정 공연에 로그인 유저의 알람 여부 조회
    public int findByShowIdAndUserId(Long userId, Long showId) {
        int retNum = 0;
        if (showAlarmRepository.findByShowIdAndUserId(showId, userId).isPresent()) retNum = 1;
        return retNum;
    }

    // 유저의 알람 개수 조회
    public int countByUserId(Long userId) {
        return showAlarmRepository.countByUserId(userId);
    }

    // 유저의 알람 설정 목록 조회
    public List<UserAlarm> findByUserId(Long userId) {
        return showAlarmRepository.findByUserId(userId);
    }

}