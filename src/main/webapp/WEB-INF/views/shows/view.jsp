<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/show.js"></script>
<style>
.viewimg { width: 320px; max-width: 320px; flex: 0 0 320px; }
.viewpost { gap: 40px; align-items: flex-start; padding: 24px 0; }
.tab-panel { padding: 24px 0; }
.show-detail { font-size: 15px; line-height: 1.7; color: #333; white-space: pre-line; }
.show-meta {
    display: grid;
    grid-template-columns: 120px 1fr;
    row-gap: 12px;
    margin-top: 28px;
    padding-top: 22px;
    border-top: 1px solid #E7E9EE;
    font-size: 14px;
}
.show-meta dt { color: #6B7280; }
.show-meta dd { color: #14161A; }
.tabs2 > a > span {
    display: inline-block;
    min-width: 20px;
    padding: 1px 7px;
    margin-left: 4px;
    border-radius: 999px;
    background: #F1F3F6;
    color: #6B7280;
    font-size: 12px;
    font-weight: 700;
}
.tabs2 > a.active > span { background: rgba(40,117,255,.12); color: #1B4FD8; }
.datacheck { display: flex; flex-wrap: wrap; gap: 8px; line-height: 1.4; margin: 8px 0 16px; }
.datacheck input[type="radio"] { position: absolute; opacity: 0; width: 0; height: 0; }
.datacheck label {
    display: inline-block;
    padding: 9px 14px;
    border: 1px solid #E7E9EE;
    border-radius: 10px;
    font-size: 13px;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.datacheck label:hover { border-color: #2875FF; transform: translateY(-2px); }
.datacheck input[type="radio"]:checked + label {
    border-color: #2875FF;
    background: rgba(40,117,255,.1);
    color: #1B4FD8;
    font-weight: 700;
}
.datacheck input[type="radio"]:focus-visible + label { outline: 2px solid #2875FF; outline-offset: 2px; }
</style>

<section>
<form name="showForm" id="showForm">
    <input type="hidden" name="showId" value="${show.showId}">
</form>

<div class="container">
    <div class="main-content">
    <h2 class="viewtitle">${show.title}</h2>
<div class="viewpost">
<div class="viewimg pk-poster">
<img src="${show.posterLink}" alt="${show.title} 포스터" data-show-id="${show.showId}">
</div>
<div class="viewtext">
<span>이름</span>${show.title}<br/>
<span>장소</span>${show.place}<br/>
<span>공연일자</span><fmt:formatDate value="${show.startDate}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${show.endDate}" pattern="yyyy-MM-dd"/><br/>
<span>관람가</span>${show.ageLimit}<br/>
<span>오픈일</span><fmt:formatDate value="${show.openDate}" pattern="yyyy-MM-dd HH:mm"/><br/>
<span>날짜선택</span>
<div class="datacheck">
<c:forEach var="date" items="${showDates}" varStatus="i">
    <input type="radio" name="showDateId" id="showDateId_${i.index}" value="${date.showDateId}">
    <label for="showDateId_${i.index}">
        <fmt:formatDate value="${date.showDate}" pattern="yyyy-MM-dd HH:mm"/><br>
    </label>
</c:forEach>
</div>
 <a href="#" onclick="show.book(); return false;" class="main_btn mr75">예매하기</a>
</div>
</div>

<div class="btn_more">
  <div class="btn_group">
    <a href="#" onclick="show.like(); return false;" class="like-btn" aria-label="좋아요"
       aria-pressed="${likeMyCount > 0}">
        <c:choose>
            <c:when test="${likeMyCount > 0}"><c:set var="likeImg" value="/images/fill_like.svg" /></c:when>
            <c:otherwise><c:set var="likeImg" value="/images/like.svg" /></c:otherwise>
        </c:choose>
        <img src="${likeImg}" alt="like" id="like-btn">
        <span class="like-count" id="likeCount">${likeCount}</span>
    </a>
    <a href="#" onclick="show.setAlarm(); return false;" class="btn_alarm_custom" aria-label="티켓팅 알림받기"
       aria-pressed="${alarmMyCount > 0}">
        <c:choose>
            <c:when test="${alarmMyCount > 0}"><c:set var="alarmImg" value="/images/fill_bell.svg" /></c:when>
            <c:otherwise><c:set var="alarmImg" value="/images/alarm2.svg" /></c:otherwise>
        </c:choose>
        <img src="${alarmImg}" alt="alarm" id="alarm-btn">티켓팅 알림
    </a>
  </div>

</div>

</div>
</section>
<section class="main-content">
<div class="tabs2" id="showTabs">
<a href="#" data-tab="info" class="active">공연정보</a>
<a href="#" data-tab="review">리뷰 <span id="reviewCount">${fn:length(reviews)}</span></a>
</div>

<div id="tab-info" class="tab-panel">
    <div class="show-detail">${show.info}</div>
    <dl class="show-meta">
        <dt>장소</dt><dd>${show.place}</dd>
        <dt>주최/주관</dt><dd>${empty show.host ? '-' : show.host}</dd>
        <dt>문의</dt><dd>${empty show.contact ? '-' : show.contact}</dd>
        <dt>관람연령</dt><dd>${empty show.ageLimit ? '전체 관람가' : show.ageLimit}</dd>
    </dl>
</div>
<div id="tab-review" class="tab-panel" hidden>
<form name="reviewForm" id="reviewForm">
    <input type="hidden" name="showId" value="${show.showId}">
    <div class="review-input-box">
        <div class="nickname"></div>
        <input type="text" name="content" placeholder="리뷰를 등록하세요." onkeydown="if(event.key === 'Enter'){ show.saveReview(); return false; }" class="review-text-input">
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
            <div class="pk-empty"><b>아직 등록된 리뷰가 없습니다.</b>첫 번째 리뷰를 남겨보세요.</div>
        </c:if>
    </div>
</form>
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
</div>
</section>
<%@include file="../com/footer.jsp"%>