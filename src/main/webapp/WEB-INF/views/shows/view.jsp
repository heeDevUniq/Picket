<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/show.js"></script>
<style>
.container > .main-content { max-width: 1100px; }
.sv { max-width: 1100px; margin: 0 auto; padding: 0 0 80px; }

/* 상단 */
.sv-kicker {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 24px 0 10px;
    font-size: 13px;
    color: #868EA0;
}
.sv-genre {
    padding: 4px 11px;
    border-radius: 999px;
    background: #F1F3F6;
    color: #5A6272;
    font-size: 12px;
    font-weight: 600;
}
.sv-title {
    font-size: 34px;
    font-weight: 800;
    letter-spacing: -.035em;
    line-height: 1.25;
    margin-bottom: 30px;
}

/* 본문 2단 */
.sv-top {
    display: grid;
    grid-template-columns: 340px 1fr;
    gap: 56px;
    align-items: start;
}

.sv-poster {
    width: 100%;
    aspect-ratio: 3 / 4;
    border-radius: 16px;
    overflow: hidden;
    background: #F6F7F9;
}
.sv-poster img { width: 100%; height: 100%; object-fit: cover; display: block; }
.sv-poster--empty {
    border: 1.5px dashed #D5D9E0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 10px;
    color: #A8AEBA;
    font-size: 13.5px;
}
.sv-poster--empty svg { opacity: .55; }

