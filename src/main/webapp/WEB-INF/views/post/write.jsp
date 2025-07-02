<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/post.js"></script>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>
    <main class="main-content">
        공지/예매오픈안내 등록/수정
        <form id="postForm" name="postForm">
            <input type="hidden" name="postId" value="${post.postId}">
            <input type="hidden" name="type" value="${postType}">
            제목 : <input type="text" name="title" value="${post.title}">
            <textarea id="summernote" name="content">${post.content}</textarea>
            <a href="#" onclick="post.save('${postType}');">저장</a>
            <a href="/${postType}">취소</a>
        </form>
    </main>
</div>
<%@include file="../com/footer.jsp"%>