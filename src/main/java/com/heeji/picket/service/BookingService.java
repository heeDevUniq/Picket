package com.heeji.picket.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.heeji.picket.mapper.PaymentMapper;
import com.heeji.picket.mapper.SeatMapper;
import com.heeji.picket.utils.SeatTakenException;

@Service
public class BookingService {

    private static final Logger logger = LoggerFactory.getLogger(BookingService.class);

    @Autowired
    private SeatMapper seatRepository;

    @Autowired
    private PaymentMapper paymentRepository;

    // 좌석 선점, 한 자리라도 팔렸으면 전부 롤백
    @Transactional
    public void holdSeats(Long bookedId, String bookedNumber, Long[] seatArrays) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("bookedId", bookedId);
        params.put("bookedNumber", bookedNumber);
        params.put("seatArrays", seatArrays);

        int booked = seatRepository.book(params);
        if (booked != seatArrays.length) {
            logger.warn("좌석 선점 실패, bookedNumber : {}, 요청 : {}, 선점 : {}", bookedNumber, seatArrays.length, booked);
            throw new SeatTakenException("선택한 좌석 중 일부가 방금 예매되었습니다.");
        }
    }

    // 결제 실패 시 좌석 반환
    @Transactional
    public void releaseSeats(String bookedNumber) {
        int released = seatRepository.release(bookedNumber);
        logger.debug("좌석 반환, bookedNumber : {}, 건수 : {}", bookedNumber, released);
    }

    // 결제창 진입 전 주문 생성
    @Transactional
    public void createOrder(Long paidId, Long showId, Long showDateId, String orderId, long amount, Long[] seatArrays, List<Map<String, Object>> seats) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("paidId", paidId);
        params.put("showId", showId);
        params.put("showDateId", showDateId);
        params.put("orderId", orderId);
        params.put("amount", amount);
        params.put("seatCount", seats == null ? 0 : seats.size());
        params.put("seatNames", seatNames(seats));
        params.put("seatIds", joinIds(seatArrays));
        paymentRepository.ready(params);
    }

    public Map<String, Object> findOrder(String orderId) {
        return paymentRepository.infoByOrderId(orderId);
    }

    @Transactional
    public int completeOrder(String orderId, String paymentKey, Map<String, Object> paid) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("orderId", orderId);
        params.put("paymentKey", paymentKey);
        params.put("method", paid == null ? null : paid.get("method"));
        params.put("pgCode", paid == null ? null : paid.get("lastTransactionKey"));
        return paymentRepository.done(params);
    }

    // 승인 못 간 주문 정리
    @Transactional
    public void dropOrder(String orderId) {
        paymentRepository.deleteReady(orderId);
    }

    // 좌석 재판매 후에도 취소내역에 남길 좌석명 스냅샷
    private String seatNames(List<Map<String, Object>> seats) {
        if (seats == null || seats.isEmpty()) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (Map<String, Object> seat : seats) {
            if (sb.length() > 0) {
                sb.append(", ");
            }
            sb.append(seat.get("gradeName")).append(seat.get("seatNumber"));
        }
        return sb.length() > 500 ? sb.substring(0, 500) : sb.toString();
    }

    private String joinIds(Long[] seatArrays) {
        if (seatArrays == null || seatArrays.length == 0) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (Long id : seatArrays) {
            if (sb.length() > 0) {
                sb.append(",");
            }
            sb.append(id);
        }
        return sb.toString();
    }

    public static Long[] parseIds(Object seatIds) {
        if (seatIds == null || seatIds.toString().isBlank()) {
            return new Long[0];
        }
        String[] parts = seatIds.toString().split(",");
        Long[] out = new Long[parts.length];
        for (int i = 0; i < parts.length; i++) {
            out[i] = Long.valueOf(parts[i].trim());
        }
        return out;
    }

    // 취소 대상 조회
    public Map<String, Object> cancelTarget(Long userId, String bookedNumber) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", userId);
        params.put("bookedNumber", bookedNumber);
        return paymentRepository.infoForCancel(params);
    }

    // 취소 확정, 결제 상태를 바꾸고 좌석 반환
    @Transactional
    public void applyCancel(Long userId, String bookedNumber, String cancelReason) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", userId);
        params.put("bookedNumber", bookedNumber);
        params.put("cancelReason", cancelReason);

        int updated = paymentRepository.cancel(params);
        if (updated == 0) {
            throw new IllegalStateException("이미 취소된 예매입니다.");
        }
        seatRepository.release(bookedNumber);
    }

    public List<Map<String, Object>> myCanceled(Map<String, Object> params) {
        return paymentRepository.myCanceled(params);
    }

}
