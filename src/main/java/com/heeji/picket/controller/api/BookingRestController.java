package com.heeji.picket.controller.api;

import com.heeji.picket.service.BookingService;
import com.heeji.picket.service.TossPaymentsService;
import com.heeji.picket.utils.SessionUtil;
import com.heeji.picket.utils.TossPaymentException;

import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/booking/api")
public class BookingRestController {

    private static final Logger logger = LoggerFactory.getLogger(BookingRestController.class);

    @Autowired
    BookingService bookingService;

    @Autowired
    TossPaymentsService tossPaymentsService;

    // 예매 취소 + 환불
    @PostMapping("/cancel")
    public ResponseEntity<Map<String, Object>> cancel(HttpSession session, @RequestBody Map<String, Object> body) {
        if (!SessionUtil.isLogin(session)) {
            return fail(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다");
        }
        String bookedNumber = body.get("bookedNumber") == null ? null : body.get("bookedNumber").toString();
        if (bookedNumber == null || bookedNumber.isBlank()) {
            return fail(HttpStatus.BAD_REQUEST, "예매번호가 없습니다.");
        }
        logger.debug("cancel 진입, bookedNumber : {}", bookedNumber);

        Long userId = SessionUtil.getLoginId(session);
        Map<String, Object> target = bookingService.cancelTarget(userId, bookedNumber);
        if (target == null) {
            return fail(HttpStatus.NOT_FOUND, "예매 내역을 찾을 수 없습니다.");
        }
        if (target.get("canceledDate") != null) {
            return fail(HttpStatus.CONFLICT, "이미 취소된 예매입니다.");
        }
        if (!"Y".equals(target.get("cancelable"))) {
            return fail(HttpStatus.BAD_REQUEST, "공연 3일 전까지만 취소할 수 있습니다.");
        }

        String reason = body.get("cancelReason") == null ? "고객 요청" : body.get("cancelReason").toString();
        String paymentKey = String.valueOf(target.get("paymentKey"));

        try {
            tossPaymentsService.cancel(paymentKey, reason, "cancel-" + bookedNumber);
        } catch (TossPaymentException e) {
            return fail(HttpStatus.BAD_GATEWAY, e.getMessage());
        }

        // 환불 완료 후에만 좌석 반환 + 상태 변경
        try {
            bookingService.applyCancel(userId, bookedNumber, reason);
        } catch (IllegalStateException e) {
            return fail(HttpStatus.CONFLICT, e.getMessage());
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("success", true);
        result.put("bookedNumber", bookedNumber);
        result.put("amount", target.get("amount"));
        return ResponseEntity.ok(result);
    }

    private ResponseEntity<Map<String, Object>> fail(HttpStatus status, String message) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("success", false);
        result.put("message", message);
        return ResponseEntity.status(status).body(result);
    }

}
