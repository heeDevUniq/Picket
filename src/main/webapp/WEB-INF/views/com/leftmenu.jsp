<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="user_name">
    <p>${session.LOGIN_NAME}</p>
    <span>${session.LOGIN_EMAIL}</span>
</div>

<div class="my-list">
    <div class="line"></div>
    <ul class="left-menu-list">
        <li><a href="/myTickets">예매 / 취소내역</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
        <li><a href="/myInfo">회원정보수정</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
        <li><a href="/notice">공지사항</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
        <li><a href="/open">예매오픈안내</a><img src="/images/right_arrow.svg" alt="오른쪽방향 화살"></li>
    </ul>
    <span><a href="#" onclick="user.logout();">로그아웃</a></span>
</div>
