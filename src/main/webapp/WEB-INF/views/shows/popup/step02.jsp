<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="/js/show.js"></script>
<script src="/js/common.js"></script>
<style>
    body {
        margin: 0;
        font-family: "Apple SD Gothic Neo", sans-serif;
        background-color: #f9f9f9;
        color: #333;
    }

    /* 상단 네비 */
    .nav-bar {
        display: flex;
        align-items: center;
        padding: 20px 40px;
        background-color: #fff;
        border-bottom: 1px solid #ddd;
    }

    .nav-bar img {
        height: 25px;
        margin-right: 20px;
    }

    .nav-bar a {
        color: #007BFF;
        text-decoration: none;
        font-weight: bold;
        margin-right: 15px;
    }

    .nav-bar span {
        font-weight: normal;
        color: #555;
    }

    /* 컨텐츠 영역 */
    .container {
        display: flex;
        max-width: 1200px;
        margin: 40px auto;
        gap: 40px;
    }

    .poster img {
        max-width: 100%;
        height: auto;
        border: 1px solid #ddd;
    }

    /* 우측 정보 영역 */
    .info-box {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 30px;
    }

    .select-seat {
        border: 1px solid #ddd;
        background-color: #fff;
        padding: 20px;
    }

    .select-seat h3 {
        margin-top: 0;
        font-size: 18px;
        margin-bottom: 10px;
    }

    .seat-list {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
    }

    .seat {
        background-color: #f0f4ff;
        color: #0044cc;
        padding: 8px 12px;
        border-radius: 4px;
        font-size: 14px;
    }

    .payment-box {
        border: 1px solid #ddd;
        background-color: #fff;
        padding: 20px;
    }

    .payment-box h3 {
        margin-top: 0;
        font-size: 18px;
        margin-bottom: 15px;
    }

    .payment-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
        font-size: 16px;
    }

    .payment-row.total {
        font-weight: bold;
        font-size: 18px;
    }

    .button-box {
        margin-top: 20px;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }

    .btn {
        padding: 10px 20px;
        border: none;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
    }

    .btn-back {
        background-color: #f1f1f1;
        color: #333;
    }

    .btn-pay {
        background-color: #007BFF;
        color: #fff;
    }

    /* 관람일자 */
    .date-select {
        margin-left: auto;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
        color: #333;
    }

    select {
        padding: 5px 10px;
        font-size: 14px;
    }
</style>
<!-- 상단 네비 -->
<div class="nav-bar">
    <img src="/images/com./logo.png" alt="logo">
    <a href="#">좌석확인</a>
    <span>${show.title}</span>

    <div class="date-select">
        <span>관람일자</span>
        <select>
            <option>2025.06.26(목) AM 10:00</option>
            <!-- 다른 날짜 옵션들 -->
        </select>
    </div>
</div>

<!-- 메인 컨텐츠 -->
<div class="container">
    <!-- 포스터 영역 -->
    <div class="poster">
        <img src="${show.posterLink}" alt="공연 포스터">
    </div>

    <!-- 정보 영역 -->
    <div class="info-box">
        <!-- 선택좌석 -->
        <div class="select-seat">
            <h3>선택좌석</h3>
            <div class="seat-list">
                <div class="seat">A석 1열 15-25석</div>
                <div class="seat">A석 12열 15-25석</div>
                <div class="seat">B석 16열 15-25석</div>
            </div>
        </div>

        <!-- 결제금액 -->
        <div class="payment-box">
            <h3>결제금액</h3>
            <div class="payment-row">
                <span>티켓금액</span>
                <span>132,000원</span>
            </div>
            <div class="payment-row">
                <span>기본가</span>
                <span>132,000원</span>
            </div>
            <div class="payment-row total">
                <span>총 결제금액</span>
                <span>132,000원</span>
            </div>

            <div class="button-box">
                <button class="btn btn-back" onclick="show.popupPre('${showDateId}');">이전</button>
                <button class="btn btn-pay" onclick="show.payment();">결제</button>
            </div>
        </div>
    </div>
</div>