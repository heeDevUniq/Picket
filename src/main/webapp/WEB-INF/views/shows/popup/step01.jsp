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
<script src="/js/show.js"></script>
<script src="/js/common.js"></script>
<style>
    body {
        margin: 0;
        background-color: #f9f9f9;
        color: #333;
    }

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
        color: #555;
        font-weight: normal;
    }

    .date-select {
        margin-left: auto;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
    }

    select {
        padding: 5px 10px;
        font-size: 14px;
    }

    .container {
        max-width: 1400px;
        margin: 40px auto;
        display: flex;
        gap: 30px;
    }

    .seat-map {
        background-color: #fff;
        border: 1px solid #ddd;
        padding: 30px;
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .screen {
        background-color: #e3eefe;
        color: #003399;
        font-weight: bold;
        width: 80%;
        text-align: center;
        padding: 10px;
        margin-bottom: 20px;
        border-radius: 5px;
    }

    .rows {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }

    .row {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .row-label {
        width: 20px;
        text-align: center;
        font-weight: bold;
        color: #333;
    }

    .seat {
        width: 30px;
        height: 30px;
        color: #fff;
        text-align: center;
        line-height: 30px;
        font-size: 12px;
        border-radius: 4px;
        cursor: pointer;
        user-select: none;
    }

    .seat input[type="checkbox"] {
        position: absolute;
        opacity: 0;
        width: 1px;
        height: 1px;
        margin: -1px;
    }

    .seat input[type="checkbox"]:checked + span {
        background-color: #ff6600;
    }

    .seat span {
        display: inline-block;
        width: 30px;
        height: 30px;
        text-align: center;
        line-height: 30px;
        border-radius: 4px;
        font-size: 12px;
        color: #fff;
        cursor: pointer;
        user-select: none;
    }

    .sidebar {
        width: 300px;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .grade-box, .selected-box {
        background-color: #fff;
        border: 1px solid #ddd;
        padding: 20px;
        font-size: 14px;
    }

    .grade-box h3, .selected-box h3 {
        margin-top: 0;
        font-size: 16px;
        margin-bottom: 10px;
    }

    .grade-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .grade-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .grade-item span.color {
        display: inline-block;
        width: 12px;
        height: 12px;
        border-radius: 2px;
        margin-right: 8px;
    }

    .color-vip { background-color: #1155CC; }
    .color-r { background-color: #4299E1; }
    .color-s { background-color: #ED8936; }
    .color-a { background-color: #E53E3E; }
    .color-b { background-color: #68D391; }
    .color-c { background-color: #EA57E0; }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
        margin-top: 10px;
    }

    table th, table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }

    table th {
        background-color: #f1f1f1;
    }

    .btn-box {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }

    .btn {
        padding: 10px 20px;
        font-size: 15px;
        border: none;
        cursor: pointer;
        border-radius: 4px;
    }

    .btn-prev {
        background-color: #f1f1f1;
        color: #333;
    }

    .btn-next {
        background-color: #007BFF;
        color: #fff;
    }

    .btn-next:disabled {
        background-color: #C9CDD4;
        cursor: not-allowed;
        transform: none !important;
        box-shadow: none !important;
    }

    .seat-map { position: relative; }

    .grade-block { display: flex; flex-direction: column; gap: 5px; }
    .grade-rest { font-variant-numeric: tabular-nums; color: #5A6272; font-size: 12.5px; }
    .grade-price { font-weight: 700; font-variant-numeric: tabular-nums; }
    .rest-bar { height: 5px; border-radius: 999px; background: #EFF1F5; overflow: hidden; }
    .rest-bar > i { display: block; height: 100%; border-radius: 999px; transition: width .5s cubic-bezier(.2,.8,.2,1); }

    .seat-info {
        background-color: #444;
        color: #fff;
        text-align: center;
        padding: 10px;
        margin-top: 20px;
        font-size: 14px;
    }

    .seat-info a {
        color: #00ccff;
        text-decoration: none;
    }
</style>
<script>
    // 좌석 선택/해제 시 목록·합계 갱신
    function toggleSeat(el) {
        const selected = [];
        const rows = [];
        let total = 0;

        $("input[name='seat']:checked").each(function () {
            const $s = $(this);
            const price = parseInt($s.data('price'), 10) || 0;
            total += price;
            selected.push($s.val());
            rows.push('<tr><td>' + $s.data('grade') + '석</td>'
                    + '<td>' + $s.data('seatNumber') + '번</td>'
                    + '<td>' + price.toLocaleString('ko-KR') + '원</td></tr>');
        });

        $("#seatArrays").val(selected.join(','));
        $("#selectedSeatBody").html(rows.length
            ? rows.join('')
            : '<tr><td colspan="3">선택한 좌석이 없습니다.</td></tr>');
        $("#seatCount").text(selected.length);
        $("#seatTotal").text(total.toLocaleString('ko-KR'));
        $("#selectedSeatCnt").text('[' + selected.length + ']');
        $(".btn-next").prop('disabled', selected.length === 0);

        if (el && el.checked) {
            pk.toast($(el).data('grade') + '석 ' + $(el).data('seatNumber') + '번 선택', 'ok');
        }
    }

    $(function () { toggleSeat(null); });
</script>
</head>
<body>
<div class="nav-bar">
    <img src="/images/com/logo.png" alt="logo">
    <a href="#">좌석선택</a>
    <span>${show.title}</span>
    <div class="date-select">
        <span>관람일자</span>
        <select>
            <option><fmt:formatDate value="${show.showDate}" pattern="yyyy.MM.dd(E) HH:mm" /></option>
        </select>
    </div>
</div>

<div class="pk-stepper" role="list">
    <span class="pk-step is-on" role="listitem"><i>1</i>좌석선택</span>
    <span class="pk-step-line"></span>
    <span class="pk-step " role="listitem"><i>2</i>결제</span>
    <span class="pk-step-line"></span>
    <span class="pk-step " role="listitem"><i>3</i>예매완료</span>
</div>

<div class="container">
    <!-- 좌석맵 -->
    <div class="seat-map">
        <div class="screen">SCREEN</div>
        <div class="rows">
            <c:forEach var="seat" items="${seats}" varStatus="i">
                <c:if test="${i.index % 10 == 0}">
                    <div class="row">
                        <div class="row-label"></div>
                </c:if>
                
                <label class="seat color-${fn:toLowerCase(seat.gradeName)}">
                    <input type="checkbox" name="seat" value="${seat.seatId}"
                           data-grade="${seat.gradeName}" data-seat-number="${seat.seatNumber}"
                           data-price="${seat.price}"
                           <c:if test="${seat.seatStatus ne 'available'}">disabled</c:if>
                           onchange="toggleSeat(this)">
                    <span>${seat.seatNumber}</span>
                </label>

                <c:if test="${(i.index + 1) % 10 == 0 || (i.index + 1) == fn:length(seats)}">
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- 우측 사이드 -->
    <div class="sidebar">
        <div class="grade-box">
            <h3>좌석등급/잔여석</h3>
            <div class="grade-list">
                <c:forEach var="grade" items="${grades}">
                    <div class="grade-block">
                        <div class="grade-item">
                            <span><span class="color color-${fn:toLowerCase(grade.gradeName)}"></span>${grade.gradeName}석</span>
                            <span class="grade-rest">${grade.remainCount} / ${grade.seatCount}석</span>
                            <span class="grade-price"><fmt:formatNumber value="${grade.price}" pattern="#,###" /></span>
                        </div>
                        <c:set var="ratio" value="${grade.seatCount > 0 ? (grade.remainCount * 100 / grade.seatCount) : 0}" />
                        <div class="rest-bar" title="잔여 ${grade.remainCount}석">
                            <i style="width:${ratio}%; background:${ratio le 20 ? '#DC3E32' : (ratio le 50 ? '#E08A0B' : '#0E9F6E')}"></i>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="selected-box">
            <h3>선택좌석</h3>
            <table>
                <thead>
                <tr>
                    <th>좌석등급</th>
                    <th>좌석번호</th>
                    <th>가격</th>
                </tr>
                </thead>
                <tbody id="selectedSeatBody">
                <tr>
                    <td colspan="3">선택한 좌석이 없습니다.</td>
                </tr>
                </tbody>
            </table>

            <div class="pk-seat-summary">
                <span><b id="seatCount">0</b>매 선택</span>
                <span>합계 <strong><span id="seatTotal">0</span>원</strong></span>
            </div>
        </div>

        <div class="btn-box">
            <button class="btn btn-prev" onclick="show.popupClose();">닫기</button>
            <button class="btn btn-next" onclick="show.popupNext();">다음</button>
        </div>
    </div>
</div>

<div class="seat-info">
    좌석을 선택해 주세요. <span id="selectedSeatCnt">[0]</span>
</div>

<form name="ticketingForm" id="ticketingForm" method="POST" action="/shows/payment">
    <input type="hidden" name="showId" value="${show.showId}">
    <input type="hidden" name="showDateId" value="${showDateId}">
    <input type="hidden" name="seatArrays" id="seatArrays" value="">
</form>
</body>
</html>
