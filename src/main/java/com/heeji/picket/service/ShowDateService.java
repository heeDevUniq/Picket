package com.heeji.picket.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.Seat;
import com.heeji.picket.domain.ShowDate;
import com.heeji.picket.repository.ShowDateRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ShowDateService {

    @Autowired
    private ShowDateRepository showDateRepository;

    // public List<ShowDate> findByShowId(Long showId) {
    //     return showDateRepository.findByShowId(showId);
    // }

}