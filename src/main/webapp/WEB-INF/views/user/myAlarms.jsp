<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <div class="qicon">
            <div class="myticket icons">
                <img src="images/myticket.svg" alt="ticket_icon">
                <div class="min_text">
                    <p>나의 예매권</p>
                    <a href="/myTickets"><p style="color:#2875FF;">3</p></a>
                </div>
            </div>
            <div class="love icons">
                <img src="images/love.svg" alt="ticket_icon">
                <div class="min_text">
                    <p>관심 공연</p>
                    <a href="/myLikes"><p style="color:#2875FF;">${myLikeCount}</p></a>
                </div>
            </div>
            <div class="alarm icons">
                <img src="images/alarm.svg" alt="ticket_icon">
                <div class="min_text">
                    <p>알림</p>
                    <a href="/myAlarms"><p style="color:#2875FF;">${myAlarmCount}</p></a>
                </div>
            </div>
        </div>

        <h3>나의 티켓팅 알림</h3>
        
        
    </main>
</div>
<%@include file="../com/footer.jsp"%>