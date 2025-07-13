package com.heeji.picket.repository;

import com.heeji.picket.domain.SeatGrade;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface SeatGradeRepository extends JpaRepository<SeatGrade, Long> {

    @Query("""
        SELECT sg
        FROM SeatGrade sg
        WHERE sg.showDateId = :showDateId
    """)
    List<SeatGrade> findByShowDateId(@Param("showDateId") Long showDateId);

}