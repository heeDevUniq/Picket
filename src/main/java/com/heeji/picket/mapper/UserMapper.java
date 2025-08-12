package com.heeji.picket.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {

    Map<String, Object> info(Map<String, Object> params);

    int insert(Map<String, Object> params);
    
    int update(Map<String, Object> params);

    int delete(Map<String, Object> params);

}