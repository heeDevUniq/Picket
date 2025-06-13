<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<h1>${postType eq 'notice'?'공지사항':'예매오픈안내'}</h1>
<a href="/${postType}/write">글쓰기</a>${posts}
<table border="1">
    <tr><th>번호</th><th>제목</th><th>작성일</th><th>조회수</th></tr>
    <c:forEach var="post" items="${posts.content}">
        <tr>
            <td>${post.postId}</td>
            <td><a href="/${postType}/view/${post.postId}">${post.title}</a></td>
            <td><fmt:formatDate value="${post.insertDate}" pattern="yyyy-MM-dd" /></td>
            <td>${post.hits}</td>
        </tr>
    </c:forEach>
</table>
<!-- 페이지네이션 -->
<div>
    <c:forEach begin="0" end="${posts.totalPages - 1}" var="i">
        <a href="?page=${i}&size=${posts.size}&postType=${postType}">
            [${i + 1}]
        </a>
    </c:forEach>
</div>
<%@include file="../com/footer.jsp"%>