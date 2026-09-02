/* 공통 인터랙션 유틸 */
const pk = {

    // 토스트
    toast(message, type) {
        let wrap = document.querySelector('.pk-toast-wrap');
        if (!wrap) {
            wrap = document.createElement('div');
            wrap.className = 'pk-toast-wrap';
            document.body.appendChild(wrap);
        }
        const el = document.createElement('div');
        el.className = 'pk-toast' + (type ? ' pk-toast--' + type : '');
        el.setAttribute('role', 'status');
        el.textContent = message;
        wrap.appendChild(el);

        setTimeout(function () {
            el.classList.add('pk-out');
            setTimeout(function () { el.remove(); }, 300);
        }, 2400);
    },

    // 로딩 상태
    busy(el, on) {
        if (!el) return;
        el.classList.toggle('pk-loading', on !== false);
    },

    // 숫자 카운트 애니메이션
    countTo(el, to) {
        if (!el) return;
        const from = parseInt(el.textContent, 10) || 0;
        if (from === to) return;
        const start = performance.now();
        const dur = 380;
        function step(now) {
            const p = Math.min(1, (now - start) / dur);
            const eased = 1 - Math.pow(1 - p, 3);
            el.textContent = Math.round(from + (to - from) * eased);
            if (p < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
        el.classList.remove('pk-count-bump');
        void el.offsetWidth;
        el.classList.add('pk-count-bump');
    },

    // 파티클
    burst(anchor, emoji) {
        if (!anchor) return;
        const rect = anchor.getBoundingClientRect();
        for (let i = 0; i < 6; i++) {
            const p = document.createElement('span');
            p.className = 'pk-heart-burst';
            p.textContent = emoji || '❤';
            p.style.left = (rect.left + rect.width / 2 + window.scrollX) + 'px';
            p.style.top = (rect.top + rect.height / 2 + window.scrollY) + 'px';
            p.style.setProperty('--dx', (Math.random() * 80 - 40).toFixed(0) + 'px');
            p.style.setProperty('--dy', (-40 - Math.random() * 50).toFixed(0) + 'px');
            document.body.appendChild(p);
            setTimeout(function () { p.remove(); }, 750);
        }
    },

    // 팝 애니메이션
    pop(el) {
        if (!el) return;
        el.classList.remove('pk-pop');
        void el.offsetWidth;
        el.classList.add('pk-pop');
    },

    shake(el) {
        if (!el) return;
        el.classList.remove('pk-shake');
        void el.offsetWidth;
        el.classList.add('pk-shake');
    },

    // 금액 포맷
    won(n) {
        return (n || 0).toLocaleString('ko-KR');
    },

    // 남은 시간
    remain(target) {
        const diff = target - Date.now();
        if (diff <= 0) return null;
        const s = Math.floor(diff / 1000);
        const d = Math.floor(s / 86400);
        const h = Math.floor((s % 86400) / 3600);
        const m = Math.floor((s % 3600) / 60);
        const sec = s % 60;
        return { d: d, h: h, m: m, s: sec };
    },

    // 초기화
    init() {
        pk.initHeader();
        pk.initRipple();
        pk.initReveal();
        pk.initTopButton();
        pk.initCountdown();
        pk.initImageFallback();
        pk.initSearch();
    },

    // 검색 자동완성
    initSearch() {
        const wrap  = document.getElementById('pkSearch');
        const input = document.getElementById('pkSearchInput');
        const panel = document.getElementById('pkSuggest');
        if (!wrap || !input || !panel) return;

        let timer = null;
        let items = [];
        let cursor = -1;

        const esc = v => String(v == null ? '' : v)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');

        // 일치 구간 강조
        function mark(text, kw) {
            const t = esc(text);
            if (!kw) return t;
            const i = text.toLowerCase().indexOf(kw.toLowerCase());
            if (i < 0) return t;
            return esc(text.slice(0, i)) + '<mark>' + esc(text.slice(i, i + kw.length)) + '</mark>' + esc(text.slice(i + kw.length));
        }

        function close() {
            panel.hidden = true;
            input.setAttribute('aria-expanded', 'false');
            cursor = -1;
        }

        function highlight() {
            [...panel.querySelectorAll('.pk-suggest-row')].forEach((el, i) => {
                el.classList.toggle('is-active', i === cursor);
                if (i === cursor) el.scrollIntoView({ block: 'nearest' });
            });
        }

        function render(list, kw) {
            items = list;
            if (!list.length) {
                panel.innerHTML = '<div class="pk-suggest-empty">&lsquo;' + esc(kw) + '&rsquo;에 대한 결과가 없습니다.</div>';
            } else {
                panel.innerHTML = list.map(function (s) {
                    const isPlace = s.matchType === 'place';
                    return '<a class="pk-suggest-row" role="option" href="/shows/view/' + s.showId + '">'
                         + '<img class="pk-suggest-thumb" src="' + esc(s.posterLink) + '" alt="" data-show-id="' + s.showId + '">'
                         + '<span class="pk-suggest-text">'
                         +   '<b>' + mark(s.title, kw) + '</b>'
                         +   '<small>' + mark(s.place || '', kw) + '</small>'
                         + '</span>'
                         + '<span class="pk-suggest-kind">' + (isPlace ? '장소' : '공연') + '</span>'
                         + '</a>';
                }).join('');
                pk.initImageFallback();
            }
            panel.hidden = false;
            input.setAttribute('aria-expanded', 'true');
            cursor = -1;
        }

        input.addEventListener('input', function () {
            const kw = input.value.trim();
            clearTimeout(timer);
            if (kw.length < 1) { close(); return; }
            // 입력이 멈춘 뒤에만 요청
            timer = setTimeout(function () {
                fetch('/shows/api/search?keyword=' + encodeURIComponent(kw))
                    .then(r => r.ok ? r.json() : [])
                    .then(list => render(list, kw))
                    .catch(() => close());
            }, 180);
        });

        input.addEventListener('keydown', function (e) {
            if (panel.hidden) return;
            const rows = panel.querySelectorAll('.pk-suggest-row');
            if (e.key === 'ArrowDown') { e.preventDefault(); cursor = Math.min(cursor + 1, rows.length - 1); highlight(); }
            else if (e.key === 'ArrowUp') { e.preventDefault(); cursor = Math.max(cursor - 1, -1); highlight(); }
            else if (e.key === 'Enter' && cursor >= 0) { e.preventDefault(); rows[cursor].click(); }
            else if (e.key === 'Escape') { close(); }
        });

        input.addEventListener('focus', function () {
            if (items.length && input.value.trim()) { panel.hidden = false; }
        });

        document.addEventListener('click', function (e) {
            if (!wrap.contains(e.target)) close();
        });
    },

    // 헤더 그림자
    initHeader() {
        const header = document.querySelector('header');
        if (!header) return;
        const onScroll = function () {
            header.classList.toggle('pk-stuck', window.scrollY > 8);
        };
        window.addEventListener('scroll', onScroll, { passive: true });
        onScroll();
    },

    // 클릭 리플
    initRipple() {
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.main_btn, .btn, .btn-submit, .tab_btn, .genre-tabs button');
            if (!btn) return;
            const rect = btn.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const ripple = document.createElement('span');
            ripple.className = 'pk-ripple';
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = (e.clientX - rect.left - size / 2) + 'px';
            ripple.style.top = (e.clientY - rect.top - size / 2) + 'px';
            if (getComputedStyle(btn).position === 'static') {
                btn.style.position = 'relative';
            }
            btn.style.overflow = 'hidden';
            btn.appendChild(ripple);
            setTimeout(function () { ripple.remove(); }, 600);
        });
    },

    // 스크롤 진입 시 페이드업
    initReveal() {
        const targets = document.querySelectorAll('.pk-reveal');
        if (!targets.length) return;
        if (!('IntersectionObserver' in window)) {
            targets.forEach(function (t) { t.classList.add('pk-in'); });
            return;
        }
        const io = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry, i) {
                if (!entry.isIntersecting) return;
                setTimeout(function () {
                    entry.target.classList.add('pk-in');
                }, i * 60);
                io.unobserve(entry.target);
            });
        }, { threshold: .12, rootMargin: '0px 0px -40px 0px' });
        targets.forEach(function (t) { io.observe(t); });
    },

    // 맨 위로 버튼
    initTopButton() {
        const btn = document.createElement('button');
        btn.className = 'pk-top';
        btn.type = 'button';
        btn.setAttribute('aria-label', '맨 위로');
        btn.innerHTML = '↑';
        btn.addEventListener('click', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        document.body.appendChild(btn);
        window.addEventListener('scroll', function () {
            btn.classList.toggle('pk-show', window.scrollY > 400);
        }, { passive: true });
    },

    // data-countdown 요소를 매초 갱신
    initCountdown() {
        const els = document.querySelectorAll('[data-countdown]');
        if (!els.length) return;
        const tick = function () {
            els.forEach(function (el) {
                const target = parseInt(el.getAttribute('data-countdown'), 10);
                if (!target) return;
                const r = pk.remain(target);
                if (!r) {
                    el.innerHTML = '<span class="pk-badge pk-badge--open">예매 진행중</span>';
                    return;
                }
                if (r.d > 0) {
                    el.innerHTML = 'D-' + r.d + ' <small>' + r.h + '시간 남음</small>';
                } else {
                    el.innerHTML = String(r.h).padStart(2, '0') + ':'
                        + String(r.m).padStart(2, '0') + ':'
                        + String(r.s).padStart(2, '0')
                        + ' <small>후 오픈</small>';
                }
            });
        };
        tick();
        setInterval(tick, 1000);
    },

    // 포스터가 깨지면 숨겨서 회색 자리표시만 남긴다
    initImageFallback() {
        document.querySelectorAll('img[data-show-id]').forEach(function (img) {
            img.addEventListener('error', function handler() {
                img.removeEventListener('error', handler);
                img.style.visibility = 'hidden';
            });
        });
    }
};

document.addEventListener('DOMContentLoaded', pk.init);
