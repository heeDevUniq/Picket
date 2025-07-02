<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>
    <main class="main-content">
        <h1>${postType eq 'notice'?'공지사항':'예매오픈안내'}</h1>
        <a href="/${postType}/write/0">글쓰기</a>
        <table border="1">
            <tr><th>번호</th><th>제목</th><th>작성일</th><th>조회수</th></tr>
            <c:choose>
                <c:when test="${fn:length(posts.content) > 0}">
                    <c:forEach var="post" items="${posts.content}" varStatus="status">
                        <tr>
                            <td>${fn:length(posts.content) - status.index}</td>
                            <td><a href="/${postType}/view/${post.postId}">${post.title}</a></td>
                            <td><fmt:formatDate value="${post.insertDate}" pattern="yyyy-MM-dd" /></td>
                            <td>${post.hits}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr colspan="4">
                        <td>작성된 글이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>
        <!-- 페이지네이션 -->
        <div>
            <c:forEach begin="0" end="${posts.totalPages > 0 ? posts.totalPages - 1 : 0}" var="i">
                <a href="?page=${i}&size=${posts.size}&postType=${postType}">
                    [${i + 1}]
                </a>
            </c:forEach>
        </div>
    </main>
</div>
<%@include file="../com/footer.jsp"%>