<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<style>
.ms-head {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    gap: 20px;
    flex-wrap: wrap;
    margin: 16px 0;
}
.ms-head h2 {
    margin: 0 0 4px;
    font-family: var(--pk-font-ui);
    font-size: 28px;
    font-weight: 600;
    letter-spacing: -.03em;
}
.ms-count { font-size: 13.5px; color: var(--pk-muted); }
.ms-count b { font-weight: 600; color: #33383F; }
.ms-new {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    height: 40px;
    padding: 0 18px;
    border-radius: 10px;
    background: var(--pk-accent);
    color: #fff;
    font-family: var(--pk-font-ui);
    font-size: 14px;
    font-weight: 600;
    white-space: nowrap;
}
.ms-new:hover { background: var(--pk-accent-dark); color: #fff; }
.ms-new svg { width: 15px; height: 15px; }

/* 공연 카드 */
.ms-list { display: grid; gap: 12px; }
.ms-card {
    display: grid;
    grid-template-columns: 72px 1fr auto;
    align-items: center;
    gap: 18px;
    padding: 16px 18px;
    border: 1px solid var(--pk-line);
    border-radius: 14px;
    background: var(--pk-surface);
    transition: border-color .16s cubic-bezier(.2,.8,.2,1);
}
.ms-card:hover { border-color: #C7CDD6; }
.ms-poster {
    width: 72px;
    aspect-ratio: 3 / 4;
    border-radius: 9px;
    overflow: hidden;
    background: #F1F3F6;
}
.ms-poster img { width: 100%; height: 100%; object-fit: cover; display: block; }
.ms-info { min-width: 0; }
.ms-title {
    font-family: var(--pk-font-ui);
    font-size: 16px;
    font-weight: 600;
    letter-spacing: -.02em;
    color: var(--pk-ink);
}
.ms-title:hover { color: var(--pk-accent-dark); }
.ms-sub { margin-top: 4px; font-size: 13px; color: var(--pk-muted); }
.ms-stats {
    display: flex;
    flex-wrap: wrap;
    gap: 6px 8px;
    margin-top: 9px;
}
.ms-stat {
    padding: 3px 9px;
    border-radius: 6px;
    background: #F4F6F8;
    color: #5A6272;
    font-size: 12px;
    font-variant-numeric: tabular-nums;
}
.ms-stat b { font-weight: 600; color: #33383F; }
.ms-stat.is-booked { background: var(--pk-accent-soft); color: var(--pk-accent-dark); }
.ms-stat.is-booked b { color: var(--pk-accent-dark); }

.ms-acts { display: flex; gap: 8px; }
.ms-btn {
    /* a 는 button 과 달리 세로 가운데 정렬이 안 됨 */
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    height: 34px;
    padding: 0 14px;
    border: 1px solid var(--pk-line);
    border-radius: 8px;
    background: #fff;
    color: #5A6272;
    font-family: var(--pk-font-ui);
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.ms-btn:hover { border-color: #C7CDD6; color: var(--pk-ink); }
.ms-btn--del { border-color: #F3C9C9; background: #FEF4F4; color: #D64545; }
.ms-btn--del:hover { background: #E14B4B; border-color: #E14B4B; color: #fff; }
.ms-btn:disabled { opacity: .45; cursor: not-allowed; }

@media (max-width: 768px) {
    .ms-head h2 { font-size: 24px; }
    .ms-card { grid-template-columns: 60px 1fr; }
    .ms-poster { width: 60px; }
    .ms-acts { grid-column: 1 / -1; }
    .ms-acts .ms-btn { flex: 1; }
}
</style>

<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <div class="ms-head">
            <div>
                <h2>공연 관리</h2>
                <p class="ms-count">등록한 공연 <b>${shows.totalCount}</b>건 · ${shows.page}/${shows.totalPages} 페이지</p>
            </div>
            <a href="/shows/my/write" class="ms-new">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M12 5v14M5 12h14"/></svg>
                공연 등록
            </a>
        </div>

        <c:choose>
            <c:when test="${shows.noData}">
                <div class="pk-empty-box">
                    <span class="ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                            <rect x="3" y="5" width="18" height="15" rx="2"/><path d="M3 10h18M8 5V3M16 5V3"/>
                        </svg>
                    </span>
                    <b>등록한 공연이 없어요</b>
                    <p>공연을 등록하면 회차와 좌석이 자동으로 만들어집니다.</p>
                    <a href="/shows/my/write" class="cta">첫 공연 등록하기</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="ms-list">
                    <c:forEach var="show" items="${shows.list}">
                        <div class="ms-card">
                            <div class="ms-poster pk-poster">
                                <img src="${fn:escapeXml(show.posterLink)}" alt="${fn:escapeXml(show.title)} 포스터" data-show-id="${show.showId}" loading="lazy">
                            </div>
                            <div class="ms-info">
                                <a href="/shows/view/${show.showId}" class="ms-title"><c:out value="${fn:escapeXml(show.title)}" /></a>
                                <div class="ms-sub">
                                    ${fn:escapeXml(show.place)}
                                    <c:if test="${not empty show.startDate}">
                                        · <fmt:formatDate value="${show.startDate}" pattern="yyyy.MM.dd" />
                                        ~ <fmt:formatDate value="${show.endDate}" pattern="yyyy.MM.dd" />
                                    </c:if>
                                </div>
                                <div class="ms-stats">
                                    <span class="ms-stat">회차 <b>${show.dateCount}</b></span>
                                    <span class="ms-stat">좌석 <b>${show.seatCount}</b></span>
                                    <span class="ms-stat ${show.bookedCount > 0 ? 'is-booked' : ''}">예매 <b>${show.bookedCount}</b></span>
                                    <span class="ms-stat">티켓오픈 <b><fmt:formatDate value="${show.openDate}" pattern="yyyy.MM.dd HH:mm" /></b></span>
                                </div>
                            </div>
                            <div class="ms-acts">
                                <a href="/shows/my/write/${show.showId}" class="ms-btn">수정</a>
                                <button type="button" class="ms-btn ms-btn--del"
                                        data-show-id="${show.showId}"
                                        data-title="${fn:escapeXml(show.title)}"
                                        data-booked="${show.bookedCount}"
                                        <c:if test="${show.bookedCount > 0}">disabled title="예매된 좌석이 있어 삭제할 수 없습니다."</c:if>>삭제</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:set var="pg" value="${shows}" />
                <c:set var="pgBase" value="/shows/my/list" />
                <%@ include file="/WEB-INF/views/com/paging.jsp" %>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<script>
// 공연 삭제
document.addEventListener('click', function (e) {
    const btn = e.target.closest('.ms-btn--del');
    if (!btn || btn.disabled) return;

    pk.dialog({
        type: 'confirm',
        icon: 'warning',
        danger: true,
        title: '공연을 삭제할까요?',
        message: btn.dataset.title + '\n회차와 좌석이 함께 삭제되며 되돌릴 수 없습니다.',
        okText: '삭제하기',
        cancelText: '돌아가기'
    }).then(function (ok) {
        if (!ok) return;
        $.ajax({
            url: '/shows/my/delete',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ showId: btn.dataset.showId }),
            success(res) {
                if (res.success) {
                    pk.toast('공연이 삭제되었습니다.', 'ok');
                    setTimeout(function () { location.reload(); }, 600);
                } else {
                    com.alert(res.message || '삭제하지 못했습니다.');
                }
            },
            error(xhr) { com.ajaxError(xhr); }
        });
    });
});
</script>
<%@include file="../com/footer.jsp"%>
