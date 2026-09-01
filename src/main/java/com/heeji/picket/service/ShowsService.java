package com.heeji.picket.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.mapper.ShowsMapper;
import com.heeji.picket.utils.Paging;

@Service
public class ShowsService {

    @Autowired
    private ShowsMapper showsRepository;

    public List<Map<String, Object>> list(Map<String, Object> params) {
        return showsRepository.list(params);
    }

    public Map<String, Object> pagedList(Map<String, Object> params, Integer page, Integer size) {
        int[] ps = Paging.apply(params, page, size);
        int total = showsRepository.count(params);
        List<Map<String, Object>> list = showsRepository.list(params);
        return Paging.wrap(list, total, ps[0], ps[1]);
    }

    // 공연명/장소 키워드 검색
    public List<Map<String, Object>> search(String keyword, int limit) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return java.util.Collections.emptyList();
        }
        Map<String, Object> params = new java.util.HashMap<>();
        // LIKE 와일드카드 이스케이프
        params.put("keyword", keyword.trim().replace("!", "!!").replace("%", "!%").replace("_", "!_"));
        params.put("size", limit);
        return showsRepository.search(params);
    }

    public Map<String, Object> info(Map<String, Object> params) {
        return showsRepository.info(params);
    }

//    public void deleteById(Long id) {
//        showsRepository.deleteById(id);
//    }
}