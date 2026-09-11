package com.heeji.picket.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {

    // 결제창을 띄우기 전 주문 생성
    int ready(Map<String, Object> params);

    // 승인 완료 처리
    int done(Map<String, Object> params);

    // 승인되지 않은 주문 제거
    int deleteReady(String orderId);

    // 주문번호로 조회
    Map<String, Object> infoByOrderId(String orderId);

    // 취소 대상 조회 (본인 것만)
    Map<String, Object> infoForCancel(Map<String, Object> params);

    // 취소 처리
    int cancel(Map<String, Object> params);

    // 나의 취소 내역
    List<Map<String, Object>> myCanceled(Map<String, Object> params);

}
