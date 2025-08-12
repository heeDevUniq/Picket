package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.SeatMapper;

@Service
public class SeatService {

    @Autowired
    private SeatMapper seatRepository;

    // 날짜 고유번호로 좌석 목록 조회
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return seatRepository.list(params);
    }
    
    // 선택한 좌석 목록
    public List<Map<String, Object>> selectedSeatList(String[] seatIdArray) {
        return seatRepository.selectedSeatList(seatIdArray);
    }

}