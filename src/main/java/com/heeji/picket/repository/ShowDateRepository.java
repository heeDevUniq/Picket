package com.heeji.picket.repository;

import com.heeji.picket.domain.ShowDate;
import com.heeji.picket.domain.Shows;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ShowDateRepository extends JpaRepository<ShowDate, Long> {

    @Query("""
        SELECT sd.shows
        FROM ShowDate sd
        WHERE sd.id = :showDateId
    """)
    Optional<Shows> findShowByShowDateId(@Param("showDateId") Long showDateId);

    List<ShowDate> findByShowId(Long showId);

}