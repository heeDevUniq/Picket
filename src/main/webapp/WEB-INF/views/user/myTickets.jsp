<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <div class="qicon">
            <a href="/myTickets">
                <div class="myticket icons">
                    <img src="images/myticket.svg" alt="ticket_icon">
                    <div class="min_text">
                        <p>나의 예매권</p>
                        <p style="color:#2875FF;">3</p>
                    </div>
                </div>
            </a>
            <a href="/myLikes">
                <div class="love icons">
                    <img src="images/love.svg" alt="ticket_icon">
                    <div class="min_text">
                        <p>관심 공연</p>
                        <p style="color:#2875FF;">${myLikeCount}</p>
                    </div>
                </div>
            </a>
            <a href="/myAlarms">
                <div class="alarm icons">
                    <img src="images/alarm.svg" alt="ticket_icon">
                    <div class="min_text">
                        <p>알림</p>
                        <p style="color:#2875FF;">${myAlarmCount}</p>
                    </div>
                </div>
            </a>
        </div>

        <h3>예매 / 취소내역 </h3>
        <div class="tabs">
            <button class="tab_btn active">예매내역</button>
            <button class="tab_btn">취소내역</button>
        </div>

        <form method="get" action="/myTickets" class="filter-form">
            <div class="filters">
                <span>기간별 조회</span>
                <div class="radio-buttons">
                    <input type="radio" name="period" id="p1" value="1" checked><label for="p1">1개월</label>
                    <input type="radio" name="period" id="p3" value="3"><label for="p3">3개월</label>
                    <input type="radio" name="period" id="p6" value="6"><label for="p6">6개월</label>
                </div>
                <span>관람일시</span>
                <input type="date" name="viewDate">
                <span>티켓명</span>
                <input type="text" name="ticketName" placeholder="티켓명">
                <button type="submit" class="main_btn min_btn">조회</button>
            </div>
        </form>

        <c:choose>
            <c:when test="${empty tickets}">
                <div class="pk-empty">
                    <span class="pk-empty-ico">🎟️</span>
                    <b>아직 예매한 공연이 없어요</b>
                    관심 있는 공연을 찾아 첫 티켓을 예매해보세요.
                    <div style="margin-top:16px">
                        <a href="/index" class="pk-btn-sm">공연 둘러보기</a>
                    </div>
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
                                <th>매수</th>
                                <th>취소가능일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tickets}">
                                <tr>
                                    <td>${t.bookedNumber}</td>
                                    <td>${t.title}</td>
                                    <td><fmt:formatDate value="${t.showDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td>${t.count}</td>
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
<style>
.pk-empty-ico { font-size: 30px; display: block; }
.pk-btn-sm {
    display: inline-block; padding: 9px 18px; border-radius: 9px;
    background: #2875FF; color: #fff; font-size: 13px; font-weight: 600;
}
.filters { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin: 16px 0; }
.filters .main_btn { width: auto; padding: 0 18px; }
.radio-buttons { display: inline-flex; gap: 4px; }
.radio-buttons input[type="radio"] { position: absolute; opacity: 0; width: 0; height: 0; }
.radio-buttons label {
    padding: 7px 13px; border: 1px solid #E7E9EE; border-radius: 999px;
    font-size: 13px; cursor: pointer; transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.radio-buttons label:hover { border-color: #2875FF; }
.radio-buttons input[type="radio"]:checked + label {
    background: rgba(40,117,255,.1); border-color: #2875FF; color: #1B4FD8; font-weight: 700;
}
.radio-buttons input[type="radio"]:focus-visible + label { outline: 2px solid #2875FF; outline-offset: 2px; }
</style>
<%@include file="../com/footer.jsp"%>