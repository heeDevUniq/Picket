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
        display: none;
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
    .color-r { background-color: #68D391; }
    .color-s { background-color: #EA57E0; }

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
    let toggleSeatCnt = 0;
    let params = [];
    function toggleSeat(el) {
        el.classList.toggle('selected');
        console.log(el.value);
        params[toggleSeatCnt] = el.value;
        console.log('params : ',params);
        $("#seatArrays").val(params);
        toggleSeatCnt++;
    }
</script>
<div class="nav-bar">
    <img src="/images/com./logo.png" alt="logo">
    <a href="#">좌석선택</a>
    <span>${show.title}</span>
    <div class="date-select">
        <span>관람일자</span>
        <select>
            <option>${show.showDates}</option>
        </select>
    </div>
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
                
                <label class="seat color-${fn:toLowerCase(seat.seatGrade.gradeName)}">
                    <input type="checkbox" name="seat" value="${seat.seatId}" onchange="toggleSeat(this)">
                    <span>${i.count}</span>
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
                    <div class="grade-item">
                        <span><span class="color color-${grade.gradeName}"></span>${grade.gradeName}석</span>
                        <span>30석</span>
                        <span>140,000</span>
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
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>A석</td>
                    <td>1열 15 - 25석</td>
                </tr>
                <tr>
                    <td>A석</td>
                    <td>12열 15 - 25석</td>
                </tr>
                <tr>
                    <td>B석</td>
                    <td>16열 15 - 25석</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="btn-box">
            <button class="btn btn-prev" onclick="show.popupClose();">닫기</button>
            <button class="btn btn-next" onclick="show.popupNext();">다음</button>
        </div>
    </div>
</div>

<div class="seat-info">
    좌석을 선택해 주세요. <a href="#">[0]</a>
</div>

<form name="ticketingForm" id="ticketingForm">
    <input type="hidden" name="showId" value="${show.showId}">
    <input type="hidden" name="showDateId" value="${showDateId}">
    <input type="hidden" name="seatArrays" id="seatArrays" value="">
</form>