package com.heeji.picket.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.Seat;
import com.heeji.picket.repository.SeatRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class SeatService {

    @Autowired
    private SeatRepository seatRepository;

    // 날짜 고유번호로 좌석 목록 조회
    public List<Seat> findByShowDateId(Long showDateId) {
        return seatRepository.findByShowDateId(showDateId);
    }
    
    // 선택한 좌석 목록
    public List<Seat> findSeatsWithSeatGradeBySeatIdIn(Long[] seatIds) {
        return seatRepository.findSeatsWithSeatGradeBySeatIdIn(seatIds);
    }

}