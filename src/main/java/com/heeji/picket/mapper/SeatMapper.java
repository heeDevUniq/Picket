package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SeatMapper {

    // 날짜별 좌석 목록
    List<Map<String, Object>> list(Map<String, Object> params);

    // 선택 좌석 목록
    List<Map<String, Object>> selectedSeatList(Long[] seatIdArray);

    // 좌석 선점. 반환값은 실제로 잡힌 좌석 수
    int book(Map<String, Object> params);

    // 예매번호로 좌석 되돌리기
    int release(String bookedNumber);

    // 나의 예매/취소 내역
    List<Map<String, Object>> myTickets(Map<String, Object> params);

    // 나의 예매 건수
    int myTicketCnt(Map<String, Object> params);

}