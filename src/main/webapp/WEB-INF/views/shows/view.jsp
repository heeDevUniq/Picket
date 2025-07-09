<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/show.js"></script>
공연 상세정보
<form name="showForm" id="showForm">
    <input type="hidden" name="showId" value="${show.showId}">
</form>

<a href="#" onclick="show.book();">예매하기</a>
<a href="#" onclick="show.like();">좋아요</a><span id="likeCount">${likeCount}</span>
<a href="#" onclick="show.setAlarm();">이 공연 티켓팅 알림받기</a>
<a href="#" onclick="show.loadMore();">상세정보 더보기</a>


<br/><br/>-------------<br/><br/>

리뷰..<br/>
<form name="reviewForm" id="reviewForm">
    <input type="hidden" name="showId" value="${show.showId}">
    <input type="text" name="content" placholder="리뷰를 등록하세요."><a href="#" onclick="show.saveReview();">등록</a>
<br/>
    <c:forEach var="review" items="${reviews.content}">
        ${review.content} <c:if test="${review.user.userId eq session.LOGIN_ID}"><a href="#" onclick="show.delReview('${review.reviewId}');">삭제</a></c:if><br/>
    </c:forEach>
</form>
<%@include file="../com/footer.jsp"%>