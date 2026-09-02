<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<style>
.page-title { margin: 16px 0 6px; }
.ticket-info {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 10px;
    font-size: 12px;
    flex-wrap: wrap;
}
.ticket-info .price {
    margin-left: auto;
    font-weight: 700;
    font-size: 13px;
    color: #14161A;
    font-variant-numeric: tabular-nums;
}
.pk-poster-flag {
    position: absolute;
    top: 8px;
    left: 8px;
    z-index: 2;
    padding: 3px 8px;
    border-radius: 999px;
    font-size: 11px;
    font-weight: 700;
    background: rgba(20,22,26,.78);
    color: #fff;
    backdrop-filter: blur(4px);
}
.pk-poster-flag--hot { background: rgba(217,45,32,.9); left: auto; right: 8px; }
.pk-btn-sm {
    display: inline-block; padding: 9px 18px; border-radius: 9px;
    background: #2875FF; color: #fff; font-size: 13px; font-weight: 600;
}

.show-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 30px;
}

.show-card {
    background: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s;
    cursor: pointer;
}

.show-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
}

.show-card .poster {
    border-radius: 0;
}

.show-info {
    padding: 15px;
}

.show-info .title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 8px;
    color: #333;
}

.show-info .venue,
.show-info .date {
    font-size: 14px;
    color: #666;
    margin-bottom: 5px;
}

.ticket-info .label {
    display: inline-block;
    background-color: #2979ff;
    color: #fff;
    font-size: 12px;
    padding: 2px 6px;
    border-radius: 3px;
    margin-top: 5px;
}
</style>
<div class="container">
    <main class="main-content">
        <h2 class="page-title">${genreLabel}</h2>

        <div class="pk-list-meta">
            <span>전체 <b>${paging.totalCount}</b>개의 공연</span>
            <c:if test="${paging.totalPages > 1}">
                <span>${paging.page} / ${paging.totalPages} 페이지</span>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${paging.noData}">
                <div class="pk-empty">
                    <b>${genreLabel} 공연이 아직 없습니다.</b>
                    다른 장르를 둘러보시거나 잠시 후 다시 확인해주세요.
                    <div style="margin-top:14px"><a href="/index" class="pk-btn-sm">메인으로</a></div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="show-list">
                    <c:forEach var="show" items="${shows}">
                        <a href="/shows/view/${show.showId}">
                            <div class="show-card">
                                <div class="poster pk-poster">
                                    <img src="${show.posterLink}" alt="${show.title} 포스터"
                                         data-show-id="${show.showId}" loading="lazy">
                                    <c:if test="${not empty show.openDate and show.openDate.time > nowMillis}">
                                        <span class="pk-poster-flag">오픈예정</span>
                                    </c:if>
                                    <c:if test="${show.remainCount ne null and show.remainCount le 10 and show.remainCount > 0}">
                                        <span class="pk-poster-flag pk-poster-flag--hot">마감임박</span>
                                    </c:if>
                                </div>
                                <div class="show-info">
                                    <h3 class="title">${show.title}</h3>
                                    <p class="venue">${show.place}</p>
                                    <p class="date">
                                        <fmt:formatDate value="${show.startDate}" pattern="yyyy.MM.dd" /> ~
                                        <fmt:formatDate value="${show.endDate}" pattern="MM.dd" />
                                    </p>
                                    <div class="ticket-info">
                                        <c:choose>
                                            <c:when test="${not empty show.openDate and show.openDate.time > nowMillis}">
                                                <span class="pk-badge pk-badge--soon">오픈예정</span>
                                                <span class="pk-countdown" data-countdown="${show.openDate.time}"></span>
                                            </c:when>
                                            <c:when test="${show.remainCount eq 0}">
                                                <span class="pk-badge pk-badge--done">매진</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="pk-badge pk-badge--open">예매중</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty show.minPrice}">
                                            <span class="price"><fmt:formatNumber value="${show.minPrice}" pattern="#,###" />원~</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>

                <c:set var="pg" value="${paging}" />
                <c:set var="pgBase" value="/shows/list/${genre}" />
                <%@ include file="/WEB-INF/views/com/paging.jsp" %>
            </c:otherwise>
        </c:choose>
    </main>
</div>
<%@include file="../com/footer.jsp"%>