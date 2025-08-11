package com.heeji.picket.repository;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface SeatGradeRepository {

    List<HashMap<String, Object>> list(Map<String, Object> params);

}