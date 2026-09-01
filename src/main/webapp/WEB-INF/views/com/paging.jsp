<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 공통 페이지네이션. 호출 전 pg, pgBase 세팅 필요 --%>
<c:if test="${pg.totalPages > 1}">
<nav class="pk-paging" aria-label="페이지 목록">
    <c:choose>
        <c:when test="${pg.hasPrev}">
            <a href="${pgBase}?page=${pg.prevPage}" class="pk-page pk-page--arrow" aria-label="이전 페이지">‹</a>
        </c:when>
        <c:otherwise>
            <span class="pk-page pk-page--arrow is-disabled" aria-hidden="true">‹</span>
        </c:otherwise>
    </c:choose>

    <c:forEach begin="${pg.blockStart}" end="${pg.blockEnd}" var="i">
        <c:choose>
            <c:when test="${i eq pg.page}">
                <span class="pk-page is-current" aria-current="page">${i}</span>
            </c:when>
            <c:otherwise>
                <a href="${pgBase}?page=${i}" class="pk-page">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <c:choose>
        <c:when test="${pg.hasNext}">
            <a href="${pgBase}?page=${pg.nextPage}" class="pk-page pk-page--arrow" aria-label="다음 페이지">›</a>
        </c:when>
        <c:otherwise>
            <span class="pk-page pk-page--arrow is-disabled" aria-hidden="true">›</span>
        </c:otherwise>
    </c:choose>
</nav>
</c:if>
