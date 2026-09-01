<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/post.js"></script>
<div class="container">
	<main class="main-content">
		<h2>${postType eq 'notice'?'공지사항':'예매오픈안내'} ${post eq null?'등록':'수정'}</h2>
		<form class="write-form" name="postForm" id="postForm">
			<input type="hidden" name="postId" value="${post.postId}"> <input type="hidden" name="postType" value="${postType}">

			<div class="form-group">
				<label for="title">제목</label> <input type="text" id="title" name="title" placeholder="제목을 입력하세요." value="${post.title}">
			</div>

			<div class="form-group">
				<label for="content">내용</label>
				<textarea id="summernote" name="content" placeholder="내용을 입력하세요.">${post.content}</textarea>
			</div>

			<div class="form-btns">
				<a href="/${postType}" class="btn-cancel">취소</a>
				<a onclick="post.save('${postType}');" class="btn-submit">등록</a>
			</div>
		</form>
	</main>
</div>
<%@include file="../com/footer.jsp"%>