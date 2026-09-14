package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.SeatGradeMapper;

@Service
public class SeatGradeService {

    @Autowired
    private SeatGradeMapper seatGradeRepository;

    // 날짜별 좌석등급 목록
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return seatGradeRepository.list(params);
    }


    // 수정 화면용 등급 구성
    public List<Map<String, Object>> listByShowId(Long showId) {
        return seatGradeRepository.listByShowId(showId);
    }

}