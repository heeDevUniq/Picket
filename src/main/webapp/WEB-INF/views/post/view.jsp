<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>
    <main class="main-content">
        공지/예매오픈안내 뷰
        <p>작성자: ${post.user.name} / 작성일: <fmt:formatDate value="${post.insertDate}" pattern="yyyy-MM-dd" /></p>
        <h1>${post.title}</h1>
        <p>${post.content}</p>
        <a href="/${post.type}">목록</a>
        <a href="/${post.type}/write/${post.postId}">수정</a>
        <form method="post" action="/posts/${post.postId}/delete">
            <button type="submit">삭제</button>
        </form>
    </main>
</div>
<%@include file="../com/footer.jsp"%>