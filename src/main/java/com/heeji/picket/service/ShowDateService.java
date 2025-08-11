package com.heeji.picket.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.repository.ShowDateRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ShowDateService {

    @Autowired
    private ShowDateRepository showDateRepository;

    // 공연 고유번호로 날짜 목록 조회
    public List<HashMap<String, Object>> list(Map<String, Object> params) {
        return showDateRepository.list(params);
    }
    
    // 날짜 고유번호로 공연 정보 조회
    public HashMap<String, Object> info(Map<String, Object> params) {
        return showDateRepository.info(params);
    }

}