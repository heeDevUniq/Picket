package com.heeji.picket.mapper;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SeatGradeMapper {

    List<HashMap<String, Object>> list(Map<String, Object> params);

}