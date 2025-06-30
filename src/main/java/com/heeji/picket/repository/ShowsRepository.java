package com.heeji.picket.repository;

import com.heeji.picket.domain.Post;
import com.heeji.picket.domain.Shows;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ShowsRepository extends JpaRepository<Shows, Long> {

    Page<Shows> findAllByGenre(String genre, Pageable pageable);

}