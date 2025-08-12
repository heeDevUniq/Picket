package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowDateMapper;

@Service
public class ShowDateService {

    @Autowired
    private ShowDateMapper showDateRepository;

    // 공연 고유번호로 날짜 목록 조회
    public List<Map<String, Object>> list(Map<String, Object> params) {
        return showDateRepository.list(params);
    }
    
    // 날짜 고유번호로 공연 정보 조회
    public Map<String, Object> info(Map<String, Object> params) {
        return showDateRepository.info(params);
    }

}