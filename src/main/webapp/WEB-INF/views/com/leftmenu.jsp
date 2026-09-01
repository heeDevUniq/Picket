<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="user_name">
    <p>${sessionScope.LOGIN_NAME}</p>
    <c:if test="${sessionScope.LOGIN_ROLE eq 'seller'}"><img src="/images/seller.svg"></c:if>
    <span>${sessionScope.LOGIN_EMAIL}</span>
</div>

<div class="my-list">
    <div class="line"></div>
    <ul class="left-menu-list">
        <li><a href="/myTickets">예매 / 취소내역</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
		<li><a href="/myInfo">회원정보수정</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
		<!-- <li><a href="/notice">공지사항</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
		<li><a href="/open">예매오픈안내</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li> -->
	</ul>
    <span><a href="#" onclick="user.logout();">로그아웃</a></span>
</div>
