<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<style>
/* 목록 머리 */
.bd-head {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    gap: 20px;
    flex-wrap: wrap;
    margin: 16px 0 16px;
}
.bd-head h2 {
    margin: 0 0 4px;
    font-family: var(--pk-font-ui);
    font-size: 28px;
    font-weight: 600;
    letter-spacing: -.03em;
}
.bd-count { font-size: 13.5px; color: var(--pk-muted); }
.bd-count b { font-weight: 600; color: #33383F; }
.bd-tools { display: flex; align-items: center; gap: 10px; }

/* 검색 */
.bd-search {
    display: flex;
    align-items: center;
    gap: 9px;
    width: 260px;
    height: 38px;
    padding: 0 14px;
    border: 1px solid var(--pk-line);
    border-radius: 10px;
    background: var(--pk-surface);
    transition: border-color .16s cubic-bezier(.2,.8,.2,1);
}
.bd-search:focus-within { border-color: var(--pk-accent); }
.bd-search svg { width: 16px; height: 16px; flex: none; color: #A0A6B2; }
.bd-search input {
    flex: 1;
    min-width: 0;
    height: 100%;
    border: 0;
    outline: none;
    background: none;
    font-size: 13.5px;
    color: var(--pk-ink);
}
.bd-search input::placeholder { font-size: 13.5px; color: #A0A6B2; }

.bd-write {
    display: inline-flex;
    align-items: center;
    height: 38px;
    padding: 0 16px;
    border-radius: 10px;
    background: var(--pk-accent);
    color: #fff;
    font-family: var(--pk-font-ui);
    font-size: 14px;
    font-weight: 600;
    white-space: nowrap;
}
.bd-write:hover { background: var(--pk-accent-dark); color: #fff; }

/* 표 */
.bd-table { width: 100%; border-collapse: collapse; margin: 0; font-size: 14px; }
.bd-table thead { height: auto; }
.bd-table thead::before { content: none; }
.bd-table th {
    padding: 0 14px 11px;
    border-bottom: 1.5px solid var(--pk-ink);
    font-family: var(--pk-font-ui);
    font-size: 13px;
    font-weight: 500;
    color: #5A6272;
    text-align: center;
    white-space: nowrap;
}
.bd-table th.t { text-align: left; }
.bd-table tbody > tr { height: auto; border-bottom: 0; }
.bd-table td {
    padding: 13px 14px;
    border-bottom: 1px solid #F2F4F7;
    text-align: center;
    color: #5A6272;
    font-variant-numeric: tabular-nums;
}
.bd-table tbody tr:last-child td { border-bottom: 0; }
.bd-table tbody tr:hover td { background: #FAFBFC; }

.bd-no { width: 92px; }
.bd-date { width: 130px; white-space: nowrap; }
.bd-hit { width: 78px; }

.bd-table td.bd-title { text-align: left; }
.bd-title a {
    font-size: 15px;
    font-weight: 500;
    color: var(--pk-ink);
    letter-spacing: -.015em;
}
.bd-title a:hover { color: var(--pk-accent-dark); }

/* 배지 */
.bd-pin {
    display: inline-block;
    padding: 4px 11px;
    border-radius: 7px;
    background: var(--pk-accent-soft);
    color: var(--pk-accent-dark);
    font-family: var(--pk-font-ui);
    font-size: 12px;
    font-weight: 600;
}
.bd-new {
    display: inline-block;
    margin-left: 9px;
    padding: 3px 8px;
    border-radius: 6px;
    background: var(--pk-accent-soft);
    color: var(--pk-accent-dark);
    font-family: var(--pk-font-mono);
    font-size: 10.5px;
    font-weight: 600;
    letter-spacing: .06em;
    vertical-align: 2px;
}

.pk-paging { margin-top: 26px; }

@media (max-width: 768px) {
    .bd-head { margin-top: 0; }
    .bd-head h2 { font-size: 24px; }
    .bd-tools { width: 100%; }
    .bd-search { flex: 1; width: auto; }
    .bd-table td { padding: 12px 8px; }
    .bd-no, .bd-hit { display: none; }
    .bd-table th.bd-no, .bd-table th.bd-hit { display: none; }
}
</style>

<div class="container">
    <main class="main-content">
        <c:set var="boardName" value="${postType eq 'notice' ? '공지사항' : '예매오픈안내'}" />

        <div class="bd-head">
            <div>
                <h2>${boardName}</h2>
                <p class="bd-count">전체 <b>${posts.totalCount}</b>건 · ${posts.page}/${posts.totalPages} 페이지</p>
            </div>
            <div class="bd-tools">
                <form class="bd-search" method="get" action="/${postType}" role="search">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>
                    </svg>
                    <input type="search" name="keyword" value="${fn:escapeXml(keyword)}"
                           placeholder="${postType eq 'notice' ? '공지 검색' : '안내 검색'}"
                           aria-label="${boardName} 검색">
                </form>
                <c:if test="${canWrite}"><a href="/${postType}/write/0" class="bd-write">글쓰기</a></c:if>
            </div>
        </div>

        <c:choose>
            <c:when test="${posts.noData}">
                <div class="pk-empty-box">
                    <span class="ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                            <path d="M5 4h9l5 5v11a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z"/>
                            <path d="M14 4v5h5"/>
                        </svg>
                    </span>
                    <c:choose>
                        <c:when test="${not empty keyword}">
                            <b>&lsquo;${fn:escapeXml(keyword)}&rsquo; 검색 결과가 없어요</b>
                            <p>다른 검색어로 찾아보세요.</p>
                            <a href="/${postType}" class="cta">전체 목록 보기</a>
                        </c:when>
                        <c:otherwise>
                            <b>아직 등록된 글이 없습니다</b>
                            <p>첫 번째 글을 남겨보세요.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="pk-scroll-x">
                    <table class="bd-table">
                        <thead>
                            <tr>
                                <th class="bd-no">번호</th>
                                <th class="t">제목</th>
                                <th class="bd-date">작성일</th>
                                <th class="bd-hit">조회</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="post" items="${posts.list}" varStatus="status">
                                <%-- 최신 글은 번호 대신 공지 배지 --%>
                                <c:set var="isPinned" value="${posts.page eq 1 and status.first and empty keyword}" />
                                <c:set var="isNew" value="${nowMillis - post.insertDate.time < 1209600000}" />
                                <tr>
                                    <td class="bd-no">
                                        <c:choose>
                                            <c:when test="${isPinned}"><span class="bd-pin">공지</span></c:when>
                                            <c:otherwise>${posts.startNo - status.index}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="bd-title">
                                        <a href="/${postType}/view/${post.postId}"><c:out value="${post.title}" /></a>
                                        <c:if test="${isNew}"><span class="bd-new">NEW</span></c:if>
                                    </td>
                                    <td class="bd-date"><fmt:formatDate value="${post.insertDate}" pattern="yyyy-MM-dd" /></td>
                                    <td class="bd-hit">${post.hits}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:set var="pg" value="${posts}" />
                <c:set var="pgBase" value="/${postType}" />
                <c:set var="pgQuery" value="${empty keyword ? '' : '&keyword='.concat(fn:escapeXml(keyword))}" />
                <%@ include file="/WEB-INF/views/com/paging.jsp" %>
            </c:otherwise>
        </c:choose>
    </main>
</div>
<%@include file="../com/footer.jsp"%>
