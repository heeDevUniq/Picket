<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<style>
/* mytickets-space */
.pk-page-title { margin: 0 0 4px; }

.pk-btn-cancel {
    height: 32px;
    padding: 0 14px;
    border: 1px solid #F3C9C9;
    border-radius: 8px;
    background: #FEF4F4;
    color: #D64545;
    font-family: var(--pk-font-ui);
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.pk-btn-cancel:hover { background: #E14B4B; border-color: #E14B4B; color: #fff; }
.pk-btn-cancel:disabled { opacity: .5; cursor: not-allowed; }
.pk-cancel-off { font-size: 12.5px; color: #B4BAC4; white-space: nowrap; }

/* 폭에 맞춰 접히는 칸과 붙여 두는 칸 구분 */
.ticket-table .col-no {
    font-size: 12px;
    color: #5A6272;
    letter-spacing: -.02em;
    word-break: break-all;
}
.ticket-table .col-title { word-break: keep-all; }
.ticket-table .col-seat { word-break: keep-all; }
.ticket-table .nowrap { white-space: nowrap; }
.ticket-table .num { font-variant-numeric: tabular-nums; }
.ticket-table .col-act { width: 92px; text-align: right; }
</style>

<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <%@ include file="/WEB-INF/views/com/mystats.jsp" %>

        <h2 class="pk-page-title">예매 / 취소내역</h2>

        <div class="pk-subtabs" id="ticketTabs">
            <a href="/myTickets" class="${param.tab eq 'canceled' ? '' : 'active'}">예매내역</a>
            <a href="/myTickets?tab=canceled" class="${param.tab eq 'canceled' ? 'active' : ''}">취소내역</a>
        </div>

        <form method="get" action="/myTickets" class="pk-filter">
            <input type="hidden" name="tab" value="${fn:escapeXml(param.tab)}">
            <label>기간</label>
            <div class="pk-seg">
                <input type="radio" name="period" id="p1" value="1" ${empty param.period or param.period eq '1' ? 'checked' : ''}>
                <label for="p1">1개월</label>
                <input type="radio" name="period" id="p3" value="3" ${param.period eq '3' ? 'checked' : ''}>
                <label for="p3">3개월</label>
                <input type="radio" name="period" id="p6" value="6" ${param.period eq '6' ? 'checked' : ''}>
                <label for="p6">6개월</label>
            </div>

            <label for="viewDate">관람일시</label>
            <input type="date" id="viewDate" name="viewDate" value="${param.viewDate}">

            <label for="ticketName">티켓명</label>
            <input type="text" id="ticketName" name="ticketName" value="${fn:escapeXml(param.ticketName)}" placeholder="티켓명을 입력하세요">

            <button type="submit" class="pk-submit">조회</button>
        </form>

        <c:choose>
            <c:when test="${empty tickets}">
                <div class="pk-empty-box">
                    <span class="ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                            <path d="M3 8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4V8z"/>
                            <path d="M14 6v12" stroke-dasharray="2 3"/>
                        </svg>
                    </span>
                    <c:choose>
                        <c:when test="${param.tab eq 'canceled'}">
                            <b>취소한 예매가 없어요</b>
                            <p>취소한 티켓이 여기에 표시됩니다.</p>
                        </c:when>
                        <c:otherwise>
                            <b>아직 예매한 공연이 없어요</b>
                            <p>관심 있는 공연을 찾아 첫 티켓을 예매해보세요.</p>
                        </c:otherwise>
                    </c:choose>
                    <a href="/index" class="cta">공연 둘러보기</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="pk-scroll-x">
                    <table class="pk-table ticket-table">
                        <thead>
                            <tr>
                                <th>예매번호</th>
                                <th>티켓명</th>
                                <th>관람일시</th>
                                <th>좌석</th>
                                <th>매수</th>
                                <th>결제금액</th>
                                <c:choose>
                                    <c:when test="${param.tab eq 'canceled'}"><th>취소일시</th></c:when>
                                    <c:otherwise><th>취소가능일</th><th class="col-act"></th></c:otherwise>
                                </c:choose>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tickets}">
                                <tr>
                                    <td class="col-no num">${t.bookedNumber}</td>
                                    <td class="col-title"><a href="/shows/view/${t.showId}">${fn:escapeXml(t.title)}</a></td>
                                    <td class="nowrap num"><fmt:formatDate value="${t.showDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td class="col-seat">${fn:escapeXml(t.seatNames)}</td>
                                    <td class="nowrap num">${t.count}매</td>
                                    <td class="nowrap num"><fmt:formatNumber value="${t.amount}" pattern="#,###" />원</td>
                                    <c:choose>
                                        <c:when test="${param.tab eq 'canceled'}">
                                            <td class="nowrap num"><fmt:formatDate value="${t.canceledDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        </c:when>
                                        <c:otherwise>
                                            <td class="nowrap num"><fmt:formatDate value="${t.cancelableDate}" pattern="yyyy-MM-dd" /></td>
                                            <td class="col-act">
                                                <c:choose>
                                                    <c:when test="${t.cancelable ne 'Y'}">
                                                        <span class="pk-cancel-off">취소기한 종료</span>
                                                    </c:when>
                                                    <c:when test="${t.refundable ne 'Y'}">
                                                        <span class="pk-cancel-off" title="결제 기록이 없어 온라인 취소를 할 수 없습니다.">고객센터 문의</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="pk-btn-cancel"
                                                                data-booked-number="${t.bookedNumber}"
                                                                data-title="${fn:escapeXml(t.title)}"
                                                                data-amount="${t.amount}">예매취소</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<script>
// 기간·관람일시를 고르면 바로 조회
(function () {
    const form = document.querySelector('.pk-filter');
    if (!form) return;
    form.querySelectorAll("input[name='period'], input[name='viewDate']").forEach(function (el) {
        el.addEventListener('change', function () { form.submit(); });
    });
})();

// 예매 취소
(function () {
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('.pk-btn-cancel');
        if (!btn) return;

        const won = Number(btn.dataset.amount || 0).toLocaleString('ko-KR');
        pk.dialog({
            type: 'confirm',
            icon: 'warning',
            danger: true,
            title: '예매를 취소할까요?',
            message: btn.dataset.title + '\n결제하신 ' + won + '원이 전액 환불되며\n좌석은 다시 판매됩니다.',
            okText: '예매 취소하기',
            cancelText: '돌아가기'
        }).then(function (ok) {
            if (!ok) return;
            btn.disabled = true;
            pk.busy(btn, true);
            $.ajax({
                url: '/booking/api/cancel',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ bookedNumber: btn.dataset.bookedNumber }),
                success(res) {
                    com.alert('예매가 취소되었습니다.\n환불은 카드사 정책에 따라 3~5영업일이 소요됩니다.', function () {
                        location.reload();
                    });
                },
                error(xhr) {
                    btn.disabled = false;
                    pk.busy(btn, false);
                    const msg = xhr.responseJSON && xhr.responseJSON.message ? xhr.responseJSON.message : '취소에 실패하였습니다.';
                    com.alert(msg);
                }
            });
        });
    });
})();
</script>
<%@include file="../com/footer.jsp"%>
