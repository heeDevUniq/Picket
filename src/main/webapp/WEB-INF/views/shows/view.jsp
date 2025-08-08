<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/show.js"></script>

<section>
<form name="showForm" id="showForm">
    <input type="hidden" name="showId" value="${show.showId}">
</form>

<div class="container">
    <div class="main-content">
    <h2 class="viewtitle">${show.title}:${show.info}</h2>
<div class="viewpost">
<div class="viewimg">
<img src="${show.posterLink}" alt="공연 포스터">
</div>
<div class="viewtext">
<span>이름</span>${show.title}<br/>
<span>장소</span>${show.place}<br/>
<span>공연일자</span>${show.startDate} ~ ${show.endDate}<br/>
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
 <a href="#" onclick="show.book('${show.showId}');" class="main_btn mr75">예매하기</a>
</div>
</div>

<div class="btn_more">
  <div class="btn_group">
    <a href="#" onclick="show.like();" class="like-btn" aria-label="좋아요">
        <c:choose>
            <c:when test="${likeMyCount > 0}"><c:set var="likeImg" value="/images/fill_like.svg" /></c:when>
            <c:otherwise><c:set var="likeImg" value="/images/like.svg" /></c:otherwise>
        </c:choose>
        <img src="${likeImg}" alt="like" id="like-btn">
        <span class="like-count" id="likeCount">${likeCount}</span>
    </a>
    <a href="#" onclick="show.setAlarm();" class="btn_alarm_custom" aria-label="알림받기">
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
<div class="tabs2">
<a href="#" onclick="show.loadMore();" >공연정보</a>
<a href="" onclick="" class="active">리뷰</a>
</div>
<form name="reviewForm" id="reviewForm">
    <input type="hidden" name="showId" value="${show.showId}">
    <div class="review-input-box">
        <div class="nickname"></div>
        <input type="text" name="content" placeholder="리뷰를 등록하세요." onkeydown="if(event.key === 'Enter'){ show.saveReview(); return false; }" class="review-text-input">
        <a href="#" onclick="show.saveReview();" class="btn-submit">글쓰기</a>
    </div>

    <c:forEach var="review" items="${reviews.content}">
        <div class="review-item">
            <div class="text">${review.content}</div>
            <c:if test="${review.user.userId eq session.LOGIN_ID && session.LOGIN_ID != null}">
                <a href="#" onclick="show.delReview('${review.reviewId}');" class="btn-delete">×</a>
            </c:if>
        </div>
    </c:forEach>
</form>
</div>
</section>
<%@include file="../com/footer.jsp"%>