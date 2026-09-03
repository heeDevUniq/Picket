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

    // 카드 한 칸씩 자동으로 넘기는 가로 슬라이드
    slider(track, nav, opt) {
        if (!track) return null;
        const o = opt || {};
        const interval = o.interval || 2000;
        const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        let timer = null;

        function step() {
            const card = track.querySelector(':scope > *');
            if (!card) return 300;
            const gap = parseFloat(getComputedStyle(track).columnGap) || 0;
            return card.getBoundingClientRect().width + gap;
        }

        // 한 칸 미만이면 덜컹거리므로 슬라이드 안 함
        function scrollable() {
            return track.scrollWidth - track.clientWidth >= step();
        }

        function go(dir) {
            const max = track.scrollWidth - track.clientWidth;
            if (dir > 0 && track.scrollLeft >= max - 4) track.scrollTo({ left: 0 });
            else if (dir < 0 && track.scrollLeft <= 4) track.scrollTo({ left: max });
            else track.scrollBy({ left: dir * step() });
        }

        function start() {
            if (timer || reduce || !scrollable()) return;
            timer = setInterval(function () { go(1); }, interval);
        }

        function stop() {
            clearInterval(timer);
            timer = null;
        }

        function refresh() {
            if (nav) nav.hidden = !scrollable();
            scrollable() ? start() : stop();
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

        // 보거나 만지는 중에는 정지
        track.addEventListener('mouseenter', stop);
        track.addEventListener('mouseleave', start);
        track.addEventListener('focusin', stop);
        track.addEventListener('focusout', start);
        track.addEventListener('touchstart', stop, { passive: true });
        document.addEventListener('visibilitychange', function () {
            document.hidden ? stop() : start();
        });
        window.addEventListener('resize', refresh);

        start();
        return { refresh: refresh, stop: stop, start: start };
    },

    // 축포, 기본 위치는 화면 한가운데
    confetti(opt) {
        const o = opt || {};
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

        if (!window.innerWidth || !window.innerHeight) {
            requestAnimationFrame(function () { pk.confetti(o); });
            return;
        }

        const canvas = document.createElement('canvas');
        canvas.className = 'pk-confetti';
        document.body.appendChild(canvas);
        const ctx = canvas.getContext('2d');

        function size() {
            const dpr = window.devicePixelRatio || 1;
            canvas.width = window.innerWidth * dpr;
            canvas.height = window.innerHeight * dpr;
            ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        }
        size();
        window.addEventListener('resize', size);

        const colors = ['#2875FF', '#1B4FD8', '#7BA7FF', '#FFC94D', '#FF7A7A', '#3ED598'];
        const cx = o.x != null ? o.x : window.innerWidth / 2;
        const cy = o.y != null ? o.y : window.innerHeight / 2;
        const count = o.count || 130;
        const parts = [];

        for (let i = 0; i < count; i++) {
            const angle = (Math.PI * 2 * i) / count + Math.random() * 0.35;
            const speed = 5 + Math.random() * 7;
            parts.push({
                x: cx, y: cy,
                vx: Math.cos(angle) * speed,
                vy: Math.sin(angle) * speed - 4,
                w: 6 + Math.random() * 5,
                h: 9 + Math.random() * 6,
                rot: Math.random() * Math.PI,
                vr: (Math.random() - 0.5) * 0.32,
                color: colors[i % colors.length]
            });
        }

        const DURATION = 2800;
        const start = performance.now();

        function done() {
            window.removeEventListener('resize', size);
            canvas.remove();
        }

        function frame(now) {
            const t = now - start;
            const fade = Math.max(0, 1 - t / DURATION);
            ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

            let alive = false;
            for (const p of parts) {
                p.vy += 0.22;
                p.vx *= 0.995;
                p.x += p.vx;
                p.y += p.vy;
                p.rot += p.vr;
                if (p.y < window.innerHeight + 40) alive = true;

                ctx.save();
                ctx.globalAlpha = fade;
                ctx.translate(p.x, p.y);
                ctx.rotate(p.rot);
                ctx.fillStyle = p.color;
                ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h);
                ctx.restore();
            }

            if (alive && fade > 0) requestAnimationFrame(frame);
            else done();
        }
        requestAnimationFrame(frame);
    },

    // 다이얼로그 (SweetAlert 대체). Promise<boolean> 반환
    dialog(opt) {
        return new Promise(function (resolve) {
            const o = opt || {};
            const isConfirm = o.type === 'confirm';

            const wrap = document.createElement('div');
            wrap.className = 'pk-dlg';
            wrap.innerHTML =
                '<div class="pk-dlg-dim"></div>' +
                '<div class="pk-dlg-box" role="alertdialog" aria-modal="true">' +
                (o.icon ? '<span class="pk-dlg-ico pk-dlg-ico--' + o.icon + '">' + pk.dialogIcon(o.icon) + '</span>' : '') +
                (o.title ? '<h2 class="pk-dlg-title"></h2>' : '') +
                (o.message ? '<p class="pk-dlg-msg"></p>' : '') +
                '<div class="pk-dlg-btns">' +
                (isConfirm ? '<button type="button" class="pk-dlg-btn pk-dlg-btn--ghost"></button>' : '') +
                '<button type="button" class="pk-dlg-btn pk-dlg-btn--main' + (o.danger ? ' is-danger' : '') + '"></button>' +
                '</div></div>';

            // textContent 로 넣어 마크업 주입 차단
            if (o.title) wrap.querySelector('.pk-dlg-title').textContent = o.title;
            if (o.message) wrap.querySelector('.pk-dlg-msg').textContent = o.message;
            const main = wrap.querySelector('.pk-dlg-btn--main');
            main.textContent = o.okText || '확인';
            const ghost = wrap.querySelector('.pk-dlg-btn--ghost');
            if (ghost) ghost.textContent = o.cancelText || '취소';

            document.body.appendChild(wrap);
            // 리플로우 강제로 transition 시작 (rAF 는 비활성 탭에서 미동작)
            void wrap.offsetWidth;
            wrap.classList.add('is-open');

            const prevFocus = document.activeElement;
            main.focus();

            function close(result) {
                document.removeEventListener('keydown', onKey);
                wrap.classList.remove('is-open');
                setTimeout(function () {
                    wrap.remove();
                    if (prevFocus && prevFocus.focus) prevFocus.focus();
                    resolve(result);
                }, 180);
            }

            function onKey(e) {
                if (e.key === 'Escape') { e.preventDefault(); close(false); }
                else if (e.key === 'Enter') { e.preventDefault(); close(true); }
                else if (e.key === 'Tab') {
                    const f = wrap.querySelectorAll('.pk-dlg-btn');
                    const first = f[0], last = f[f.length - 1];
                    if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
                    else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
                }
            }

            main.addEventListener('click', function () { close(true); });
            if (ghost) ghost.addEventListener('click', function () { close(false); });
            wrap.querySelector('.pk-dlg-dim').addEventListener('click', function () { close(false); });
            document.addEventListener('keydown', onKey);
        });
    },

    dialogIcon(name) {
        const s = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">';
        if (name === 'success') return s + '<circle cx="12" cy="12" r="9"/><path d="M8.5 12.5l2.5 2.5 4.5-5"/></svg>';
        if (name === 'warning') return s + '<path d="M12 3l9 16H3l9-16z"/><path d="M12 10v4M12 17h.01"/></svg>';
        if (name === 'error')   return s + '<circle cx="12" cy="12" r="9"/><path d="M15 9l-6 6M9 9l6 6"/></svg>';
        if (name === 'question')return s + '<circle cx="12" cy="12" r="9"/><path d="M9.5 9.5a2.5 2.5 0 1 1 3 2.45V14"/><path d="M12 17h.01"/></svg>';
        return s + '<circle cx="12" cy="12" r="9"/><path d="M12 8h.01M12 11v5"/></svg>';
    },

    // 초기화
    init() {
        pk.initHeader();
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

    // 포스터 로드에 실패하면 숨겨서 회색 자리표시만 노출
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

// const 는 window 에 등록되지 않으므로 프레임 간 호출용으로 노출
window.pk = pk;
