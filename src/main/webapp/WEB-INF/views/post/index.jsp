<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
	<main class="main-content">
		<h2 class="pk-page-title">${postType eq 'notice' ? '공지사항' : '예매오픈안내'}</h2>

		<div class="pk-list-meta">
			<span>전체 <b>${posts.totalCount}</b>건 · ${posts.page}/${posts.totalPages} 페이지</span>
			<a href="/${postType}/write/0" class="pk-btn-sm">글쓰기</a>
		</div>

		<c:choose>
			<c:when test="${posts.noData}">
				<div class="pk-empty">
					<b>아직 등록된 글이 없습니다.</b>
					첫 번째 글을 남겨보세요.
				</div>
			</c:when>
			<c:otherwise>
				<div class="pk-scroll-x">
					<table class="reservation-table">
						<thead>
							<tr>
								<th style="width:80px">번호</th>
								<th>제목</th>
								<th style="width:120px">작성일</th>
								<th style="width:90px">조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="post" items="${posts.list}" varStatus="status">
								<tr>
									<td>${posts.startNo - status.index}</td>
									<td class="pk-td-title"><a href="/${postType}/view/${post.postId}"><c:out value="${post.title}" /></a></td>
									<td><fmt:formatDate value="${post.insertDate}" pattern="yyyy-MM-dd" /></td>
									<td>${post.hits}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<c:set var="pg" value="${posts}" />
				<c:set var="pgBase" value="/${postType}" />
				<%@ include file="/WEB-INF/views/com/paging.jsp" %>
			</c:otherwise>
		</c:choose>
	</main>
</div>
<style>
.pk-page-title { margin: 16px 0 8px; }
.pk-btn-sm {
	display: inline-block; padding: 8px 16px; border-radius: 9px;
	background: #2875FF; color: #fff; font-size: 13px; font-weight: 600;
}
.reservation-table { margin-top: 0; }
.reservation-table thead { height: 42px; }
.reservation-table tbody > tr { height: 46px; }
.reservation-table th, .reservation-table td { padding: 6px 14px; }
.reservation-table td { font-size: 13.5px; }
.pk-td-title { text-align: left; }
.pk-td-title a { display: block; }
.pk-td-title a:hover { color: #1B4FD8; text-decoration: underline; }
@media (max-width: 768px) {
	.pk-page-title { margin-top: 0; }
}
</style>
<%@include file="../com/footer.jsp"%>