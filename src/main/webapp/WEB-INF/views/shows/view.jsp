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
<div class="datacheck">
날짜선택<br/>
<c:forEach var="date" items="${showDates}" varStatus="i">
    <input type="radio" name="showDateId" id="showDateId_${i.index}" value="${date.showDateId}">
    <label for="showDateId_${i.index}">
        <fmt:formatDate value="${date.showDate}" pattern="yyyy-MM-dd HH:mm"/><br>
    </label>
</c:forEach>
</div>
</div>
</div>
<div class="btn_more">
<div>
<a href="#" onclick="show.like();">좋아요</a><span id="likeCount">${likeCount}</span>
<a href="#" onclick="show.setAlarm();">이 공연 티켓팅 알림받기</a>
</div>
<a href="#" onclick="show.book('${show.showId}');" class="main_btn mr75">예매하기</a>
</div>
</div>

</div>
</section>
<section class="main-content">
<a href="#" onclick="show.loadMore();">상세정보 더보기</a>

<br/><br/>-------------<br/><br/>


리뷰..<br/>
<form name="reviewForm" id="reviewForm">
    <input type="hidden" name="showId" value="${show.showId}">
    <input type="text" name="content" placholder="리뷰를 등록하세요." onkeydown="if(event.key === 'Enter'){ show.saveReview(); }"><a href="#" onclick="show.saveReview();">등록</a>
<br/>
    <c:forEach var="review" items="${reviews.content}">
        ${review.content} <c:if test="${review.user.userId eq session.LOGIN_ID}"><a href="#" onclick="show.delReview('${review.reviewId}');">삭제</a></c:if><br/>
    </c:forEach>
</form>
</div>
</section>
<%@include file="../com/footer.jsp"%>