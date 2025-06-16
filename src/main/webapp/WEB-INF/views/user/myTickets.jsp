<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
    <h2>예매 / 취소내역 </h2>
        <div class="tabs">
            <button class="tab_btn active">예매내역</button>
            <button class="tab_btn">취소내역</button>
        </div>

        <form method="get" action="reservation.jsp" class="filter-form">
            <div class="filters">
            <span>기간별 조회</span>
            <div class=" radio-buttons">
                <input type="radio" name="period" value="1" checked><label> 1개월</label>
                <input type="radio" name="period" value="3"> <label> 3개월</label>
                <input type="radio" name="period" value="6"><label> 6개월</label>
            </div>
            <span>관람일시</span>
                <input type="date" name="viewDate">
                <span>티켓명</span>
                <input type="text" name="ticketName" placeholder="티켓명">
                <button type="submit" class="main_btn min_btn">조회</button>
            </div>
        </form>
        <table class="reservation-table">
            <thead>
                <tr>
                    <th>예매번호</th>
                    <th>티켓명</th>
                    <th>관람일시</th>
                    <th>매수</th>
                    <th>취소가능일</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>-</td>
                    <td>-</td>
                    <td>-</td>
                    <td>-</td>
                    <td>-</td>
                </tr>
            </tbody>
        </table>
    </main>
</div>
<%@include file="../com/footer.jsp"%>