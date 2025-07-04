package com.heeji.picket.repository;

import com.heeji.picket.domain.ShowLikes;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ShowLikesRepository extends JpaRepository<ShowLikes, Long> {

    // 특정 공연에 대해 유저가 이미 좋아요 했는지 조회
    Optional<ShowLikes> findByShowIdAndUserId(Long showId, Long userId);

    // 공연별 좋아요 수 조회
    Long countByShowId(Long showId);

    // 유저의 좋아요 목록 조회
    List<ShowLikes> findByUserId(Long userId);

}