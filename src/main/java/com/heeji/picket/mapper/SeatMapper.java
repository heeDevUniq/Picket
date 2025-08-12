package com.heeji.picket.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SeatMapper {

    // 날짜 별 좌석 목록 조회
    List<HashMap<String, Object>> list(Map<String, Object> params);

    // 선택한 좌석 목록 조회회
    List<HashMap<String, Object>> selectedSeatList(String[] seatIdArray);

}