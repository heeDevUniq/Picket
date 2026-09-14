package com.heeji.picket.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.heeji.picket.mapper.SeatGradeMapper;
import com.heeji.picket.mapper.SeatMapper;
import com.heeji.picket.mapper.ShowDateMapper;
import com.heeji.picket.mapper.ShowsMapper;

@Service
public class ShowAdminService {

    private static final Logger logger = LoggerFactory.getLogger(ShowAdminService.class);

    // 회차 하나에 만들 수 있는 좌석 상한
    private static final int MAX_SEATS_PER_GRADE = 500;

    @Autowired
    private ShowsMapper showsRepository;

    @Autowired
    private ShowDateMapper showDateRepository;

    @Autowired
    private SeatGradeMapper seatGradeRepository;

    @Autowired
    private SeatMapper seatRepository;

    @Autowired
    private PosterCleanupService posterCleanupService;

    public List<Map<String, Object>> mine(Map<String, Object> params) {
        return showsRepository.mine(params);
    }

    public int mineCount(Map<String, Object> params) {
        return showsRepository.mineCount(params);
    }

    // 예매가 한 건이라도 있으면 회차·좌석 구성은 유지
    public boolean hasBooking(Long showId) {
        return seatRepository.bookedCountByShowId(showId) > 0;
    }

    @Transactional
    public Long save(Map<String, Object> show, List<String> showDates, List<Map<String, Object>> grades) {
        Long showId = show.get("showId") == null ? null : Long.valueOf(show.get("showId").toString());
        boolean isNew = showId == null;

        if (isNew) {
            showsRepository.insert(show);
            showId = Long.valueOf(show.get("showId").toString());
        } else {
            String before = currentPoster(showId);
            if (showsRepository.update(show) == 0) {
                throw new IllegalStateException("공연을 수정할 권한이 없습니다.");
            }
            // 포스터 교체 시 이전 파일 정리
            String after = show.get("posterLink") == null ? null : show.get("posterLink").toString();
            if (before != null && !before.equals(after)) {
                posterCleanupService.deleteIfUploaded(before);
            }
            // 예매된 좌석이 있으면 기본 정보만 반영
            if (hasBooking(showId)) {
                logger.debug("예매가 있어 회차·좌석 구성은 유지, showId : {}", showId);
                return showId;
            }
            seatRepository.deleteByShowId(showId);
            seatGradeRepository.deleteByShowId(showId);
            showDateRepository.deleteByShowId(showId);
        }

        buildSchedule(showId, showDates, grades);
        return showId;
    }

    // 회차마다 같은 등급 구성을 복제하고 등급별 좌석 생성
    private void buildSchedule(Long showId, List<String> showDates, List<Map<String, Object>> grades) {
        if (showDates == null || showDates.isEmpty()) {
            throw new IllegalArgumentException("관람 회차를 한 개 이상 등록해주세요");
        }
        if (grades == null || grades.isEmpty()) {
            throw new IllegalArgumentException("좌석 등급을 한 개 이상 등록해주세요");
        }

        for (String showDate : showDates) {
            if (showDate == null || showDate.isBlank()) {
                continue;
            }
            Map<String, Object> dateParams = new HashMap<String, Object>();
            dateParams.put("showId", showId);
            dateParams.put("showDate", showDate.replace('T', ' '));
            showDateRepository.insert(dateParams);
            Long showDateId = Long.valueOf(dateParams.get("showDateId").toString());

            for (Map<String, Object> grade : grades) {
                int seatCount = toInt(grade.get("seatCount"));
                if (seatCount <= 0 || seatCount > MAX_SEATS_PER_GRADE) {
                    throw new IllegalArgumentException("좌석 수는 1~" + MAX_SEATS_PER_GRADE + "석 사이로 입력해주세요");
                }

                Map<String, Object> gradeParams = new HashMap<String, Object>();
                gradeParams.put("showId", showId);
                gradeParams.put("showDateId", showDateId);
                gradeParams.put("gradeName", grade.get("gradeName"));
                gradeParams.put("price", toInt(grade.get("price")));
                gradeParams.put("seatCount", seatCount);
                seatGradeRepository.insert(gradeParams);
                Long seatGradeId = Long.valueOf(gradeParams.get("seatGradeId").toString());

                List<Integer> numbers = new ArrayList<Integer>(seatCount);
                for (int i = 1; i <= seatCount; i++) {
                    numbers.add(i);
                }
                Map<String, Object> seatParams = new HashMap<String, Object>();
                seatParams.put("showId", showId);
                seatParams.put("showDateId", showDateId);
                seatParams.put("seatGradeId", seatGradeId);
                seatParams.put("numbers", numbers);
                seatRepository.insertBulk(seatParams);
            }
        }
    }

    @Transactional
    public void delete(Long showId, Long loginId) {
        if (hasBooking(showId)) {
            throw new IllegalStateException("예매된 좌석이 있어 삭제할 수 없습니다.");
        }
        String poster = currentPoster(showId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", showId);
        params.put("loginId", loginId);
        if (showsRepository.softDelete(params) == 0) {
            throw new IllegalStateException("공연을 삭제할 권한이 없습니다.");
        }
        seatRepository.deleteByShowId(showId);
        seatGradeRepository.deleteByShowId(showId);
        showDateRepository.deleteByShowId(showId);
        posterCleanupService.deleteIfUploaded(poster);
    }

    private String currentPoster(Long showId) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", showId);
        Map<String, Object> show = showsRepository.info(params);
        Object link = show == null ? null : show.get("posterLink");
        return link == null ? null : link.toString();
    }

    private int toInt(Object value) {
        if (value == null || value.toString().isBlank()) {
            return 0;
        }
        try {
            return Integer.parseInt(value.toString().trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

}
