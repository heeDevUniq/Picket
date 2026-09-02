<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="./com/header.jsp"%>
<style>
.main-banner {
    max-width: 100%;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #000;
    color: #fff;
    height: 500px;
}
.main-banner .banner-text h1 {
    font-size: 36px;
    line-height: 1.3;
}
.main-banner .banner-text p {
    margin-top: 15px;
    font-size: 16px;
    color: #aaa;
}
.main-banner .banner-image img {
    height: 500px;
    object-fit: cover;
}

/* Genre Ranking */
.genre-ranking {
    padding: 40px;
}
.genre-ranking h2 {
    font-size: 24px;
    margin-bottom: 20px;
}
.genre-tabs {
    display: flex;
    gap: 15px;
    margin-bottom: 30px;
}
.genre-tabs button {
    border: 1px solid #007bff;
    background: #fff;
    color: #007bff;
    padding: 8px 20px;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
}
.genre-tabs button.active {
    background: #007bff;
    color: #fff;
}
.ranking-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
    gap: 24px;
}
.ranking-item {
    position: relative;
    width: 100%;
    text-align: left;
}
.ranking-item .ranking-number {
    font-size: 42px;
    font-weight: 800;
    position: absolute;
    left: 10px;
    bottom: 6px;
    color: #fff;
    z-index: 3;
    line-height: 1;
    pointer-events: none;
}
.ranking-item .pk-poster::before {
    content: "";
    position: absolute;
    inset: auto 0 0 0;
    height: 40%;
    background: linear-gradient(to top, rgba(0,0,0,.6), transparent);
    z-index: 2;
    pointer-events: none;
}
.ranking-item .ranking-img {
    width: 100%;
    margin-bottom: 12px;
}
.ranking-item .ranking-title {
    font-weight: bold;
    font-size: 14px;
}
.ranking-item .ranking-location {
    font-size: 12px;
    color: #666;
}
.ranking-item .ranking-date {
    font-size: 12px;
    color: #999;
    margin-top: 5px;
}
.ranking-item .ranking-meta {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 8px;
    flex-wrap: wrap;
}
.ranking-item .ranking-price {
    margin-left: auto;
    font-size: 12px;
    font-weight: 700;
    color: #14161A;
    font-variant-numeric: tabular-nums;
}

/* Event Banner */
.event-banner {
}

