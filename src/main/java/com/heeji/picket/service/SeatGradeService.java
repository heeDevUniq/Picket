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

    // 공연 날짜 고유번호로 등급 목록 조회
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return seatGradeRepository.list(params);
    }

}