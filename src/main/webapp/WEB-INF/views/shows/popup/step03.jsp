<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<script>window.PK_STEP = 3;</script>
<style>
    html, body { height: 100%; }
    body {
        margin: 0;
        display: flex;
        flex-direction: column;
        background: #F6F7F9;
        color: #14161A;
    }

    /* 상단 바 */
    .bk-head {
        display: flex;
        align-items: center;
        gap: 18px;
        flex: none;
        padding: 16px 26px;
        background: #fff;
        border-bottom: 1px solid #ECEEF2;
    }
    .bk-title { display: flex; align-items: center; gap: 12px; min-width: 0; }
    .bk-genre {
        padding: 4px 11px;
        border-radius: 999px;
        background: #EDF3FF;
        color: #1B4FD8;
        font-size: 12px;
        font-weight: 700;
        white-space: nowrap;
    }
    .bk-name {
        font-family: var(--pk-font-ui);
        font-size: 17px;
        font-weight: 700;
        letter-spacing: -.02em;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .bk-steps { display: flex; align-items: center; gap: 12px; margin: 0 auto; }
    .bk-step { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #A0A6B2; white-space: nowrap; }
    .bk-step i {
        width: 22px; height: 22px;
        display: grid; place-items: center;
        border-radius: 50%;
        background: #EFF1F5;
        color: #A0A6B2;
        font-family: var(--pk-font-mono);
        font-size: 11px;
        font-style: normal;
        font-weight: 600;
    }
    .bk-step.is-on { color: #14161A; font-weight: 700; }
    .bk-step.is-on i { background: var(--pk-accent); color: #fff; }
    .bk-step.is-done { color: #5A6272; }
    .bk-step.is-done i { background: #EDF3FF; color: #1B4FD8; font-size: 0; }
    .bk-step.is-done i::after { content: "✓"; font-size: 12px; }
    .bk-line { width: 46px; height: 1px; background: #DDE1E7; }

    .bk-date { display: flex; align-items: center; gap: 10px; margin-left: auto; }
    .bk-date > span { font-size: 13.5px; color: #5A6272; white-space: nowrap; }
    .bk-date .value {
        height: 42px;
        display: flex;
        align-items: center;
        padding: 0 14px;
        border-radius: 10px;
        background: #F1F3F6;
        font-family: var(--pk-font-mono);
        font-size: 14px;
        font-weight: 600;
    }
    .bk-x {
        width: 40px; height: 40px;
        display: grid; place-items: center;
        border: 0; border-radius: 10px;
        background: none;
        color: #5A6272;
        cursor: pointer;
        transition: background .16s cubic-bezier(.2,.8,.2,1);
    }
    .bk-x:hover { background: #F1F3F6; }
    .bk-x svg { width: 20px; height: 20px; }

    /* 본문 */
    .bk-body {
        flex: 1;
        min-height: 0;
        display: grid;
        grid-template-columns: 1fr 340px;
        gap: 26px;
        padding: 24px 26px;
        overflow: auto;
        align-content: start;
    }

    .bk-card {
        padding: 22px 24px;
        border-radius: 16px;
        background: #fff;
    }
    .bk-card > h2 {
        font-size: 15px;
        font-weight: 700;
        letter-spacing: -.015em;
        margin-bottom: 16px;
    }

    /* 완료 배너 */
    .bk-done {
        display: flex;
        align-items: center;
        gap: 18px;
        padding: 22px 24px;
        margin-bottom: 18px;
        border-radius: 16px;
        background: linear-gradient(135deg, #EDF3FF 0%, #F7FAFF 100%);
    }
    .bk-done-ico {
        width: 56px; height: 56px;
        flex: none;
        display: grid; place-items: center;
        border-radius: 50%;
        background: var(--pk-accent);
        color: #fff;
        animation: bkPop .42s cubic-bezier(.2,1.2,.4,1) both;
    }
    .bk-done-ico svg { width: 30px; height: 30px; stroke-linecap: round; stroke-linejoin: round; }
    @keyframes bkPop { from { transform: scale(.5); opacity: 0; } to { transform: none; opacity: 1; } }
    .bk-done-txt h1 {
        margin: 0 0 6px;
        font-family: var(--pk-font-ui);
        font-size: 22px;
        font-weight: 700;
        letter-spacing: -.025em;
    }
    .bk-done-txt p { margin: 0; font-size: 14px; color: #5A6272; line-height: 1.6; }

    /* 예매번호 */
    .bk-no {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        margin-bottom: 18px;
        padding: 14px 20px;
        border: 1px dashed #C7D5F0;
        border-radius: 12px;
        background: #FBFCFE;
    }
    .bk-no span { font-size: 13.5px; color: #5A6272; }
    .bk-no b {
        font-family: var(--pk-font-mono);
        font-size: 17px;
        font-weight: 600;
        letter-spacing: .02em;
        color: var(--pk-accent-dark);
    }

    /* 공연 요약 */
    .bk-summary { display: flex; gap: 20px; align-items: flex-start; }
    .bk-poster {
        width: 116px;
        flex: none;
        aspect-ratio: 3 / 4;
        border-radius: 12px;
        overflow: hidden;
        background: #F1F3F6;
    }
    .bk-poster img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .bk-summary-info { min-width: 0; }
    .bk-summary-info .t {
        font-family: var(--pk-font-ui);
        font-size: 17px;
        font-weight: 700;
        letter-spacing: -.02em;
        margin-bottom: 10px;
    }
    .bk-meta { display: grid; grid-template-columns: 76px 1fr; row-gap: 7px; font-size: 13.5px; }
    .bk-meta dt { color: #A0A6B2; }
    .bk-meta dd { margin: 0; color: #33383F; font-weight: 500; }
    .bk-meta .num { font-family: var(--pk-font-mono); font-weight: 600; }

    /* 예매 좌석 */
    .bk-seats { margin-top: 18px; padding-top: 18px; border-top: 1px solid #F2F4F7; }
    .bk-chips { display: flex; flex-wrap: wrap; gap: 8px; }
    .bk-chip {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 14px;
        border-radius: 999px;
        background: #EDF3FF;
        color: #1B4FD8;
        font-size: 13.5px;
        font-weight: 600;
    }
    .bk-chip b { font-family: var(--pk-font-mono); font-weight: 600; opacity: .75; }
    .bk-empty { font-size: 13.5px; color: #A0A6B2; }

    /* 결제 내역 */
    .bk-pay-row {
        display: flex;
        align-items: baseline;
        justify-content: space-between;
        padding: 8px 0;
        font-size: 14px;
        color: #5A6272;
    }
    .bk-pay-row b { font-family: var(--pk-font-mono); font-weight: 500; color: #14161A; }
    .bk-pay-total {
        display: flex;
        align-items: baseline;
        justify-content: space-between;
        margin-top: 12px;
        padding-top: 16px;
        border-top: 1px solid #ECEEF2;
        font-size: 15px;
        font-weight: 700;
    }
    .bk-pay-total .amt {
        font-family: var(--pk-font-ui);
        font-size: 24px;
        font-weight: 700;
        color: var(--pk-accent-dark);
        letter-spacing: -.02em;
    }

    /* 안내 */
    .bk-guide { margin-top: 20px; padding-top: 18px; border-top: 1px solid #F2F4F7; }
    .bk-guide ul { margin: 0; padding: 0; list-style: none; }
    .bk-guide li {
        position: relative;
        padding-left: 13px;
        margin-bottom: 8px;
        font-size: 12.5px;
        color: #8A9099;
        line-height: 1.7;
    }
    .bk-guide li::before {
        content: "";
        position: absolute;
        left: 2px; top: 9px;
        width: 3px; height: 3px;
        border-radius: 50%;
        background: #C7CDD6;
    }

    /* 하단 바 */
    .bk-foot {
        display: flex;
        align-items: center;
        gap: 12px;
        flex: none;
        padding: 16px 26px;
        background: #fff;
        border-top: 1px solid #ECEEF2;
    }
    .bk-hint { display: flex; align-items: center; gap: 8px; font-size: 13.5px; color: #A0A6B2; }
    .bk-hint svg { width: 16px; height: 16px; flex: none; }
    .bk-btns { margin-left: auto; display: flex; gap: 10px; }
    .bk-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
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
    .bk-btn svg { width: 16px; height: 16px; }

    @media (max-width: 900px) {
        .bk-head { flex-wrap: wrap; padding: 12px 16px; gap: 10px; }
        .bk-steps { order: 3; width: 100%; margin: 0; justify-content: center; }
        .bk-line { width: 22px; }
        .bk-date > span { display: none; }
        .bk-body { grid-template-columns: 1fr; padding: 16px; gap: 16px; }
        .bk-done { flex-direction: column; text-align: center; gap: 12px; padding: 22px 18px; }
        .bk-summary { gap: 14px; }
        .bk-poster { width: 92px; }
        .bk-foot { padding: 12px 16px; flex-wrap: wrap; }
        .bk-btns { width: 100%; margin-left: 0; }
        .bk-btns .bk-btn { flex: 1; }
    }
</style>
</head>
<body>

<c:set var="totalAmount" value="0" />
<c:forEach var="seat" items="${seats}">
    <c:set var="totalAmount" value="${totalAmount + seat.price}" />
</c:forEach>

<header class="bk-head">
    <div class="bk-title">
        <span class="bk-genre">
            <c:choose>
                <c:when test="${show.genre eq 'musical'}">뮤지컬·연극</c:when>
                <c:when test="${show.genre eq 'concert'}">콘서트</c:when>
                <c:when test="${show.genre eq 'classic'}">클래식·무용</c:when>
                <c:when test="${show.genre eq 'exhibit'}">전시·행사</c:when>
                <c:when test="${show.genre eq 'festival'}">페스티벌</c:when>
                        <c:when test="${show.genre eq 'etc'}">기타</c:when>
                <c:otherwise>공연</c:otherwise>
            </c:choose>
        </span>
        <span class="bk-name">${fn:escapeXml(show.title)}</span>
    </div>

    <div class="bk-steps">
        <span class="bk-step is-done"><i>1</i>좌석선택</span>
        <span class="bk-line"></span>
        <span class="bk-step is-done"><i>2</i>결제</span>
        <span class="bk-line"></span>
        <span class="bk-step is-on"><i>3</i>예매완료</span>
    </div>

    <div class="bk-date">
        <span>관람일자</span>
        <span class="value"><fmt:formatDate value="${show.showDate}" pattern="yyyy.MM.dd(E) HH:mm" /></span>
        <button type="button" class="bk-x" onclick="show.popupClose(3);" aria-label="닫기">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
        </button>
    </div>
</header>

<div class="bk-body">
    <section>
        <div class="bk-done">
            <span class="bk-done-ico">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <path d="M5 12.5l4.5 4.5L19 7.5"/>
                </svg>
            </span>
            <div class="bk-done-txt">
                <h1>예매가 완료되었어요</h1>
                <p>예매 내역은 마이페이지 &gt; 예매/취소내역에서 확인할 수 있습니다.</p>
            </div>
        </div>

        <div class="bk-card">
            <div class="bk-no">
                <span>예매번호</span>
                <b>${bookedNumber}</b>
            </div>

            <div class="bk-summary">
                <div class="bk-poster">
                    <img src="${fn:escapeXml(show.posterLink)}" alt="${fn:escapeXml(show.title)} 포스터" data-show-id="${show.showId}">
                </div>
                <div class="bk-summary-info">
                    <div class="t">${fn:escapeXml(show.title)}</div>
                    <dl class="bk-meta">
                        <dt>장소</dt><dd>${fn:escapeXml(show.place)}</dd>
                        <dt>관람일시</dt><dd class="num"><fmt:formatDate value="${show.showDate}" pattern="yyyy.MM.dd(E) HH:mm" /></dd>
                        <dt>관람가</dt><dd>${empty show.ageLimit ? '전체 관람가' : fn:escapeXml(show.ageLimit)}</dd>
                    </dl>
                </div>
            </div>

            <div class="bk-seats">
                <h2>예매좌석 ${fn:length(seats)}매</h2>
                <div class="bk-chips">
                    <c:forEach var="seat" items="${seats}">
                        <span class="bk-chip">
                            ${fn:escapeXml(seat.gradeName)}석 ${seat.seatNumber}번
                            <b><fmt:formatNumber value="${seat.price}" pattern="#,###" /></b>
                        </span>
                    </c:forEach>
                    <c:if test="${empty seats}">
                        <span class="bk-empty">좌석 정보를 불러오지 못했습니다.</span>
                    </c:if>
                </div>
            </div>
        </div>
    </section>

    <aside class="bk-card">
        <h2>결제내역</h2>
        <div class="bk-pay-row">
            <span>티켓금액</span>
            <b><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</b>
        </div>
        <div class="bk-pay-row">
            <span>매수</span>
            <b>${fn:length(seats)}매</b>
        </div>
        <div class="bk-pay-row">
            <span>수수료</span>
            <b>0원</b>
        </div>
        <c:if test="${not empty payMethod}">
            <div class="bk-pay-row">
                <span>결제수단</span>
                <b>${payMethod}</b>
            </div>
        </c:if>
        <div class="bk-pay-total">
            <span>결제완료 금액</span>
            <span class="amt"><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</span>
        </div>

        <div class="bk-guide">
            <ul>
                <li>공연 3일 전까지 취소 시 전액 환불됩니다</li>
                <li>티켓은 공연 당일 현장 매표소에서 예매번호로 수령합니다</li>
                <li>예매자 본인 확인을 위해 신분증을 지참해주세요</li>
            </ul>
        </div>
    </aside>
</div>

<footer class="bk-foot">
    <span class="bk-hint">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <circle cx="12" cy="12" r="9"/><path d="M12 16v-4M12 8h.01"/>
        </svg>
        예매번호는 마이페이지에서 다시 확인할 수 있어요
    </span>
    <div class="bk-btns">
        <button type="button" class="bk-btn" onclick="show.popupClose(3);">닫기</button>
        <button type="button" class="bk-btn bk-btn--next" onclick="show.goMyTickets();">
            예매내역 보기
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </button>
    </div>
</footer>

<script>
// 완료 후 뒤로가기로 결제 화면 복귀 차단
history.replaceState(null, '', location.href);

// 완료 화면 한가운데서 축포
window.addEventListener('load', function () {
    setTimeout(function () { pk.confetti(); }, 200);
});
</script>

</body>
</html>
