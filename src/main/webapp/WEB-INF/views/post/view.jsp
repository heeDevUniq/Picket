<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
공지/예매오픈안내 뷰
<p>작성자: ${posts.user.name} / 작성일: <fmt:formatDate value="${posts.insertDate}" pattern="yyyy-MM-dd" /></p>
<h1>${posts.title}</h1>
<p>${posts.content}</p>

<a href="/{boardType}/write/{postId}">수정</a>
<form method="post" action="/posts/${post.id}/delete">
    <button type="submit">삭제</button>
</form>
<a href="/posts">목록</a>
<%@include file="../com/footer.jsp"%>