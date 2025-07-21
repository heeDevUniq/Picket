<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>픽켓 : Pick! Your Ticket</title>
    <meta property="og:title" content="픽켓 : Pick! Your Ticket">
    <link rel="shortcut icon" href="/images/com/favicon.ico" type="image/x-icon">
    <link rel="icon" href="/images/com/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/user.js"></script>
</head>
<body>
<header>
    <div class="header">
        <div class="header-logo">
            <a href="/index"><img src="/images/com/logo.png" alt="PICKET 로고"></a>
        </div>
        <div class="my-box">
            <div class="search-box">
                <input type="text" placeholder="인기 공연 / 콘서트 혜택 모음">
                <button class="search-btn">
                    <img src="/images/search.svg" alt="검색">
                </button>
            </div>
            <div class="my-icon-box">
                <div class="my-login">
                    <c:choose>
                        <c:when test="${session.LOGIN_EMAIL != null}">
                             <a href="#" onclick="user.logout();" class="login_on">
                                 <img src="/images/user2.svg" alt="로그아웃 아이콘">
                                 <span>로그아웃</span>
                             </a>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="login_off">
                                <img src="/images/user2.svg" alt="로그인 아이콘">
                                <span>로그인</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="my-ticket">
                     <a href="/myTickets">
                        <img src="/images/ticket.svg" alt="예약 아이콘">
                        <span>예약</span>
                     </a>
                </div>
            </div>
        </div>
    </div>
</header>

<nav>
    <ul>
        <li><a href="/shows/list/musical">뮤지컬/연극</a></li>
        <li><a href="/shows/list/concert">콘서트</a></li>
        <li><a href="/shows/list/classic">클래식/무용</a></li>
        <li><a href="/shows/list/exhibit">전시/행사</a></li>
        <li><a href="/shows/list/festival">페스티벌</a></li>
    </ul>
    <ul>
    <li><a href="/notice">공지사항</a></li>
    <li><a href="/open"">예매오픈안내</a></li>
    <ul>
</nav>