/* 정보 테이블 */
.sv-facts { border-top: 1px solid #ECEEF2; }
.sv-fact {
    display: grid;
    grid-template-columns: 130px 1fr;
    align-items: baseline;
    gap: 16px;
    padding: 18px 4px;
    border-bottom: 1px solid #ECEEF2;
    font-size: 15px;
}
.sv-fact dt { color: #868EA0; }
.sv-fact dd { margin: 0; color: #14161A; font-weight: 600; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.sv-fact .num { font-family: var(--pk-font-mono); font-weight: 600; letter-spacing: -.01em; }

.sv-chip {
    padding: 3px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
}
.sv-chip--soon { background: #E7F6EE; color: #0E7A4F; }
.sv-chip--open { background: #EDF3FF; color: #1B4FD8; }
.sv-chip--done { background: #F1F3F6; color: #868EA0; }

/* 날짜 선택 */
.sv-datehead {
    margin: 30px 0 12px;
    font-size: 15px;
    font-weight: 700;
    letter-spacing: -.01em;
}
.sv-dates { display: flex; flex-wrap: wrap; gap: 10px; }
.sv-dates input[type="radio"] { position: absolute; opacity: 0; width: 0; height: 0; }
.sv-dates label {
    display: block;
    min-width: 132px;
    padding: 13px 18px;
    border: 1px solid #E4E7EC;
    border-radius: 12px;
    cursor: pointer;
    transition: border-color .16s cubic-bezier(.2,.8,.2,1), background .16s cubic-bezier(.2,.8,.2,1);
}
.sv-dates label b {
    display: block;
    font-family: var(--pk-font-mono);
    font-size: 15px;
    font-weight: 600;
    color: #14161A;
    letter-spacing: -.01em;
}
.sv-dates label small {
    display: block;
    margin-top: 2px;
    font-family: var(--pk-font-mono);
    font-size: 13px;
    color: #868EA0;
}
.sv-dates label:hover { border-color: #C7CDD6; }
.sv-dates input:checked + label { border-color: var(--pk-accent); background: var(--pk-accent-soft); }
.sv-dates input:checked + label b { color: var(--pk-accent-dark); }
.sv-dates input:checked + label small { color: var(--pk-accent-dark); opacity: .75; }
.sv-dates input:focus-visible + label { outline: 2px solid var(--pk-accent); outline-offset: 2px; }

/* 액션 */
.sv-book {
    display: block;
    width: 100%;
    margin: 26px 0 12px;
    padding: 20px;
    border: 0;
    border-radius: 12px;
    background: var(--pk-accent);
    color: #fff;
    font-family: var(--pk-font-ui);
    font-size: 16px;
    font-weight: 700;
    text-align: center;
    cursor: pointer;
    transition: background .16s cubic-bezier(.2,.8,.2,1);
}
.sv-book:hover { background: var(--pk-accent-dark); }

.sv-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.sv-action {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    padding: 15px;
    border: 1px solid #E4E7EC;
    border-radius: 12px;
    background: #fff;
    color: #33383F;
    font-family: var(--pk-font-ui);
    font-size: 14.5px;
    font-weight: 600;
    cursor: pointer;
    transition: border-color .16s cubic-bezier(.2,.8,.2,1);
}
.sv-action:hover { border-color: #C7CDD6; }
.sv-action img { width: 18px; height: 18px; }
.sv-action .like-count { font-family: var(--pk-font-mono); font-weight: 600; }

.sv-note { margin-top: 18px; font-size: 13px; color: #A0A6B2; line-height: 1.7; }

/* 탭 */
.sv-tabs {
    display: flex;
    gap: 26px;
    margin: 64px 0 0;
    border-bottom: 1px solid #ECEEF2;
}
.sv-tabs a {
    display: flex;
    align-items: center;
    gap: 7px;
    padding: 14px 2px;
    margin-bottom: -1px;
    border-bottom: 2px solid transparent;
    font-family: var(--pk-font-ui);
    font-size: 16px;
    font-weight: 600;
    color: #A0A6B2;
}
.sv-tabs a.active { color: #14161A; border-bottom-color: #14161A; }
.sv-tabs a span {
    min-width: 20px;
    padding: 1px 7px;
    border-radius: 999px;
    background: #F1F3F6;
    color: #868EA0;
    font-family: var(--pk-font-mono);
    font-size: 12px;
    font-weight: 600;
    text-align: center;
}
.sv-tabs a.active span { background: #EDF3FF; color: #1B4FD8; }

/* 공연정보 패널 */
.sv-panel { padding: 40px 0 0; }
.sv-info { display: grid; grid-template-columns: 1fr 340px; gap: 56px; align-items: start; }
.sv-desc { font-size: 15.5px; line-height: 1.9; color: #33383F; overflow-wrap: anywhere; }
.sv-desc p { margin: 0 0 1.1em; }
.sv-desc ul { margin: 0; padding-left: 1.1em; }
.sv-desc li { list-style: disc; margin-bottom: .4em; }

.sv-side {
    padding: 26px 24px;
    border-radius: 14px;
    background: #F7F8FA;
}
.sv-side dl { margin: 0; }
.sv-side dt {
    font-size: 12.5px;
    color: #909AA8;
    margin-bottom: 4px;
}
.sv-side dd {
    margin: 0 0 20px;
    font-size: 15px;
    font-weight: 600;
    color: #14161A;
    line-height: 1.5;
}
.sv-side dd:last-child { margin-bottom: 0; }

/* 리뷰 */
.sv-panel .review-input-box { margin-top: 0; }

@media (max-width: 900px) {
    .sv-top { grid-template-columns: 1fr; gap: 28px; }
    .sv-poster { max-width: 280px; margin: 0 auto; }
    .sv-info { grid-template-columns: 1fr; gap: 28px; }
    .sv-title { font-size: 24px; margin-bottom: 22px; }
    .sv-fact { grid-template-columns: 96px 1fr; padding: 15px 2px; font-size: 14px; }
    .sv-tabs { margin-top: 44px; }
    .sv-panel { padding-top: 28px; }
    .sv-dates label { min-width: 0; flex: 1; }
}
</style>

<div class="container">
    <main class="main-content">
        <article class="sv">
            <form name="showForm" id="showForm">
                <input type="hidden" name="showId" value="${show.showId}">
            </form>

            <c:set var="isOpen" value="${empty show.openDate or show.openDate.time le nowMillis}" />

            <div class="sv-kicker">
                <span class="sv-genre">
                    <c:choose>
                        <c:when test="${show.genre eq 'musical'}">뮤지컬·연극</c:when>
                        <c:when test="${show.genre eq 'concert'}">콘서트</c:when>
                        <c:when test="${show.genre eq 'classic'}">클래식·무용</c:when>
                        <c:when test="${show.genre eq 'exhibit'}">전시·행사</c:when>
                        <c:when test="${show.genre eq 'festival'}">페스티벌</c:when>
                        <c:otherwise>공연</c:otherwise>
                    </c:choose>
                </span>
                <span>${show.place}</span>
            </div>

            <h1 class="sv-title">${show.title}</h1>

            <div class="sv-top">
                <c:choose>
                    <c:when test="${not empty show.posterLink}">
                        <div class="sv-poster">
                            <img src="${show.posterLink}" alt="${show.title} 포스터" data-show-id="${show.showId}">
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="sv-poster sv-poster--empty">
                            <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <rect x="3" y="3" width="18" height="18" rx="2"/>
                                <circle cx="8.5" cy="8.5" r="1.5"/>
                                <path d="M21 15l-5-5L5 21"/>
                            </svg>
                            포스터 준비 중입니다
                        </div>
                    </c:otherwise>
                </c:choose>

                <div>
                    <dl class="sv-facts">
                        <div class="sv-fact"><dt>장소</dt><dd>${show.place}</dd></div>
                        <div class="sv-fact">
                            <dt>공연 일자</dt>
                            <dd class="num">
                                <fmt:formatDate value="${show.startDate}" pattern="yyyy.MM.dd" /> ~
                                <fmt:formatDate value="${show.endDate}" pattern="yyyy.MM.dd" />
                            </dd>
                        </div>
                        <div class="sv-fact">
                            <dt>관람가</dt>
                            <dd>${empty show.ageLimit ? '전체 관람가' : show.ageLimit}</dd>
                        </div>
                        <div class="sv-fact">
                            <dt>티켓 오픈</dt>
                            <dd>
                                <span class="num"><fmt:formatDate value="${show.openDate}" pattern="yyyy.MM.dd HH:mm" /></span>
                                <c:choose>
                                    <c:when test="${not isOpen}"><span class="sv-chip sv-chip--soon">오픈 예정</span></c:when>
                                    <c:when test="${show.remainCount eq 0}"><span class="sv-chip sv-chip--done">매진</span></c:when>
                                    <c:otherwise><span class="sv-chip sv-chip--open">예매중</span></c:otherwise>
                                </c:choose>
                            </dd>
                        </div>
                    </dl>

                    <h2 class="sv-datehead">날짜 선택</h2>
                    <div class="sv-dates">
                        <c:forEach var="date" items="${showDates}" varStatus="i">
                            <input type="radio" name="showDateId" id="showDateId_${i.index}" value="${date.showDateId}"
                                   <c:if test="${i.first}">checked</c:if>>
                            <label for="showDateId_${i.index}">
                                <b><fmt:formatDate value="${date.showDate}" pattern="yyyy.MM.dd" /></b>
                                <small><fmt:formatDate value="${date.showDate}" pattern="HH:mm" /></small>
                            </label>
                        </c:forEach>
                        <c:if test="${empty showDates}">
                            <span class="sv-note">등록된 회차가 없습니다.</span>
                        </c:if>
                    </div>

                    <button type="button" class="sv-book" onclick="show.book();">예매하기</button>

                    <div class="sv-actions">
                        <button type="button" class="sv-action" onclick="show.like();"
                                aria-pressed="${likeMyCount > 0}" aria-label="관심 공연">
                            <c:choose>
                                <c:when test="${likeMyCount > 0}"><c:set var="likeImg" value="/images/fill_like.svg" /></c:when>
                                <c:otherwise><c:set var="likeImg" value="/images/like.svg" /></c:otherwise>
                            </c:choose>
                            <img src="${likeImg}" alt="" id="like-btn">
                            관심 <span class="like-count" id="likeCount">${likeCount}</span>
                        </button>
                        <button type="button" class="sv-action" onclick="show.setAlarm();"
                                aria-pressed="${alarmMyCount > 0}" aria-label="티켓팅 알림">
                            <c:choose>
                                <c:when test="${alarmMyCount > 0}"><c:set var="alarmImg" value="/images/fill_bell.svg" /></c:when>
                                <c:otherwise><c:set var="alarmImg" value="/images/alarm2.svg" /></c:otherwise>
                            </c:choose>
                            <img src="${alarmImg}" alt="" id="alarm-btn">
                            티켓팅 알림
                        </button>
                    </div>

                    <p class="sv-note">예매는 티켓 오픈 시각부터 가능하며, 1인당 최대 4매까지 구매할 수 있습니다.</p>
                </div>
            </div>

            <nav class="sv-tabs" id="showTabs">
                <a href="#" data-tab="info" class="active">공연 정보</a>
                <a href="#" data-tab="review">리뷰 <span id="reviewCount">${fn:length(reviews)}</span></a>
            </nav>

            <div id="tab-info" class="sv-panel">
                <div class="sv-info">
                    <div class="sv-desc">${show.info}</div>
                    <aside class="sv-side">
                        <dl>
                            <dt>장소</dt><dd>${show.place}</dd>
                            <dt>주최·주관</dt><dd>${empty show.host ? '-' : show.host}</dd>
                            <dt>문의</dt><dd>${empty show.contact ? '-' : show.contact}</dd>
                            <dt>관람 연령</dt><dd>${empty show.ageLimit ? '전체 관람가' : show.ageLimit}</dd>
                        </dl>
                    </aside>
                </div>
            </div>

            <div id="tab-review" class="sv-panel" hidden>
                <form name="reviewForm" id="reviewForm">
                    <input type="hidden" name="showId" value="${show.showId}">
                    <div class="review-input-box">
                        <input type="text" name="content" placeholder="리뷰를 등록하세요."
                               onkeydown="if(event.key === 'Enter'){ show.saveReview(); return false; }" class="review-text-input">
                        <a href="#" onclick="show.saveReview(); return false;" class="btn-submit">글쓰기</a>
                    </div>

                    <div id="reviewList" data-user-name="${sessionScope.LOGIN_NAME}">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item" data-review-id="${review.reviewId}">
                                <div class="nickname">${review.userName}</div>
                                <div class="text"><c:out value="${review.content}" /></div>
                                <c:if test="${sessionScope.LOGIN_ID != null && review.insertId eq sessionScope.LOGIN_ID}">
                                    <a href="#" onclick="show.delReview('${review.reviewId}'); return false;" class="btn-delete"
                                       aria-label="리뷰 삭제">×</a>
                                </c:if>
                            </div>
                        </c:forEach>
                        <c:if test="${empty reviews}">
                            <div class="pk-empty"><b>아직 등록된 리뷰가 없습니다</b>첫 번째 리뷰를 남겨보세요.</div>
                        </c:if>
                    </div>
                </form>
            </div>
        </article>
    </main>
</div>

<script>
// 탭 전환
(function () {
    const tabs = document.getElementById('showTabs');
    if (!tabs) return;
    tabs.addEventListener('click', function (e) {
        const link = e.target.closest('a[data-tab]');
        if (!link) return;
        e.preventDefault();
        tabs.querySelectorAll('a').forEach(function (a) { a.classList.remove('active'); });
        link.classList.add('active');
        document.getElementById('tab-info').hidden = link.dataset.tab !== 'info';
        document.getElementById('tab-review').hidden = link.dataset.tab !== 'review';
    });
})();
</script>
<%@include file="../com/footer.jsp"%>
