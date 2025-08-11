package com.heeji.picket.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface ShowDateRepository  {

    List<HashMap<String, Object>> list(Map<String, Object> params);

    HashMap<String, Object> info(Map<String, Object> params);
    

}