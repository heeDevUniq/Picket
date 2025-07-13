package com.heeji.picket.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.Seat;
import com.heeji.picket.repository.SeatRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class SeatService {

    @Autowired
    private SeatRepository seatRepository;

    public List<Seat> findByShowId(Long showId) {
        return seatRepository.findByShowId(showId);
    }

}