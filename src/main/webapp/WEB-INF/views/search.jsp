<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="./com/header.jsp"%>
<style>
.search-head { margin: 16px 0 6px; }
.search-head h2 { letter-spacing: -.025em; }
.search-head h2 em { font-style: normal; color: #2875FF; }
.show-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 26px;
    margin-top: 22px;
}
.show-card {
    background: #fff;
    border: 1px solid #E7E9EE;
    border-radius: 14px;
    overflow: hidden;
    cursor: pointer;
}
.show-info { padding: 14px; }
.show-info .title { font-size: 15px; font-weight: 700; margin-bottom: 6px; }
.show-info .venue, .show-info .date { font-size: 13px; color: #6B7280; margin-bottom: 4px; }
.ticket-info { display: flex; align-items: center; gap: 8px; margin-top: 10px; font-size: 12px; flex-wrap: wrap; }
.ticket-info .price { margin-left: auto; font-weight: 700; font-size: 13px; color: #14161A; font-variant-numeric: tabular-nums; }
.pk-btn-sm {
    display: inline-block; padding: 9px 18px; border-radius: 9px;
    background: #2875FF; color: #fff; font-size: 13px; font-weight: 600;
}
.search-tip { margin-top: 10px; font-size: 13px; color: #6B7280; }
.search-tip b { color: #14161A; }
@media (max-width: 768px) {
    .search-head h2 { font-size: 19px; }
    .show-list { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
}
</style>

<div class="container">
    <main class="main-content">
        <div class="search-head">
            <c:choose>
                <c:when test="${empty keyword}">
                    <h2>공연 검색</h2>
                </c:when>
                <c:otherwise>
                    <h2><em>&lsquo;<c:out value="${keyword}" />&rsquo;</em> 검색 결과</h2>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="pk-list-meta">
            <span>총 <b>${fn:length(shows)}</b>건</span>
        </div>

        <c:choose>
            <c:when test="${empty keyword}">
                <div class="pk-empty">
                    <b>검색어를 입력해주세요.</b>
                    공연명이나 공연장 이름으로 찾을 수 있습니다.
                </div>
            </c:when>
            <c:when test="${empty shows}">
                <div class="pk-empty">
                    <b>&lsquo;<c:out value="${keyword}" />&rsquo;에 대한 결과가 없습니다.</b>
                    <span class="search-tip">
                        단어를 줄이거나 <b>공연장 이름</b>으로 다시 검색해보세요.
                    </span>
                    <div style="margin-top:16px"><a href="/index" class="pk-btn-sm">인기 공연 보기</a></div>
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
                                    <c:if test="${show.matchType eq 'place'}">
                                        <span class="pk-poster-flag">장소 일치</span>
                                    </c:if>
                                </div>
                                <div class="show-info">
                                    <h3 class="title">${show.title}</h3>
                                    <p class="venue">${show.place}</p>
                                    <p class="date">
                                        <fmt:formatDate value="${show.startDate}" pattern="yyyy.MM.dd" />
                                    </p>
                                    <div class="ticket-info">
                                        <c:choose>
                                            <c:when test="${not empty show.openDate and show.openDate.time > nowMillis}">
                                                <span class="pk-badge pk-badge--soon">오픈예정</span>
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
            </c:otherwise>
        </c:choose>
    </main>
</div>
<%@include file="./com/footer.jsp"%>
