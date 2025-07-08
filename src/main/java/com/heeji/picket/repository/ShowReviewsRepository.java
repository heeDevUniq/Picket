package com.heeji.picket.repository;

import com.heeji.picket.domain.ShowReviews;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ShowReviewsRepository extends JpaRepository<ShowReviews, Long> {
    
    @EntityGraph(attributePaths = {"user"})
    Page<ShowReviews> findAllByShowId(Long showId, Pageable pageable);

}