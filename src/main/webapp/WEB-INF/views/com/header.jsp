<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>픽켓 : Pick! Your Ticket</title>
    <meta property="og:title" content="픽켓 : Pick! Your Ticket">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="/images/com/favicon.ico" type="image/x-icon">
    <link rel="icon" href="/images/favicon.ico" type="image/x-icon">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/user.js"></script>
</head>
<body>
<header>
    <div class="header">
        <div class="header-logo">
            <img src="/images/com/logo.png" alt="PICKET 로고">
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
                    <a href="#" class="login_off">
                        <img src="/images/user2.svg" alt="로그인 아이콘">
                        <span >로그인</span>
                    </a>
                     <a href="#" class="login_on">
                         <img src="/images/user2.svg" alt="로그인 아이콘">
                         <span >로그아웃</span>
                     </a>

                    </div>
                    <div class="my-ticket">
                     <a href="#">
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
        <li><a href="#">뮤지컬/연극</a></li>
        <li><a href="#">콘서트</a></li>
        <li><a href="#">클래식/무용</a></li>
        <li><a href="#">전시/행사</a></li>
        <li><a href="#">페스티벌</a></li>
    </ul>
</nav>

