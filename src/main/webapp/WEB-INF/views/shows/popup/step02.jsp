<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>픽켓 예매</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=IBM+Plex+Sans+KR:wght@400;500;600;700&family=Noto+Sans+KR:wght@400;500;700&display=swap">
<link rel="stylesheet" href="/css/typography.css">
<link rel="stylesheet" href="/css/interactive.css">
<link rel="stylesheet" href="/css/responsive.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/interactive.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script src="/js/common.js"></script>
<script src="/js/show.js"></script>
<style>
    body {
        margin: 0;
        background: #F6F7F9;
        color: #14161A;
    }

    .nav-bar {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 16px 28px;
        background: #fff;
        border-bottom: 1px solid #E7E9EE;
    }
    .nav-bar img { height: 22px; }
    .nav-bar .step-name { font-weight: 700; color: #2875FF; }
    .nav-bar .show-name { color: #5A6272; font-size: 14px; }
    .nav-bar .date-select {
        margin-left: auto;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        color: #6B7280;
    }
    .nav-bar .date-value {
        font-family: var(--pk-font-mono);
        font-size: 13px;
        color: #14161A;
        background: #F1F3F6;
        border-radius: 8px;
        padding: 6px 12px;
    }

    .pay-wrap {
        max-width: 880px;
        margin: 26px auto 40px;
        padding: 0 24px;
        display: grid;
        grid-template-columns: 200px 1fr;
        gap: 28px;
        align-items: start;
    }

    .pay-poster {
        width: 200px;
        aspect-ratio: 3 / 4;
        border-radius: 12px;
        overflow: hidden;
        background: #E7E9EE;
        box-shadow: 0 6px 20px rgba(16,24,40,.10);
    }
    .pay-poster img { width: 100%; height: 100%; object-fit: cover; display: block; }

    .pay-title { font-size: 19px; font-weight: 700; letter-spacing: -.02em; margin-bottom: 4px; }
    .pay-place { font-size: 13px; color: #6B7280; margin-bottom: 18px; }

    .card {
        background: #fff;
        border: 1px solid #E7E9EE;
        border-radius: 14px;
        padding: 18px 20px;
        margin-bottom: 14px;
    }
    .card > h3 {
        font-size: 14px;
        font-weight: 600;
        color: #5A6272;
        margin: 0 0 12px;
    }

    .seat-list { display: flex; flex-wrap: wrap; gap: 8px; }
    .seat-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 12px;
        border-radius: 999px;
        background: #EDF3FF;
        color: #1B4FD8;
        font-size: 13px;
        font-weight: 600;
    }
    .seat-chip small {
        font-family: var(--pk-font-mono);
        font-weight: 500;
        opacity: .75;
    }
    .seat-empty { font-size: 13px; color: #6B7280; }

    .pay-row {
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        padding: 7px 0;
        font-size: 14px;
        color: #5A6272;
    }
    .pay-row b { font-family: var(--pk-font-mono); font-weight: 500; color: #14161A; }
    .pay-row.total {
        margin-top: 8px;
        padding-top: 14px;
        border-top: 1px solid #E7E9EE;
        font-size: 15px;
        color: #14161A;
        font-weight: 600;
    }
    .pay-row.total b {
        font-size: 21px;
        font-weight: 600;
        color: #1B4FD8;
    }

    .btn-box {
        display: flex;
        gap: 10px;
        margin-top: 18px;
    }
    .pk-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: 48px;
        border: 1px solid #E7E9EE;
        border-radius: 11px;
        background: #fff;
        color: #14161A;
        font-family: var(--pk-font-ui);
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all .16s cubic-bezier(.2,.8,.2,1);
    }
    .pk-btn:hover { border-color: #2875FF; color: #1B4FD8; }
    .pk-btn--ghost { flex: 0 0 120px; }
    .pk-btn--pay {
        flex: 1;
        background: #2875FF;
        border-color: #2875FF;
        color: #fff;
    }
    .pk-btn--pay:hover { color: #fff; filter: brightness(1.06); }
    .pk-btn:disabled { background: #C9CDD4; border-color: #C9CDD4; color: #fff; cursor: not-allowed; }

    .pay-note {
        margin-top: 14px;
        font-size: 12px;
        color: #868EA0;
        line-height: 1.7;
    }

    @media (max-width: 768px) {
        .nav-bar { flex-wrap: wrap; padding: 12px 16px; gap: 8px; }
        .nav-bar .date-select { width: 100%; margin-left: 0; }
        .pay-wrap {
            grid-template-columns: 1fr;
            gap: 18px;
            padding: 0 16px;
            margin-top: 18px;
        }
        .pay-poster { width: 150px; margin: 0 auto; }
        .pay-title, .pay-place { text-align: center; }
    }
</style>
</head>
<body>

<div class="nav-bar">
    <img src="/images/com/logo.png" alt="PICKET">
    <span class="step-name">좌석확인</span>
    <span class="show-name">${show.title}</span>
    <div class="date-select">
        <span>관람일자</span>
        <span class="date-value"><fmt:formatDate value="${show.showDate}" pattern="yyyy.MM.dd(E) HH:mm" /></span>
    </div>
</div>

<div class="pk-stepper" role="list">
    <span class="pk-step is-done" role="listitem"><i>1</i>좌석선택</span>
    <span class="pk-step-line"></span>
    <span class="pk-step is-on" role="listitem"><i>2</i>결제</span>
    <span class="pk-step-line"></span>
    <span class="pk-step" role="listitem"><i>3</i>예매완료</span>
</div>

<c:set var="totalAmount" value="0" />
<c:forEach var="seat" items="${seats}">
    <c:set var="totalAmount" value="${totalAmount + seat.price}" />
</c:forEach>

<div class="pay-wrap">
    <div class="pay-poster">
        <img src="${show.posterLink}" alt="${show.title} 포스터" data-show-id="${show.showId}">
    </div>

    <div>
        <div class="pay-title">${show.title}</div>
        <div class="pay-place">${show.place}</div>

        <div class="card">
            <h3>선택좌석 ${fn:length(seats)}매</h3>
            <div class="seat-list">
                <c:forEach var="seat" items="${seats}">
                    <span class="seat-chip">
                        ${seat.gradeName}석 ${seat.seatNumber}번
                        <small><fmt:formatNumber value="${seat.price}" pattern="#,###" /></small>
                    </span>
                </c:forEach>
                <c:if test="${empty seats}">
                    <span class="seat-empty">선택한 좌석이 없습니다. 이전 단계에서 좌석을 골라주세요.</span>
                </c:if>
            </div>
        </div>

        <div class="card">
            <h3>결제금액</h3>
            <div class="pay-row">
                <span>티켓금액</span>
                <b><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</b>
            </div>
            <div class="pay-row">
                <span>수수료</span>
                <b>0원</b>
            </div>
            <div class="pay-row total">
                <span>총 결제금액</span>
                <b><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</b>
            </div>

            <div class="btn-box">
                <button type="button" class="pk-btn pk-btn--ghost" onclick="show.popupPre('${showDateId}');">이전</button>
                <button type="button" class="pk-btn pk-btn--pay"
                        <c:if test="${empty seats}">disabled</c:if>
                        onclick="show.payment('${show.title}',${totalAmount},'${sessionScope.LOGIN_EMAIL}','${sessionScope.LOGIN_NAME}');">
                    <fmt:formatNumber value="${totalAmount}" pattern="#,###" />원 결제하기
                </button>
            </div>

            <p class="pay-note">
                결제 후 예매 내역은 마이페이지 &gt; 예매/취소내역에서 확인하실 수 있습니다.<br>
                공연 3일 전까지 취소 시 전액 환불됩니다.
            </p>
        </div>
    </div>
</div>

</body>
</html>
