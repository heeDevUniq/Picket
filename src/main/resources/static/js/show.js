const show = {

    // 예매 모달 열기
    book() {
        const showDateId = $("[name='showDateId']:checked").val();
        if (showDateId === undefined) {
            pk.toast('관람일자를 선택해주세요.', 'err');
            pk.shake(document.querySelector('.datacheck'));
            return;
        }
        show.openModal('/shows/getTickets?showDateId=' + showDateId);
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
                '  <button type="button" class="pk-modal-x" aria-label="닫기">×</button>' +
                '  <iframe id="bookFrame" title="예매하기"></iframe>' +
                '</div>';
            document.body.appendChild(wrap);
            wrap.querySelector('.pk-modal-dim').addEventListener('click', show.closeModal);
            wrap.querySelector('.pk-modal-x').addEventListener('click', show.closeModal);
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') show.closeModal();
            });
        }
        document.getElementById('bookFrame').src = url;
        document.body.style.overflow = 'hidden';
        requestAnimationFrame(function () { wrap.classList.add('is-open'); });
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

    // 이전 단계
    popupPre(showDateId) {
        window.location = "/shows/getTickets?showDateId=" + showDateId;
    },

    // 닫기 (모달 안이면 부모에게 알린다)
    popupClose() {
        if (window.parent !== window && window.parent.show) {
            window.parent.show.closeModal();
        } else {
            window.close();
        }
    },

    // 결제 (아임포트)
    payment(title, amount, email, name) {
        if (typeof window.IMP === 'undefined') {
            com.alert('결제 모듈을 불러오지 못했습니다. 잠시 후 다시 시도해주세요.');
            return;
        }
        if (!amount || amount <= 0) {
            com.alert('결제 금액이 올바르지 않습니다.');
            return;
        }
        window.IMP.request_pay({
            pg: "html5_inicis",
            pay_method: "card",
            merchant_uid: "ORD20180131-0000011",   // 주문번호
            name: title,
            amount: amount,                         // 숫자 타입
            buyer_email: email,
            buyer_name: name
        }, function (rsp) { // callback
            if (rsp.success) {
                // 결제 성공
                console.log("결제 성공", rsp);
                // 결제검증
                $.ajax({
                type: 'POST',
                url: '/verify/' + rsp.imp_uid
                }).done(function(data) {
                    if(rsp.paid_amount === data.response.amount){
                        alert("결제 성공");
                    } else {
                        alert("결제 실패");
                    }
                });
            } else {
                // 결제 실패
                console.log("결제 실패", rsp);
                alert("결제에 실패하였습니다. 에러내용: " + rsp.error_msg);
            }
        });
    }

}

 $(document).ready(function() {
    // 결제 화면에서만 초기화
    if (typeof window.IMP !== 'undefined') {
        window.IMP.init("imp00040455");
    }
});