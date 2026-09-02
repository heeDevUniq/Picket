<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <%@ include file="/WEB-INF/views/com/mystats.jsp" %>

        <h2 class="pk-page-title">나의 티켓팅 알림</h2>
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