package com.heeji.picket.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.SeatMapper;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class SeatService {

    @Autowired
    private SeatMapper seatRepository;

    // 날짜 고유번호로 좌석 목록 조회
    public List<HashMap<String, Object>> list(Map<String, Object> params) {
        return seatRepository.list(params);
    }
    
    // 선택한 좌석 목록
    public List<HashMap<String, Object>> selectedSeatList(String[] seatIdArray) {
        return seatRepository.selectedSeatList(seatIdArray);
    }

}