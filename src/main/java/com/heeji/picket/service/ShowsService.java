package com.heeji.picket.service;

import lombok.extern.log4j.Log4j2;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowsMapper;

@Service
@Log4j2
public class ShowsService {

    @Autowired
    private ShowsMapper showsRepository;

    public List<HashMap<String, Object>> list(Map<String, Object> params) {
        return showsRepository.list(params);
    }

    public HashMap<String, Object> info(Map<String, Object> params) {
        return showsRepository.info(params);
    }

//    public void deleteById(Long id) {
//        showsRepository.deleteById(id);
//    }
}