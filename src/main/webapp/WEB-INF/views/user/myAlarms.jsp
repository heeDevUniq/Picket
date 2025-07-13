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

        <h3>나의 티켓팅 알림</h3>
        
        
    </main>
</div>
<%@include file="../com/footer.jsp"%>