package com.heeji.picket.repository;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
public interface UserRepository {

    HashMap<String, Object> info(Map<String, Object> params);

    int insert(Map<String, Object> params);
    
    int update(Map<String, Object> params);

    int delete(Map<String, Object> params);

}