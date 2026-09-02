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

    // 날짜별 좌석 목록
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return seatRepository.list(params);
    }
    
    // 선택 좌석 목록
    public List<Map<String, Object>> selectedSeatList(Long[] seatIdArray) {
        return seatRepository.selectedSeatList(seatIdArray);
    }

    // 좌석 선점. 반환값은 실제로 잡힌 좌석 수
    public int book(Map<String, Object> params) {
        return seatRepository.book(params);
    }

    // 예매번호로 좌석 되돌리기
    public int release(String bookedNumber) {
        return seatRepository.release(bookedNumber);
    }

    // 나의 예매/취소 내역
    public List<Map<String, Object>> myTickets(Map<String, Object> params) {
        return seatRepository.myTickets(params);
    }

    // 나의 예매 건수
    public int myTicketCnt(Map<String, Object> params) {
        return seatRepository.myTicketCnt(params);
    }

}