package com.heeji.picket.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.heeji.picket.domain.ShowReviews;
import com.heeji.picket.repository.ShowReviewsRepository;
import org.springframework.transaction.annotation.Transactional;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ShowReviewsService {

    @Autowired
    private ShowReviewsRepository showReviewsRepository;

    // 공연 별 리뷰 조회
    @Transactional(readOnly = true)
    public Page<ShowReviews> findAllByShowId(Long showId, Pageable pageable) {
        return showReviewsRepository.findAllByShowId(showId, pageable);
    }

    // 리뷰 등록/수정
    public ShowReviews save(ShowReviews showReviews) {
        if (showReviews.getReviewId() == null) {
            return showReviewsRepository.save(showReviews);
        }

        Optional<ShowReviews> existingReviewOpt = showReviewsRepository.findById(showReviews.getReviewId());

        if (existingReviewOpt.isPresent()) {
            ShowReviews existingReview = existingReviewOpt.get();
            existingReview.setContent(showReviews.getContent());
            return showReviewsRepository.save(existingReview);
        } else {
            return showReviewsRepository.save(showReviews);
        }
    }

    // 리뷰 삭제
    public int deleteById(Long id) {
        int delNum = 0;
        if (showReviewsRepository.existsById(id)) {
            showReviewsRepository.deleteById(id);
            delNum = 1;
        }
        return delNum;
    }

}