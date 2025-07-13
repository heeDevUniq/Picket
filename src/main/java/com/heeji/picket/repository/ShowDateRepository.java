package com.heeji.picket.repository;

import com.heeji.picket.domain.ShowDate;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ShowDateRepository extends JpaRepository<ShowDate, Long> {

    @Query("""
        SELECT sd.showId
        FROM ShowDate sd
        WHERE sd.showDateId = :showDateId
    """)
    Long findShowIdByShowDateId(@Param("showDateId") Long showDateId);

    List<ShowDate> findByShowId(Long showId);

}