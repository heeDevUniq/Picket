package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowsMapper;

@Service
public class ShowsService {

    @Autowired
    private ShowsMapper showsRepository;

    public List<Map<String, Object>> list(Map<String, Object> params) {
        return showsRepository.list(params);
    }

    public Map<String, Object> info(Map<String, Object> params) {
        return showsRepository.info(params);
    }

//    public void deleteById(Long id) {
//        showsRepository.deleteById(id);
//    }
}