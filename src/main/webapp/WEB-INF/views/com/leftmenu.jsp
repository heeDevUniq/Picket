<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="uri" value="${pageContext.request.requestURI}" />

<div class="lm-card">
    <span class="lm-avatar">${fn:substring(sessionScope.LOGIN_NAME, 0, 1)}</span>
    <div class="lm-name">
        <b>${sessionScope.LOGIN_NAME}</b>
        <c:if test="${sessionScope.LOGIN_ROLE eq 'seller'}"><span class="lm-role">티켓셀러</span></c:if>
    </div>
    <span class="lm-email">${sessionScope.LOGIN_EMAIL}</span>
</div>

<nav class="lm-nav" aria-label="마이페이지 메뉴">
    <a href="/myTickets" class="${fn:contains(uri, 'myTickets') or fn:contains(uri, 'myLikes') or fn:contains(uri, 'myAlarms') ? 'is-on' : ''}">
        예매 / 취소내역
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
    </a>
    <a href="/myInfo" class="${fn:contains(uri, 'myInfo') ? 'is-on' : ''}">
        회원정보수정
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
    </a>
</nav>

<a href="#" class="lm-logout" onclick="user.logout(); return false;">로그아웃</a>
