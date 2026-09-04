<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="/js/post.js"></script>
<style>
.post-view { max-width: 760px; margin: 0 auto; padding: 0 0 72px; }

.post-crumb {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 12.5px;
    color: #9AA1AE;
    margin: 18px 0 22px;
}
.post-crumb a { color: #9AA1AE; }
.post-crumb a:hover { color: var(--pk-accent-dark); }
.post-crumb i { font-style: normal; opacity: .45; }

.post-head { margin-bottom: 4px; }

.post-kicker {
    display: inline-block;
    font-family: var(--pk-font-mono);
    font-size: 11px;
    font-weight: 600;
    letter-spacing: .14em;
    text-transform: uppercase;
    color: var(--pk-accent);
    margin-bottom: 12px;
}

.post-head h1 {
    font-size: 30px;
    font-weight: 700;
    letter-spacing: -.03em;
    line-height: 1.32;
    margin-bottom: 16px;
}

.post-meta {
    display: flex;
    align-items: center;
    gap: 0 14px;
    flex-wrap: wrap;
    padding-bottom: 20px;
    border-bottom: 1px solid #ECEEF2;
    font-size: 13px;
    color: #868EA0;
}
.post-meta dl { display: flex; align-items: baseline; gap: 5px; margin: 0; }
.post-meta dd { margin: 0; color: #5A6272; font-family: var(--pk-font-mono); }
.post-meta .sep { width: 3px; height: 3px; border-radius: 50%; background: #D5D9E0; }

.post-body {
    min-height: 200px;
    padding: 36px 0 52px;
    font-size: 15.5px;
    line-height: 1.9;
    color: #33383F;
    overflow-wrap: anywhere;
}
.post-body > *:first-child { margin-top: 0; }
.post-body p { margin: 0 0 1.15em; }
.post-body b, .post-body strong { color: #14161A; font-weight: 600; }
.post-body img { max-width: 100%; height: auto; border-radius: 12px; margin: 20px 0; }
.post-body a { color: var(--pk-accent-dark); text-decoration: underline; text-underline-offset: 3px; }
.post-body ul, .post-body ol { margin: 0 0 1.15em; padding-left: 1.15em; }
.post-body li { margin-bottom: .35em; }
.post-body ul li { list-style: disc; }
.post-body ol li { list-style: decimal; }
.post-body h2 { font-size: 19px; margin: 1.8em 0 .7em; }
.post-body h3 { font-size: 16px; margin: 1.6em 0 .6em; }

.post-body table {
    width: 100%;
    margin: 20px 0;
    border-collapse: separate;
    border-spacing: 0;
    border: 1px solid #ECEEF2;
    border-radius: 10px;
    overflow: hidden;
    font-size: 14px;
}
.post-body table th {
    background: #F7F8FA;
    text-align: left;
    padding: 10px 14px;
    font-weight: 600;
    color: #5A6272;
    border-bottom: 1px solid #ECEEF2;
}
.post-body table td { padding: 10px 14px; border-bottom: 1px solid #F2F4F7; }
.post-body table tr:last-child td { border-bottom: 0; }

.post-body blockquote {
    margin: 20px 0;
    padding: 14px 18px;
    border-left: 2px solid var(--pk-accent);
    background: #F7F9FC;
    border-radius: 0 10px 10px 0;
    color: #4A5058;
    font-size: 14.5px;
}

.post-foot {
    display: flex;
    align-items: center;
    gap: 8px;
    padding-top: 22px;
    border-top: 1px solid #ECEEF2;
}
.post-foot .right { margin-left: auto; display: flex; gap: 8px; }

.pk-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    height: 38px;
    padding: 0 16px;
    border: 1px solid #E4E7EC;
    border-radius: 9px;
    background: #fff;
    color: #33383F;
    font-family: var(--pk-font-ui);
    font-size: 13.5px;
    font-weight: 600;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.pk-btn:hover { border-color: #C7CDD6; background: #FAFBFC; }
.pk-btn--primary { background: var(--pk-accent); border-color: var(--pk-accent); color: #fff; }
.pk-btn--primary:hover { background: var(--pk-accent-dark); border-color: var(--pk-accent-dark); color: #fff; }
.pk-btn--quiet { border-color: transparent; color: #868EA0; }
.pk-btn--quiet:hover { background: #F5F6F9; border-color: transparent; color: #D92D20; }

@media (max-width: 768px) {
    .post-view { padding: 0 0 44px; }
    .post-crumb { margin: 12px 0 16px; }
    .post-head h1 { font-size: 21px; }
    .post-body { padding: 26px 0 36px; font-size: 14.5px; line-height: 1.85; }
    .post-foot { flex-wrap: wrap; }
    .post-foot .right { width: 100%; margin-left: 0; }
    .post-foot .right .pk-btn { flex: 1; }
}
</style>

<div class="container">
    <main class="main-content">
        <article class="post-view">
            <c:set var="typeLabel" value="${postType eq 'notice' ? '공지사항' : '예매오픈안내'}" />

            <nav class="post-crumb" aria-label="현재 위치">
                <a href="/index">홈</a><i>›</i><a href="/${postType}">${typeLabel}</a>
            </nav>

            <c:choose>
                <c:when test="${empty post}">
                    <div class="pk-empty">
                        <b>글을 찾을 수 없습니다</b>
                        삭제되었거나 주소가 잘못되었습니다.
                        <div style="margin-top:16px"><a href="/${postType}" class="pk-btn pk-btn--primary">목록으로</a></div>
                    </div>
                </c:when>
                <c:otherwise>
                    <header class="post-head">
                        <span class="post-kicker">${postType eq 'notice' ? 'NOTICE' : 'TICKET OPEN'}</span>
                        <h1><c:out value="${fn:escapeXml(post.title)}" /></h1>
                        <div class="post-meta">
                            <dl><dd><fmt:formatDate value="${post.insertDate}" pattern="yyyy.MM.dd" /></dd></dl>
                            <span class="sep"></span>
                            <dl><dt>조회</dt><dd>${post.hits}</dd></dl>
                            <c:if test="${not empty post.updateDate}">
                                <span class="sep"></span>
                                <dl><dt>수정</dt><dd><fmt:formatDate value="${post.updateDate}" pattern="yyyy.MM.dd" /></dd></dl>
                            </c:if>
                        </div>
                    </header>

                    <div class="post-body">${post.content}</div>

                    <form id="postForm" name="postForm">
                        <input type="hidden" name="postId" value="${post.postId}">
                    </form>

                    <div class="post-foot">
                        <a href="/${postType}" class="pk-btn">목록</a>
                        <c:if test="${canEdit}">
                            <div class="right">
                                <a href="/${postType}/write/${post.postId}" class="pk-btn">수정</a>
                                <button type="button" class="pk-btn pk-btn--quiet" onclick="post.delete('${postType}');">삭제</button>
                            </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </article>
    </main>
</div>
<%@include file="../com/footer.jsp"%>
