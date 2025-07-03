<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/post.js"></script>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>
    <main class="main-content">
        공지/예매오픈안내 뷰
        <form id="postForm" name="postForm">
            <input type="hidden" name="postId" value="${post.postId}">
            <p>작성일: <fmt:formatDate value="${post.insertDate}" pattern="yyyy-MM-dd" /> 조회수: ${post.hits}</p>
            <h1>${post.title}</h1>
            <p>${post.content}</p>
            <a href="/${post.type}">목록</a>
            <a href="/${post.type}/write/${post.postId}">수정</a>
            <a href="#" onclick="post.delete('${post.type}');">삭제</a>
        </form>
    </main>
</div>
<%@include file="../com/footer.jsp"%>