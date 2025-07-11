package com.heeji.picket.repository;

import com.heeji.picket.domain.UserAlarm;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAlarmRepository extends JpaRepository<UserAlarm, Long> {

    // 유저가 이미 알람 설정 했는지 조회
    Optional<UserAlarm> findByShowIdAndUserId(Long showId, Long userId);

    // 유저의 알람 설정 목록 조회
    List<UserAlarm> findByUserId(Long userId);

    // 유저의 알림 설정 개수 조회
    int countByUserId(Long userId);

}