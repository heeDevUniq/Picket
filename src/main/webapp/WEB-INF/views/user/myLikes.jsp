<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <%@ include file="/WEB-INF/views/com/mystats.jsp" %>

        <h2 class="pk-page-title">나의 관심공연</h2>
        <table>
            <thead>
                <tr>
                    <th>공연명</th>
                    <th>장소</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty likes}">
                        <c:forEach var="like" items="${likes}">
                            <tr>
                                <td><a href="/shows/view/${like.showId}">${like.title}</a></td>
                                <td>${like.place}</td>
                                <td><fmt:formatDate value="${like.insertDate}" pattern="yyyy-MM-dd" /></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3">관심 공연이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </main>
</div>
<%@include file="../com/footer.jsp"%>