<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- myTicketCount / myLikeCount / myAlarmCount 를 쓰는 마이페이지 상단 통계 카드 --%>
<div class="pk-stats">
    <a href="/myTickets" class="pk-stat pk-stat--ticket">
        <span>
            <span class="label">나의 예매권</span>
            <b class="value">${empty myTicketCount ? 0 : myTicketCount}</b>
        </span>
        <span class="ico">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M3 8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4V8z"/>
                <path d="M14 6v12" stroke-dasharray="2 3"/>
            </svg>
        </span>
    </a>

    <a href="/myLikes" class="pk-stat pk-stat--like">
        <span>
            <span class="label">관심 공연</span>
            <b class="value">${empty myLikeCount ? 0 : myLikeCount}</b>
        </span>
        <span class="ico">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M20.8 6.6a5 5 0 0 0-7.1 0L12 8.3l-1.7-1.7a5 5 0 1 0-7.1 7.1l8.8 8.8 8.8-8.8a5 5 0 0 0 0-7.1z"/>
            </svg>
        </span>
    </a>

    <a href="/myAlarms" class="pk-stat pk-stat--alarm">
        <span>
            <span class="label">알림</span>
            <b class="value">${empty myAlarmCount ? 0 : myAlarmCount}</b>
        </span>
        <span class="ico">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/>
                <path d="M13.7 21a2 2 0 0 1-3.4 0"/>
            </svg>
        </span>
    </a>
</div>
