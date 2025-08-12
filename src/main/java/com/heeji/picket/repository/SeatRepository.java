package com.heeji.picket.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

@Repository
public interface SeatRepository {

    // 날짜 별 좌석 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params);

    // 선택한 좌석 목록 조회회
    List<HashMap<String, Object>> selectedSeatList(String[] seatIdArray);

}