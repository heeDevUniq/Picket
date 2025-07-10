package com.heeji.picket.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.ShowLikes;
import com.heeji.picket.domain.UserAlarm;
import com.heeji.picket.repository.ShowLikesRepository;
import com.heeji.picket.repository.UserAlarmRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class UserAlarmService {

    @Autowired
    private UserAlarmRepository showAlarmRepository;

    // 티켓팅 알람 설정
    public UserAlarm setAlarm(UserAlarm userAlarm) {
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

    // 유저의 티켓팅 알람이 설정된 목록 조회
    List<ShowLikes> findByUserId(Long userId) {
        return showAlarmRepository.findByUserId(userId);
    }

}