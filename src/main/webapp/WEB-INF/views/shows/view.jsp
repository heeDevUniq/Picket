<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/show.js"></script>
공연 상세정보
<form id="showForm" id="showForm">
    <input type="hidden" name="showId" value="${show.showId}">
</form>

<a href="#" onclick="show.book();">예매하기</a>
<a href="#" onclick="show.like();">좋아요</a><span id="likeCount">${likeCount}</span>
<a href="#" onclick="show.setAlarm();">이 공연 티켓팅 알림받기</a>
<a href="#" onclick="show.loadMore();">상세정보 더보기</a>
<%@include file="../com/footer.jsp"%>