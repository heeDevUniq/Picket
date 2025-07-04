package com.heeji.picket.service;

import com.heeji.picket.domain.Shows;
import com.heeji.picket.repository.ShowsRepository;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Log4j2
public class ShowsService {

    @Autowired
    private ShowsRepository showsRepository;

    @Transactional(readOnly = true)
    public Page<Shows> findAll(Pageable pageable) {
        return showsRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Page<Shows> findAllByGenre(String genre, Pageable pageable) {
        return showsRepository.findAllByGenre(genre, pageable);
    }

    public Shows findById(Long id) {
        return showsRepository.findById(id).orElse(null);
    }

//    public void deleteById(Long id) {
//        showsRepository.deleteById(id);
//    }
}