/* Open Soon */
.open-soon {
    padding: 40px;
}
.open-soon h2 {
    font-size: 24px;
    margin-bottom: 20px;
}
.open-soon h2 { display: flex; align-items: center; }
/* 화살표는 제목 오른쪽 끝에 */
.open-nav { margin-left: auto; display: flex; gap: 8px; }
.open-nav button {
    width: 34px;
    height: 34px;
    display: grid;
    place-items: center;
    border: 1px solid #E4E7EC;
    border-radius: 50%;
    background: #fff;
    color: #5A6272;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.open-nav button:hover { border-color: var(--pk-accent); color: var(--pk-accent); }
.open-nav button svg { width: 16px; height: 16px; }
.open-nav[hidden] { display: none; }

.open-list {
    display: flex;
    gap: 16px;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    scroll-behavior: smooth;
    scrollbar-width: none;
    -ms-overflow-style: none;
    padding-bottom: 2px;
}
.open-list::-webkit-scrollbar { display: none; }

.open-item {
    display: flex;
    gap: 14px;
    flex: 0 0 300px;
    box-sizing: border-box;
    scroll-snap-align: start;
    background: #fff;
    border: 1px solid #E7E9EE;
    border-radius: 14px;
    overflow: hidden;
    padding: 12px;
    color: inherit;
    transition: border-color .16s cubic-bezier(.2,.8,.2,1);
}
.open-item:hover { border-color: #C7CDD6; }
.open-item .open-img {
    width: 84px;
    flex: 0 0 84px;
    border-radius: 10px;
}
.open-item .open-info {
    padding: 2px 0;
    display: flex;
    flex-direction: column;
    gap: 4px;
    min-width: 0;
}
.open-item .pk-countdown {
    font-size: 13px;
}
.open-item .badge {
    display: inline-block;
    background: #007bff;
    color: #fff;
    font-size: 12px;
    padding: 2px 6px;
    border-radius: 4px;
    margin-bottom: 5px;
}
.open-item .date {
    font-size: 12px;
    color: #333;
}
.open-item p {
    font-size: 14px;
    margin-top: 5px;
    color: #333;
}

@media (max-width: 768px) {
    .open-soon { padding: 24px 16px; }
    .open-item { flex: 0 0 82%; }
    .open-nav { display: none; }
}
</style>
<section class="main-banner">
        <div class="banner-text">
            <h1>Karsten Winegeart<br>최초 내한 사진전</h1>
            <p>예술의전당<br>2025.05.09 - 06.09</p>
        </div>
        <div class="banner-image">
            <img src="images/main_view.png" alt="Karsten Winegeart Banner">
        </div>
    </section>

<section class="genre-ranking">
    <h2>장르별 랭킹</h2>
    <div class="genre-tabs" id="genreTabs">
        <button type="button" class="active" data-genre="">전체</button>
        <button type="button" data-genre="musical">뮤지컬/연극</button>
        <button type="button" data-genre="concert">콘서트</button>
        <button type="button" data-genre="classic">클래식/무용</button>
        <button type="button" data-genre="exhibit">전시/행사</button>
        <button type="button" data-genre="festival">페스티벌</button>
    </div>
    <div class="ranking-list" id="rankingList">
        <c:forEach var="show" items="${shows}" varStatus="i">
            <a href="/shows/view/${show.showId}">
                <div class="ranking-item">
                    <div class="pk-poster ranking-img">
                        <img src="${show.posterLink}" alt="${show.title} 포스터"
                             data-show-id="${show.showId}" loading="lazy">
                        <span class="ranking-number">${i.count}</span>
                    </div>
                    <div class="ranking-title">${show.title}</div>
                    <div class="ranking-location">${show.place}</div>
                    <div class="ranking-date"><fmt:formatDate value="${show.startDate}" pattern="yyyy.MM.dd" /></div>
                    <div class="ranking-meta">
                        <c:choose>
                            <c:when test="${show.remainCount eq 0}"><span class="pk-badge pk-badge--done">매진</span></c:when>
                            <c:otherwise><span class="pk-badge pk-badge--open">예매중</span></c:otherwise>
                        </c:choose>
                        <c:if test="${not empty show.minPrice}">
                            <span class="ranking-price"><fmt:formatNumber value="${show.minPrice}" pattern="#,###" />원~</span>
                        </c:if>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>
</section>

<section class="event-banner">
    <a href="/notice"><img src="/images/banner.png" alt="event Banner" style="display:block; margin:0 auto; width:70%;"></a>
</section>

<section class="open-soon">
    <h2>
        오픈예정
        <span class="open-nav" id="openNav" hidden>
            <button type="button" data-dir="-1" aria-label="이전">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 6l-6 6 6 6"/></svg>
            </button>
            <button type="button" data-dir="1" aria-label="다음">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 6l6 6-6 6"/></svg>
            </button>
        </span>
    </h2>
    <div class="open-list" id="openList">
        <c:forEach var="show" items="${shows}">
            <a href="/shows/view/${show.showId}" class="open-item">
                <div class="open-img pk-poster">
                    <img src="${show.posterLink}" alt="${show.title} 포스터"
                         data-show-id="${show.showId}" loading="lazy">
                </div>
                <div class="open-info">
                    <span class="pk-badge pk-badge--soon">오픈예정</span>
                    <span class="date"><fmt:formatDate value="${show.openDate}" pattern="yyyy.MM.dd HH:mm" /></span>
                    <div class="pk-countdown"
                         <c:if test="${not empty show.openDate}">data-countdown="${show.openDate.time}"</c:if>>
                    </div>
                    <p>${show.title}<br>${show.place}</p>
                </div>
            </a>
        </c:forEach>
    </div>
</section>

<script>
// 오픈예정 가로 슬라이드 (2초 자동)
(function () {
    const track = document.getElementById('openList');
    const nav   = document.getElementById('openNav');
    if (!track) return;

    const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    let timer = null;

    // 카드 하나 + 간격
    function step() {
        const card = track.querySelector('.open-item');
        if (!card) return 316;
        return card.getBoundingClientRect().width + 16;
    }

    function scrollable() {
        return track.scrollWidth - track.clientWidth > 4;
    }

    function go(dir) {
        const max = track.scrollWidth - track.clientWidth;
        if (dir > 0 && track.scrollLeft >= max - 4) {
            track.scrollTo({ left: 0 });
        } else if (dir < 0 && track.scrollLeft <= 4) {
            track.scrollTo({ left: max });
        } else {
            track.scrollBy({ left: dir * step() });
        }
    }

    function start() {
        if (timer || reduce || !scrollable()) return;
        timer = setInterval(function () { go(1); }, 2000);
    }

    function stop() {
        clearInterval(timer);
        timer = null;
    }

    if (nav) {
        nav.hidden = !scrollable();
        nav.addEventListener('click', function (e) {
            const btn = e.target.closest('button[data-dir]');
            if (!btn) return;
            stop();
            go(Number(btn.dataset.dir));
            start();
        });
    }

    // 사용자가 보고 있거나 만지는 중에는 멈춘다
    track.addEventListener('mouseenter', stop);
    track.addEventListener('mouseleave', start);
    track.addEventListener('focusin', stop);
    track.addEventListener('focusout', start);
    track.addEventListener('touchstart', stop, { passive: true });
    document.addEventListener('visibilitychange', function () {
        document.hidden ? stop() : start();
    });
    window.addEventListener('resize', function () {
        if (nav) nav.hidden = !scrollable();
        scrollable() ? start() : stop();
    });

    start();
})();
</script>

<script>
// 장르 탭 (새로고침 없이 교체)
(function () {
    const tabs = document.getElementById('genreTabs');
    const list = document.getElementById('rankingList');
    if (!tabs || !list) return;

    function skeleton() {
        let html = '';
        for (let i = 0; i < 5; i++) {
            html += '<div class="ranking-item">'
                  + '<div class="pk-poster ranking-img pk-skeleton"></div>'
                  + '<div class="ranking-title pk-skeleton">&nbsp;</div>'
                  + '<div class="ranking-location pk-skeleton">&nbsp;</div>'
                  + '</div>';
        }
        list.innerHTML = html;
    }

    function esc(v) {
        return String(v == null ? '' : v)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function fmt(ts) {
        if (!ts) return '';
        const d = new Date(ts);
        return d.getFullYear() + '.' + String(d.getMonth() + 1).padStart(2, '0')
             + '.' + String(d.getDate()).padStart(2, '0');
    }

    function render(shows) {
        if (!shows || !shows.length) {
            list.innerHTML = '<div class="pk-empty"><b>등록된 공연이 없습니다.</b>다른 장르를 선택해보세요.</div>';
            return;
        }
        list.innerHTML = shows.map(function (s, i) {
            return '<a href="/shows/view/' + s.showId + '">'
                 + '<div class="ranking-item">'
                 + '<div class="pk-poster ranking-img">'
                 + '<img src="' + esc(s.posterLink) + '" alt="' + esc(s.title) + ' 포스터"'
                 + ' data-show-id="' + s.showId + '">'
                 + '<span class="ranking-number">' + (i + 1) + '</span>'
                 + '</div>'
                 + '<div class="ranking-title">' + esc(s.title) + '</div>'
                 + '<div class="ranking-location">' + esc(s.place) + '</div>'
                 + '<div class="ranking-date">' + fmt(s.startDate) + '</div>'
                 + '<div class="ranking-meta">'
                 +   (s.remainCount === 0
                        ? '<span class="pk-badge pk-badge--done">매진</span>'
                        : '<span class="pk-badge pk-badge--open">예매중</span>')
                 +   (s.minPrice ? '<span class="ranking-price">' + Number(s.minPrice).toLocaleString('ko-KR') + '원~</span>' : '')
                 + '</div>'
                 + '</div></a>';
        }).join('');
        // 새로 그린 이미지에 폴백 재적용
        pk.initImageFallback();
    }

    tabs.addEventListener('click', function (e) {
        const btn = e.target.closest('button[data-genre]');
        if (!btn || btn.classList.contains('active')) return;

        tabs.querySelectorAll('button').forEach(function (b) { b.classList.remove('active'); });
        btn.classList.add('active');
        skeleton();

        fetch('/shows/api/list?genre=' + encodeURIComponent(btn.dataset.genre))
            .then(function (r) {
                if (!r.ok) throw new Error(r.status);
                return r.json();
            })
            .then(render)
            .catch(function () {
                list.innerHTML = '<div class="pk-empty"><b>목록을 불러오지 못했습니다.</b>잠시 후 다시 시도해주세요.</div>';
                pk.toast('목록을 불러오지 못했습니다.', 'err');
            });
    });
})();
</script>
<%@include file="./com/footer.jsp"%>