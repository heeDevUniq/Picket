const show = {

    // 예매 모달 열기
    book() {
        if (!window.PK_LOGIN) {
            show.goLogin();
            return;
        }
        const showDateId = $("[name='showDateId']:checked").val();
        if (showDateId === undefined) {
            pk.toast('관람일자를 선택해주세요.', 'err');
            pk.shake(document.querySelector('.datacheck'));
            return;
        }
       show.enterQueue(showDateId);
    },

    // 대기열 서버 주소
    queueBase: 'http://localhost:3001',

    // 대기열에 줄서기
    async enterQueue(showDateId) {
        const showId = $("[name='showId']").val();

        // 입장 토큰 발급
        const issued = await fetch('/shows/queue/token?showId=' + showId).then(r => r.json());
        if (!issued.success) {
            pk.toast(issued.message, 'err');
            return;
        }

        let status;
        try {
            status = await fetch(show.queueBase + '/queue/enter?showId=' + showId + '&token=' + issued.token,
                { method: 'POST' }).then(r => r.json());
        } catch (e) {
            pk.toast('대기열에 연결하지 못했습니다. 잠시 후 다시 시도해주세요.', 'err');
            return;
        }

        // 기다릴 필요 없이 바로 입장
        if (status.allowed) {
            show.openModal('/shows/getTickets?showDateId=' + showDateId);
            return;
        }

        show.openQueue(showId, issued.token, showDateId, status);
    },

    // 대기 화면 띄우기
    openQueue(showId, token, showDateId, first) {
        let wrap = document.getElementById('queueModal');
        if (!wrap) {
            wrap = document.createElement('div');
            wrap.id = 'queueModal';
            wrap.className = 'pk-queue';
            wrap.innerHTML =
                '<div class="pk-queue-dim"></div>' +
                '<div class="pk-queue-box" role="dialog" aria-modal="true" aria-label="대기열">' +
                '  <h3 class="pk-queue-title">예매 대기 중이에요.</h3>' +
                '  <p class="pk-queue-sub">순서가 되면 예매창이 자동으로 열립니다.</p>' +
                '  <p class="pk-queue-rank"><b id="qRank">-</b><small>번째</small></p>' +
                '  <p class="pk-queue-total">총 <b id="qTotal">-</b>명 대기 중</p>' +
                '  <div class="pk-queue-bar"><i id="qBar"></i></div>' +
                '  <p class="pk-queue-note">창을 닫거나 새로고침하면 대기 순서가 사라집니다.</p>' +
                '  <button type="button" class="pk-queue-x" id="qLeave" aria-label="대기 취소">' +
                '    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>' +
                '  </button>' +
                '</div>';
            document.body.appendChild(wrap);
        }

        show.queueStart = first.total || 1;
        show.queueDateId = showDateId;
        document.getElementById('qLeave').onclick = show.leaveQueue;

        show.paintQueue(first);
        document.body.style.overflow = 'hidden';
        void wrap.offsetWidth;
        wrap.classList.add('is-open');

        // 서버가 밀어주는 순번을 받는다
        show.queueSse = new EventSource(show.queueBase + '/queue/stream?showId=' + showId + '&token=' + token);
        show.queueSse.onmessage = function (e) {
            const st = JSON.parse(e.data);
            show.paintQueue(st);
            if (st.allowed) {
                show.queueDone();
            }
        };
        show.queueSse.onerror = function () {
            // 입장해서 서버가 끊은 경우가 아니면 안내
            if (show.queueSse && show.queueSse.readyState === EventSource.CLOSED) {
                return;
            }
        };
    },

    // 순번 그리기
    paintQueue(st) {
        const rank = st.rank > 0 ? st.rank : 0;
        document.getElementById('qRank').textContent = rank > 0 ? rank.toLocaleString() : '곧';
        document.getElementById('qTotal').textContent = (st.total || 0).toLocaleString();

        // 처음 순번 대비 얼마나 왔는지
        const start = show.queueStart || 1;
        const done = Math.max(0, start - rank);
        document.getElementById('qBar').style.width = Math.min(100, (done / start) * 100) + '%';
    },

    // 입장 확정
    queueDone() {
        const box = document.querySelector('#queueModal .pk-queue-box');
        if (box) {
            box.classList.add('is-ready');
            box.querySelector('.pk-queue-title').textContent = '입장했어요.';
            box.querySelector('.pk-queue-sub').textContent = '잠시 후 예매창이 열립니다.';
            document.getElementById('qRank').textContent = '입장';
            document.querySelector('.pk-queue-rank small').textContent = '';
        }
        show.closeSse();
        setTimeout(function () {
            show.closeQueue();
            show.openModal('/shows/getTickets?showDateId=' + show.queueDateId);
        }, 900);
    },

    // 사용자가 대기 포기
    leaveQueue() {
        pk.dialog({
            type: 'confirm',
            icon: 'warning',
            title: '대기를 그만둘까요?',
            message: '지금 나가면 순서가 사라지고\n다시 줄을 서야 합니다.',
            okText: '나가기',
            cancelText: '계속 기다리기',
            danger: true
        }).then(function (ok) {
            if (ok) {
                show.closeSse();
                show.closeQueue();
            }
        });
    },

    closeSse() {
        if (show.queueSse) {
            show.queueSse.close();
            show.queueSse = null;
        }
    },

    closeQueue() {
        const wrap = document.getElementById('queueModal');
        if (wrap) {
            wrap.classList.remove('is-open');
        }
        document.body.style.overflow = '';
    },

    openModal(url) {
        let wrap = document.getElementById('bookModal');
        if (!wrap) {
            wrap = document.createElement('div');
            wrap.id = 'bookModal';
            wrap.className = 'pk-modal';
            wrap.innerHTML =
                '<div class="pk-modal-dim"></div>' +
                '<div class="pk-modal-box" role="dialog" aria-modal="true" aria-label="예매하기">' +
                '  <iframe id="bookFrame" title="예매하기"></iframe>' +
                '</div>';
            document.body.appendChild(wrap);
            wrap.querySelector('.pk-modal-dim').addEventListener('click', show.requestClose);
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && wrap.classList.contains('is-open')) show.requestClose();
            });
        }
        document.getElementById('bookFrame').src = url;
        document.body.style.overflow = 'hidden';
        void wrap.offsetWidth;
        wrap.classList.add('is-open');
    },

    // 딤/ESC 로 닫을 때도 단계별 확인
    requestClose() {
        const frame = document.getElementById('bookFrame');
        try {
            const w = frame && frame.contentWindow;
            if (w && w.show && w.PK_STEP) {
                w.show.popupClose(w.PK_STEP);
                return;
            }
        } catch (e) {}
        show.closeModal();
    },

    closeModal() {
        const wrap = document.getElementById('bookModal');
        if (!wrap) return;
        wrap.classList.remove('is-open');
        document.body.style.overflow = '';
        setTimeout(function () { document.getElementById('bookFrame').src = 'about:blank'; }, 260);
    },

    // 좋아요 토글
    like() {
        const btn = document.getElementById('like-btn');
        const countEl = document.getElementById('likeCount');
        const cnt = parseInt(countEl.textContent, 10) || 0;

        com.ajaxForm('POST','/shows/api/like','showForm',function(result) {
            const liked = result > 0;
            btn.src = liked ? '/images/fill_like.svg' : '/images/like.svg';
            btn.closest('a').setAttribute('aria-pressed', liked);
            pk.countTo(countEl, liked ? cnt + 1 : Math.max(0, cnt - 1));
            pk.pop(btn);
            if (liked) {
                pk.burst(btn, '❤');
                pk.toast('관심 공연에 담았어요.', 'ok');
            } else {
                pk.toast('관심 공연에서 뺐어요.');
            }
        });
    },

    // 알림 토글
    setAlarm() {
        com.ajaxForm('POST','/shows/api/setAlarm','showForm',function(result) {
            const btn = document.getElementById('alarm-btn');
            const on = result > 0;
            btn.src = on ? '/images/fill_bell.svg' : '/images/alarm2.svg';
            btn.closest('a').setAttribute('aria-pressed', on);
            pk.pop(btn);
            if (on) {
                pk.burst(btn, '🔔');
                pk.toast('티켓팅 오픈 알림을 신청했어요.', 'ok');
            } else {
                pk.toast('알림 신청을 취소했어요.');
            }
        });
    },

    // 리뷰 등록
    saveReview() {
        const input = document.querySelector("#reviewForm input[name='content']");
        const content = input.value.trim();
        if (!content) {
            pk.shake(input);
            input.focus();
            pk.toast('리뷰 내용을 입력해주세요.', 'err');
            return;
        }
        com.ajaxForm('POST','/shows/api/saveReview','reviewForm',function(result) {
            if (result > 0) {
                show.prependReview(content);
                input.value = '';
                pk.toast('리뷰가 등록되었습니다.', 'ok');
            } else {
                pk.toast('리뷰 등록에 실패하였습니다.', 'err');
            }
        });
    },

    // 목록 맨 위에 리뷰 추가
    prependReview(content) {
        const list = document.getElementById('reviewList');
        if (!list) { location.reload(); return; }
        const empty = list.querySelector('.pk-empty');
        if (empty) empty.remove();

        const item = document.createElement('div');
        item.className = 'review-item pk-new';
        const name = document.createElement('div');
        name.className = 'nickname';
        name.textContent = list.dataset.userName || '나';
        const text = document.createElement('div');
        text.className = 'text';
        text.textContent = content;   // XSS 방지
        item.appendChild(name);
        item.appendChild(text);
        list.prepend(item);

        const cnt = document.getElementById('reviewCount');
        if (cnt) pk.countTo(cnt, (parseInt(cnt.textContent, 10) || 0) + 1);
    },

    // 리뷰 삭제
    delReview(reviewId) {
        com.confirm('리뷰 삭제','해당 리뷰를 삭제하시겠습니까?','question',function() {
            com.ajaxParams('POST','/shows/api/delReview',{'reviewId':reviewId},function(result) {
                if (result > 0) {
                    const item = document.querySelector('[data-review-id="' + reviewId + '"]');
                    if (item) {
                        item.classList.add('pk-removing');
                        setTimeout(function() { item.remove(); }, 300);
                    }
                    const cnt = document.getElementById('reviewCount');
                    if (cnt) pk.countTo(cnt, Math.max(0, (parseInt(cnt.textContent, 10) || 0) - 1));
                    pk.toast('리뷰가 삭제되었습니다.', 'ok');
                } else {
                    pk.toast('리뷰 삭제에 실패하였습니다.', 'err');
                }
            });
        });
    },

    loadMore() {
    },

    // 다음 단계
    popupNext() {
        const seatArrays = $('#seatArrays').val();
        if (!seatArrays) {
            com.alert('좌석을 선택해주세요.');
            return;
        }
        const form = $('#ticketingForm');
        form.attr('method','POST');
        form.attr('action','/shows/payment');
        form.submit();
    },

    // 좌석·결제 정보가 초기화되는 이전 단계
    popupPre(showDateId) {
        if (document.querySelector('.pk-dlg')) return;

        pk.dialog({
            type: 'confirm',
            icon: 'warning',
            danger: true,
            title: '결제를 그만둘까요?',
            message: '이전 단계로 돌아가면 선택한 좌석과 결제 정보가 초기화되며\n좌석을 처음부터 다시 골라야 합니다.',
            okText: '이전으로 돌아가기',
            cancelText: '계속하기'
        }).then(function (ok) {
            if (ok) window.location = "/shows/getTickets?showDateId=" + showDateId;
        });
    },

    // 닫기, 단계별로 잃는 항목을 먼저 안내
    popupClose(step) {
        // 확인창 중복 표시 방지
        if (document.querySelector('.pk-dlg')) return;

        const guide = {
            1: {
                title: '예매를 그만둘까요?',
                message: '지금 닫으면 선택한 좌석이 모두 해제되며\n예매가 진행되지 않습니다.',
                okText: '좌석 취소하고 닫기'
            },
            2: {
                title: '결제를 그만둘까요?',
                message: '지금 닫으면 선택한 좌석과 결제 정보가 사라지며\n처음부터 다시 예매해야 합니다.',
                okText: '결제 취소하고 닫기'
            }
        }[step];

        if (!guide) {
            show.popupCloseNow();
            return;
        }

        pk.dialog({
            type: 'confirm',
            icon: 'warning',
            danger: true,
            title: guide.title,
            message: guide.message,
            okText: guide.okText,
            cancelText: '계속하기'
        }).then(function (ok) {
            if (ok) show.popupCloseNow();
        });
    },

    // 확인 없이 즉시 닫기 (모달 안이면 부모에 통보)
    popupCloseNow() {
        if (window.parent !== window && window.parent.show) {
            window.parent.show.closeModal();
        } else {
            window.close();
        }
    },

    // 결제 (토스페이먼츠)
    async pay() {
        const cfg = window.PK_PAY;
        if (!cfg || !cfg.clientKey) {
            com.alert('결제 설정이 없습니다.\n관리자에게 문의해주세요.');
            return;
        }
        if (typeof TossPayments === 'undefined') {
            com.alert('결제 모듈을 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.');
            return;
        }
        if (!cfg.amount || cfg.amount <= 0) {
            com.alert('결제 금액이 올바르지 않습니다.');
            return;
        }

        const btn = document.getElementById('btnPay');
        pk.busy(btn, true);

        // 토스 복귀 주소, 터널을 쓰면 서버 설정값이 우선
        const origin = cfg.baseUrl || location.origin;

        try {
            const toss = TossPayments(cfg.clientKey);
            const payment = toss.payment({ customerKey: TossPayments.ANONYMOUS });

            // 성공·실패 모두 토스가 이 URL 로 리다이렉트
            // 기본값은 결제창을 iframe 으로 덧씌우는데, 예매 모달이 이미 iframe 이라
            // 이중 중첩되면 리다이렉트가 멈추므로 self 로 창 자체를 넘김
            await payment.requestPayment({
                method: 'CARD',
                amount: { currency: 'KRW', value: cfg.amount },
                orderId: cfg.orderId,
                orderName: cfg.orderName,
                successUrl: origin + '/shows/payment/success',
                failUrl: origin + '/shows/payment/fail',
                customerEmail: cfg.email || undefined,
                customerName: cfg.name || undefined,
                windowTarget: 'self',
                card: { useEscrow: false, flowMode: 'DEFAULT', useCardPoint: false, useAppCardOnly: false }
            });
        } catch (e) {
            pk.busy(btn, false);
            const msg = e && e.code === 'USER_CANCEL' ? '사용자가 결제를 취소하셨습니다.' : (e && e.message ? e.message : '알 수 없는 오류');
            // 확인을 누르면 예매창 닫기
            com.alert('결제에 실패하였습니다.\n' + msg, show.popupCloseNow);
        }
    },

    // 로그인 화면으로 (모달 안이면 부모 창 이동)
    goLogin() {
        const target = (window.parent !== window && window.parent.show) ? window.parent : window;
        const back = target.location.pathname + target.location.search;
        target.location.href = '/login?returnUrl=' + encodeURIComponent(back);
    },

    // 예매내역으로 (모달 안이면 부모 창 이동)
    goMyTickets() {
        if (window.parent !== window && window.parent.show) {
            window.parent.location.href = '/myTickets';
        } else {
            window.location.href = '/myTickets';
        }
    }

}

// const 는 window 에 등록되지 않으므로 예매 모달(iframe)의 부모 호출용으로 노출
window.show = show;
