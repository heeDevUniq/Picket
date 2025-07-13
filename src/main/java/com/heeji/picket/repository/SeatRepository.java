package com.heeji.picket.repository;

import com.heeji.picket.domain.Seat;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Long> {

    @Query("""
        SELECT s
        FROM Seat s
        LEFT JOIN FETCH s.seatGrade sg
        WHERE s.showId = :showId
    """)
    List<Seat> findByShowId(@Param("showId") Long showId);

}