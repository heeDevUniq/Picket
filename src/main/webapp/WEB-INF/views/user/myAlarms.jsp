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
        <table>
            <thead>
                <tr>
                    <th>공연명</th>
                    <th>장소</th>
                    <th>예매오픈일시</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty alarms}">
                        <c:forEach var="alarm" items="${alarms}">
                            <tr>
                                <td><a href="/shows/view/${alarm.showId}">${alarm.title}</a></td>
                                <td>${alarm.place}</td>
                                <td><fmt:formatDate value="${alarm.openDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3">설정한 알림이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </main>
</div>
<%@include file="../com/footer.jsp"%>