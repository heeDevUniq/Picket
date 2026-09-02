<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<style>
/* mytickets-space */
.pk-page-title { margin: 0 0 4px; }
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
                    <table>
                        <thead>
                            <tr>
                                <th>예매번호</th>
                                <th>티켓명</th>
                                <th>관람일시</th>
                                <th>좌석</th>
                                <th>매수</th>
                                <th>결제금액</th>
                                <th>취소가능일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tickets}">
                                <tr>
                                    <td>${t.bookedNumber}</td>
                                    <td><a href="/shows/view/${t.showId}">${t.title}</a></td>
                                    <td><fmt:formatDate value="${t.showDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td>${t.seatNames}</td>
                                    <td>${t.count}매</td>
                                    <td><fmt:formatNumber value="${t.amount}" pattern="#,###" />원</td>
                                    <td><fmt:formatDate value="${t.cancelableDate}" pattern="yyyy-MM-dd" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<%@include file="../com/footer.jsp"%>
