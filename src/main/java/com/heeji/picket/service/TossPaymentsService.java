package com.heeji.picket.service;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.heeji.picket.utils.TossPaymentException;

@Service
public class TossPaymentsService {

    private static final Logger logger = LoggerFactory.getLogger(TossPaymentsService.class);

    private final RestClient restClient;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final String clientKey;
    private final String secretKey;

    public TossPaymentsService(@Value("${picket.payments.toss.api-url:https://api.tosspayments.com}") String apiUrl, @Value("${picket.payments.toss.client-key:}") String clientKey, @Value("${picket.payments.toss.secret-key:}") String secretKey) {
        this.restClient = RestClient.builder().baseUrl(apiUrl).build();
        this.clientKey = clientKey;
        this.secretKey = secretKey;
    }

    public String getClientKey() {
        return clientKey;
    }

    // 키 미설정 시 결제 버튼 비활성
    public boolean isConfigured() {
        return clientKey != null && !clientKey.isBlank() && secretKey != null && !secretKey.isBlank();
    }

    // 결제 승인, 이 호출이 성공해야 결제 성립
    @SuppressWarnings("unchecked")
    public Map<String, Object> confirm(String paymentKey, String orderId, long amount) {
        if (!isConfigured()) {
            throw new TossPaymentException("NO_SECRET_KEY", "토스페이먼츠 시크릿 키가 설정되지 않았습니다.");
        }

        Map<String, Object> body = new HashMap<String, Object>();
        body.put("paymentKey", paymentKey);
        body.put("orderId", orderId);
        body.put("amount", amount);

        try {
            return restClient.post()
                    .uri("/v1/payments/confirm")
                    .header("Authorization", basicAuth())
                    // 동일 주문 중복 승인 방지
                    .header("Idempotency-Key", orderId)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body)
                    .retrieve()
                    .body(Map.class);
        } catch (RestClientResponseException e) {
            Map<String, Object> error = parseError(e.getResponseBodyAsString());
            String code = String.valueOf(error.getOrDefault("code", "UNKNOWN"));
            String message = String.valueOf(error.getOrDefault("message", "결제 승인에 실패하였습니다."));
            logger.warn("토스 결제 승인 실패, orderId : {}, code : {}, message : {}", orderId, code, message);
            throw new TossPaymentException(code, message);
        } catch (Exception e) {
            logger.error("토스 결제 승인 통신 오류, orderId : " + orderId, e);
            throw new TossPaymentException("NETWORK_ERROR", "결제 서버와 통신하지 못했습니다.");
        }
    }

    // 결제 취소(환불), 전액 취소만 사용
    @SuppressWarnings("unchecked")
    public Map<String, Object> cancel(String paymentKey, String cancelReason, String idempotencyKey) {
        if (!isConfigured()) {
            throw new TossPaymentException("NO_SECRET_KEY", "토스페이먼츠 시크릿 키가 설정되지 않았습니다.");
        }

        Map<String, Object> body = new HashMap<String, Object>();
        body.put("cancelReason", cancelReason);

        try {
            return restClient.post()
                    .uri("/v1/payments/{paymentKey}/cancel", paymentKey)
                    .header("Authorization", basicAuth())
                    .header("Idempotency-Key", idempotencyKey)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body)
                    .retrieve()
                    .body(Map.class);
        } catch (RestClientResponseException e) {
            Map<String, Object> error = parseError(e.getResponseBodyAsString());
            String code = String.valueOf(error.getOrDefault("code", "UNKNOWN"));
            String message = String.valueOf(error.getOrDefault("message", "결제 취소에 실패하였습니다."));
            logger.warn("토스 결제 취소 실패, paymentKey : {}, code : {}, message : {}", paymentKey, code, message);
            throw new TossPaymentException(code, message);
        } catch (Exception e) {
            logger.error("토스 결제 취소 통신 오류, paymentKey : " + paymentKey, e);
            throw new TossPaymentException("NETWORK_ERROR", "결제 서버와 통신하지 못했습니다.");
        }
    }

    private String basicAuth() {
        String raw = secretKey + ":";
        return "Basic " + Base64.getEncoder().encodeToString(raw.getBytes(StandardCharsets.UTF_8));
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> parseError(String responseBody) {
        try {
            return objectMapper.readValue(responseBody, Map.class);
        } catch (Exception e) {
            return new HashMap<String, Object>();
        }
    }

}
