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
<script>window.PK_STEP = 1;</script>
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

    /* 스텝 */
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
    .bk-line { width: 46px; height: 1px; background: #DDE1E7; }

    .bk-date { display: flex; align-items: center; gap: 10px; margin-left: auto; }
    .bk-date > span { font-size: 13.5px; color: #5A6272; white-space: nowrap; }
    .bk-date select {
        height: 42px;
        padding: 0 12px;
        border: 1px solid #E4E7EC;
        border-radius: 10px;
        background: #fff;
        font-family: var(--pk-font-mono);
        font-size: 14px;
        font-weight: 600;
        color: #14161A;
        cursor: pointer;
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
    }

    .bk-map {
        display: flex;
        flex-direction: column;
        padding: 34px 28px 22px;
        border-radius: 16px;
        background: #fff;
    }

    .bk-screen {
        width: min(560px, 100%);
        margin: 0 auto 42px;
        padding: 14px;
        border-radius: 10px;
        background: #14161A;
        color: #fff;
        text-align: center;
        font-family: var(--pk-font-ui);
        font-size: 13px;
        font-weight: 700;
        letter-spacing: .28em;
    }

    .bk-grade-label {
        display: flex;
        align-items: center;
        gap: 7px;
        margin: 0 0 12px;
        font-size: 13px;
        font-weight: 600;
        color: #5A6272;
    }
    .bk-grade-label + .bk-rows { margin-bottom: 26px; }
    .bk-dot { width: 9px; height: 9px; border-radius: 3px; flex: none; }

    .bk-rows { display: flex; flex-wrap: wrap; justify-content: center; gap: 9px; }

    .bk-seat { position: relative; display: inline-flex; }
    .bk-seat input { position: absolute; opacity: 0; width: 0; height: 0; }

    /* 매진 좌석 툴팁 */
    .bk-seat.is-sold::before,
    .bk-seat.is-sold::after {
        position: absolute;
        left: 50%;
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
        transition: opacity .14s ease, visibility .14s ease, transform .14s ease;
        z-index: 5;
    }
    .bk-seat.is-sold::before {
        content: "매진";
        bottom: calc(100% + 8px);
        transform: translate(-50%, 4px);
        padding: 5px 10px;
        border-radius: 7px;
        background: #14161A;
        color: #fff;
        font-family: var(--pk-font-ui);
        font-size: 12px;
        font-weight: 600;
        line-height: 1.3;
        white-space: nowrap;
    }
    .bk-seat.is-sold::after {
        content: "";
        bottom: calc(100% + 3px);
        transform: translate(-50%, 4px);
        border: 5px solid transparent;
        border-top-color: #14161A;
    }
    .bk-seat.is-sold:hover::before,
    .bk-seat.is-sold:hover::after {
        opacity: 1;
        visibility: visible;
        transform: translate(-50%, 0);
    }
    .bk-seat span {
        display: grid;
        place-items: center;
        width: 46px;
        height: 46px;
        border: 1px solid #E4E7EC;
        border-radius: 10px;
        background: #fff;
        font-family: var(--pk-font-mono);
        font-size: 14px;
        font-weight: 500;
        color: #33383F;
        cursor: pointer;
        transition: all .14s cubic-bezier(.2,.8,.2,1);
    }
    .bk-seat span:hover { border-color: var(--pk-accent); color: var(--pk-accent-dark); }
    .bk-seat input:checked + span {
        background: var(--pk-accent);
        border-color: var(--pk-accent);
        color: #fff;
        font-weight: 700;
    }
    .bk-seat input:disabled + span {
        position: relative;
        background: #F1F3F6;
        border-color: #DDE1E7;
        color: #C2C7D0;
        cursor: not-allowed;
        overflow: hidden;
    }
    .bk-seat input:disabled + span:hover { border-color: #DDE1E7; color: #C2C7D0; }
    /* 점유석은 대각선 두 줄로 X 표시 */
    .bk-seat input:disabled + span::before,
    .bk-seat input:disabled + span::after {
        content: "";
        position: absolute;
        left: 50%;
        top: 50%;
        width: 140%;
        height: 1px;
        background: #D2D7DE;
    }
    .bk-seat input:disabled + span::before { transform: translate(-50%, -50%) rotate(45deg); }
    .bk-seat input:disabled + span::after  { transform: translate(-50%, -50%) rotate(-45deg); }
    .bk-seat input:focus-visible + span { outline: 2px solid var(--pk-accent); outline-offset: 2px; }

    .bk-legend {
        display: flex;
        justify-content: center;
        gap: 24px;
        margin-top: auto;
        padding-top: 32px;
        font-size: 13px;
        color: #5A6272;
    }
    .bk-legend span { display: flex; align-items: center; gap: 7px; }
    .bk-sr { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); }

    .bk-legend i { width: 14px; height: 14px; border-radius: 4px; }
    .bk-legend .free { border: 1px solid #DDE1E7; background: #fff; }
    .bk-legend .sel  { background: var(--pk-accent); }
    .bk-legend .done {
        position: relative;
        border: 1px solid #DDE1E7;
        background: #F1F3F6;
        overflow: hidden;
    }
    .bk-legend .done::before,
    .bk-legend .done::after {
        content: "";
        position: absolute;
        left: 50%;
        top: 50%;
        width: 140%;
        height: 1px;
        background: #D2D7DE;
    }
    .bk-legend .done::before { transform: translate(-50%, -50%) rotate(45deg); }
    .bk-legend .done::after  { transform: translate(-50%, -50%) rotate(-45deg); }

    /* 우측 */
    .bk-side { display: flex; flex-direction: column; gap: 26px; }
    .bk-sec-head {
        display: flex;
        align-items: baseline;
        justify-content: space-between;
        margin-bottom: 12px;
    }
    .bk-sec-head h2 { font-size: 15px; font-weight: 700; letter-spacing: -.015em; }
    .bk-sec-head small { font-size: 12.5px; color: #A0A6B2; }

    .bk-card {
        padding: 18px 20px;
        border: 1px solid #ECEEF2;
        border-radius: 14px;
        background: #fff;
    }

    .bk-grade + .bk-grade { margin-top: 18px; padding-top: 18px; border-top: 1px solid #F2F4F7; }
    .bk-grade-row {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14.5px;
    }
    .bk-grade-row .nm { font-weight: 700; }
    .bk-grade-row .rest {
        margin-left: auto;
        font-family: var(--pk-font-mono);
        font-size: 13.5px;
        color: #A0A6B2;
    }
    .bk-grade-row .price {
        font-family: var(--pk-font-mono);
        font-size: 15px;
        font-weight: 700;
        letter-spacing: -.01em;
    }
    .bk-bar { height: 4px; margin-top: 12px; border-radius: 999px; background: #EFF1F5; overflow: hidden; }
    .bk-bar i { display: block; height: 100%; border-radius: 999px; background: var(--pk-accent); }

    .bk-picked { padding: 0; overflow: hidden; }
    .bk-picked-list { padding: 18px 20px; min-height: 88px; }
    .bk-picked-empty { color: #A0A6B2; font-size: 13.5px; text-align: center; padding: 16px 0; }
    .bk-chip {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin: 0 6px 6px 0;
        padding: 7px 8px 7px 12px;
        border-radius: 999px;
        background: #EDF3FF;
        color: #1B4FD8;
        font-size: 13px;
        font-weight: 600;
    }
    .bk-chip b { font-family: var(--pk-font-mono); font-weight: 600; opacity: .8; }
    .bk-chip button {
        width: 18px; height: 18px;
        display: grid; place-items: center;
        border: 0; border-radius: 50%;
        background: rgba(27,79,216,.14);
        color: #1B4FD8;
        font-size: 12px;
        line-height: 1;
        cursor: pointer;
    }
    .bk-chip button:hover { background: rgba(27,79,216,.26); }

    .bk-total {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px 20px;
        background: #F7F8FA;
        border-top: 1px solid #ECEEF2;
        font-size: 13.5px;
        color: #5A6272;
    }
    .bk-total .sum { color: #5A6272; }
    .bk-total .sum b {
        font-family: var(--pk-font-ui);
        font-size: 21px;
        font-weight: 700;
        color: #14161A;
        margin-right: 2px;
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
    .bk-btn--next:disabled {
        background: #C9CDD4;
        border-color: #C9CDD4;
        color: #fff;
        cursor: not-allowed;
    }
    .bk-btn svg { width: 16px; height: 16px; }

    @media (max-width: 900px) {
        .bk-head { flex-wrap: wrap; padding: 12px 16px; gap: 10px; }
        .bk-steps { order: 3; width: 100%; margin: 0; justify-content: center; }
        .bk-line { width: 22px; }
        .bk-date { margin-left: auto; }
        .bk-date > span { display: none; }
        .bk-body { grid-template-columns: 1fr; padding: 16px; gap: 18px; }
        .bk-map { padding: 22px 14px 16px; overflow-x: auto; }
        .bk-rows { min-width: 340px; }
        .bk-seat span { width: 38px; height: 38px; font-size: 13px; }
        .bk-legend { padding-top: 22px; gap: 16px; flex-wrap: wrap; }
        .bk-foot { padding: 12px 16px; flex-wrap: wrap; }
        .bk-btns { width: 100%; margin-left: 0; }
        .bk-btns .bk-btn { flex: 1; }
    }
</style>
</head>
<body>

<header class="bk-head">
    <div class="bk-title">
        <span class="bk-genre">
            <c:choose>
                <c:when test="${show.genre eq 'musical'}">뮤지컬·연극</c:when>
                <c:when test="${show.genre eq 'concert'}">콘서트</c:when>
                <c:when test="${show.genre eq 'classic'}">클래식·무용</c:when>
                <c:when test="${show.genre eq 'exhibit'}">전시·행사</c:when>
                <c:when test="${show.genre eq 'festival'}">페스티벌</c:when>
                <c:otherwise>공연</c:otherwise>
            </c:choose>
        </span>
        <span class="bk-name">${show.title}</span>
    </div>

    <div class="bk-steps">
        <span class="bk-step is-on"><i>1</i>좌석선택</span>
        <span class="bk-line"></span>
        <span class="bk-step"><i>2</i>결제</span>
        <span class="bk-line"></span>
        <span class="bk-step"><i>3</i>예매완료</span>
    </div>

    <div class="bk-date">
        <span>관람일자</span>
        <select onchange="location.href='/shows/getTickets?showDateId=' + this.value;" aria-label="관람일자 선택">
            <c:forEach var="d" items="${showDates}">
                <option value="${d.showDateId}" ${d.showDateId eq showDateId ? 'selected' : ''}>
                    <fmt:formatDate value="${d.showDate}" pattern="yyyy.MM.dd(E) HH:mm" />
                </option>
            </c:forEach>
        </select>
        <button type="button" class="bk-x" onclick="show.popupClose(1);" aria-label="닫기">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
        </button>
    </div>
</header>

<div class="bk-body">
    <section class="bk-map">
        <div class="bk-screen">SCREEN</div>

        <c:forEach var="grade" items="${grades}" varStatus="gi">
            <c:if test="${fn:length(grades) > 1}">
                <div class="bk-grade-label">
                    <i class="bk-dot color-${fn:toLowerCase(grade.gradeName)}"></i>${grade.gradeName}석
                </div>
            </c:if>
            <div class="bk-rows">
                <c:forEach var="seat" items="${seats}">
                    <c:if test="${seat.seatGradeId eq grade.seatGradeId}">
                        <c:set var="isSold" value="${not empty seat.seatStatus and seat.seatStatus ne 'available'}" />
                        <label class="bk-seat${isSold ? ' is-sold' : ''}">
                            <input type="checkbox" name="seat" value="${seat.seatId}"
                                   data-grade="${seat.gradeName}" data-seat-number="${seat.seatNumber}"
                                   data-price="${seat.price}"
                                   ${isSold ? 'disabled' : ''}
                                   onchange="toggleSeat(this)">
                            <span>${seat.seatNumber}</span>
                            <c:if test="${isSold}"><em class="bk-sr">매진</em></c:if>
                        </label>
                    </c:if>
                </c:forEach>
            </div>
        </c:forEach>

        <div class="bk-legend">
            <span><i class="free"></i>선택 가능</span>
            <span><i class="sel"></i>선택함</span>
            <span><i class="done"></i>예매 완료</span>
        </div>
    </section>

    <aside class="bk-side">
        <div>
            <div class="bk-sec-head"><h2>좌석등급 · 잔여석</h2></div>
            <div class="bk-card">
                <c:forEach var="grade" items="${grades}">
                    <c:set var="ratio" value="${grade.seatCount > 0 ? (grade.remainCount * 100 / grade.seatCount) : 0}" />
                    <div class="bk-grade">
                        <div class="bk-grade-row">
                            <i class="bk-dot color-${fn:toLowerCase(grade.gradeName)}"></i>
                            <span class="nm">${grade.gradeName}석</span>
                            <span class="rest">${grade.remainCount} / ${grade.seatCount}석</span>
                            <span class="price"><fmt:formatNumber value="${grade.price}" pattern="#,###" />원</span>
                        </div>
                        <div class="bk-bar"><i style="width:${ratio}%"></i></div>
                    </div>
                </c:forEach>
                <c:if test="${empty grades}">
                    <div class="bk-picked-empty">등록된 좌석 등급이 없습니다.</div>
                </c:if>
            </div>
        </div>

        <div>
            <div class="bk-sec-head"><h2>선택좌석</h2><small>최대 4매</small></div>
            <div class="bk-card bk-picked">
                <div class="bk-picked-list" id="pickedList">
                    <div class="bk-picked-empty">좌석을 선택해 주세요</div>
                </div>
                <div class="bk-total">
                    <span><b id="seatCount">0</b>매 선택</span>
                    <span class="sum">합계 <b id="seatTotal">0</b>원</span>
                </div>
            </div>
        </div>
    </aside>
</div>

<footer class="bk-foot">
    <span class="bk-hint" id="bkHint">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <circle cx="12" cy="12" r="9"/><path d="M12 16v-4M12 8h.01"/>
        </svg>
        좌석을 선택하면 다음 단계로 이동할 수 있어요
    </span>
    <div class="bk-btns">
        <button type="button" class="bk-btn" onclick="show.popupClose(1);">닫기</button>
        <button type="button" class="bk-btn bk-btn--next" id="btnNext" onclick="show.popupNext();" disabled>
            다음
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </button>
    </div>
</footer>

<form name="ticketingForm" id="ticketingForm" method="POST" action="/shows/payment">
    <input type="hidden" name="showId" value="${show.showId}">
    <input type="hidden" name="showDateId" value="${showDateId}">
    <input type="hidden" name="seatArrays" id="seatArrays" value="">
</form>

<script>
    const MAX_SEATS = 4;

    // 좌석 선택/해제 시 목록·합계 갱신
    function toggleSeat(el) {
        const picked = $("input[name='seat']:checked");

        if (picked.length > MAX_SEATS) {
            el.checked = false;
            pk.toast('최대 ' + MAX_SEATS + '매까지 선택할 수 있어요', 'err');
            return;
        }
        render();
    }

    function removeSeat(seatId) {
        const cb = document.querySelector("input[name='seat'][value='" + seatId + "']");
        if (cb) { cb.checked = false; render(); }
    }

    function render() {
        const ids = [], chips = [];
        let total = 0;

        $("input[name='seat']:checked").each(function () {
            const $s = $(this);
            const price = parseInt($s.data('price'), 10) || 0;
            total += price;
            ids.push($s.val());
            chips.push('<span class="bk-chip">' + $s.data('grade') + '석 ' + $s.data('seatNumber') + '번'
                     + '<b>' + price.toLocaleString('ko-KR') + '</b>'
                     + '<button type="button" aria-label="선택 해제" onclick="removeSeat(\'' + $s.val() + '\')">&times;</button>'
                     + '</span>');
        });

        $("#seatArrays").val(ids.join(','));
        $("#pickedList").html(chips.length ? chips.join('') : '<div class="bk-picked-empty">좌석을 선택해 주세요</div>');
        $("#seatCount").text(ids.length);
        $("#seatTotal").text(total.toLocaleString('ko-KR'));
        $("#btnNext").prop('disabled', ids.length === 0);
        $("#bkHint").css('visibility', ids.length ? 'hidden' : 'visible');
    }

    $(function () { render(); });
</script>

</body>
</html>
