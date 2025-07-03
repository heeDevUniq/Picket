package com.heeji.picket.repository;

import com.heeji.picket.domain.Post;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {

    @EntityGraph(attributePaths = {"user"})
    Page<Post> findAllByType(@Param("postType") String postType, Pageable pageable);

    @Transactional
    @Modifying
    @Query("UPDATE Post p SET p.hits = p.hits + 1 WHERE p.postId = :postId")
    int increaseViewCount(@Param("postId") Long postId);

}