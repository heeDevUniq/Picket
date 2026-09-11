<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>픽켓 예매</title>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.css">
<link rel="stylesheet" href="/css/typography.css">
<link rel="stylesheet" href="/css/interactive.css">
<link rel="stylesheet" href="/css/responsive.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="/js/interactive.js"></script>
<script src="/js/common.js"></script>
<script src="/js/show.js"></script>
<script>window.PK_STEP = 0;</script>
<style>
    html, body { height: 100%; }
    body {
        margin: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 22px;
        padding: 40px 26px;
        background: #F6F7F9;
        color: #14161A;
        text-align: center;
        box-sizing: border-box;
    }
    .pf-ico {
        width: 64px; height: 64px;
        display: grid; place-items: center;
        border-radius: 50%;
        background: #FDECEC;
        color: #E14B4B;
    }
    .pf-ico svg { width: 32px; height: 32px; stroke-linecap: round; stroke-linejoin: round; }
    h1 {
        margin: 0;
        font-family: var(--pk-font-ui);
        font-size: 22px;
        font-weight: 700;
        letter-spacing: -.025em;
    }
    .pf-msg {
        margin: 0;
        max-width: 460px;
        font-size: 14.5px;
        line-height: 1.7;
        color: #5A6272;
        word-break: keep-all;
    }
    .pf-code {
        padding: 5px 12px;
        border-radius: 999px;
        background: #EFF1F5;
        color: #8A9099;
        font-size: 12px;
        font-variant-numeric: tabular-nums;
        letter-spacing: .02em;
    }
    .pf-btns { display: flex; gap: 10px; margin-top: 6px; }
    .bk-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: 46px;
        padding: 0 26px;
        border: 1px solid #E4E7EC;
        border-radius: 11px;
        background: #fff;
        color: #33383F;
        font-family: var(--pk-font-ui);
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all .16s cubic-bezier(.2,.8,.2,1);
    }
    .bk-btn:hover { border-color: #C7CDD6; }
    .bk-btn--next {
        background: var(--pk-accent);
        border-color: var(--pk-accent);
        color: #fff;
        font-weight: 700;
    }
    .bk-btn--next:hover { background: var(--pk-accent-dark); border-color: var(--pk-accent-dark); }
</style>
</head>
<body>

<span class="pf-ico">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="9"/><path d="M15 9l-6 6M9 9l6 6"/>
    </svg>
</span>

<h1>${empty failTitle ? '결제가 완료되지 않았어요' : failTitle}</h1>
<p class="pf-msg">${failMessage}</p>
<span class="pf-code">${failCode}</span>

<div class="pf-btns">
    <button type="button" class="bk-btn" onclick="show.popupCloseNow();">닫기</button>
    <c:choose>
        <c:when test="${failAction eq 'login'}">
            <button type="button" class="bk-btn bk-btn--next" onclick="show.goLogin();">로그인하기</button>
        </c:when>
        <c:otherwise>
            <button type="button" class="bk-btn bk-btn--next" onclick="location.href='/index';">공연 둘러보기</button>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
