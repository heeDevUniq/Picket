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

}