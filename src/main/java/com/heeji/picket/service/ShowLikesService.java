package com.heeji.picket.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.heeji.picket.domain.ShowLikes;
import com.heeji.picket.repository.ShowLikesRepository;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ShowLikesService {

    @Autowired
    private ShowLikesRepository showLikesRepository;

    // 좋아요하기
    public ShowLikes like(ShowLikes showLikes) {
        Optional<ShowLikes> existingLike = showLikesRepository.findByShowIdAndUserId(showLikes.getShowId(), showLikes.getUserId());

        if (existingLike.isPresent()) {
            // 이미 좋아요 되어있으면 삭제
            showLikesRepository.delete(existingLike.get());
            return null;
        } else {
            // 좋아요 안 되어 있으면 추가
            return showLikesRepository.save(showLikes);
        }
    }

    // 공연별 좋아요 수 조회
    public Long countByShowId(Long showId) {
        return showLikesRepository.countByShowId(showId);
    }

    // 유저의 좋아요목록 조회
    List<ShowLikes> findByUserId(Long userId) {
        return showLikesRepository.findByUserId(userId);
    }
    
    // 유저의 좋아요 개개수 조회
    public int countByUserId(Long showId) {
        return showLikesRepository.countByUserId(showId);
    }

}