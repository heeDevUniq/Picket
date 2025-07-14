<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <div class="qicon">
            <a href="/myTickets">
                <div class="myticket icons">
                    <img src="images/myticket.svg" alt="ticket_icon">
                    <div class="min_text">
                        <p>나의 예매권</p>
                        <p style="color:#2875FF;">3</p>
                    </div>
                </div>
            </a>
            <a href="/myLikes">
                <div class="love icons">
                    <img src="images/love.svg" alt="ticket_icon">
                    <div class="min_text">
                        <p>관심 공연</p>
                        <p style="color:#2875FF;">${myLikeCount}</p>
                    </div>
                </div>
            </a>
            <a href="/myAlarms">
                <div class="alarm icons">
                    <img src="images/alarm.svg" alt="ticket_icon">
                    <div class="min_text">
                        <p>알림</p>
                        <p style="color:#2875FF;">${myAlarmCount}</p>
                    </div>
                </div>
            </a>
        </div>

        <h3>예매 / 취소내역 </h3>
        <div class="tabs">
            <button class="tab_btn active">예매내역</button>
            <button class="tab_btn">취소내역</button>
        </div>

        <form method="get" action="reservation.jsp" class="filter-form">
            <div class="filters">
            <span>기간별 조회</span>
            <div class=" radio-buttons">
                <input type="radio" name="period" value="1" checked><label> 1개월</label>
                <input type="radio" name="period" value="3"><label> 3개월</label>
                <input type="radio" name="period" value="6"><label> 6개월</label>
            </div>
            <span>관람일시</span>
                <input type="date" name="viewDate">
                <span>티켓명</span>
                <input type="text" name="ticketName" placeholder="티켓명">
                <button type="submit" class="main_btn min_btn">조회</button>
            </div>
        </form>
        <table>
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