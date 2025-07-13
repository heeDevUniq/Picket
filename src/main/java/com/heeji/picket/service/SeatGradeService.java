package com.heeji.picket.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.SeatGrade;
import com.heeji.picket.repository.SeatGradeRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class SeatGradeService {

    @Autowired
    private SeatGradeRepository seatGradeRepository;

    // 공연 날짜 고유번호로 등급 목록 조회
    public List<SeatGrade> findByShowDateId(Long showDateId) {
        return seatGradeRepository.findByShowDateId(showDateId);
    }

}