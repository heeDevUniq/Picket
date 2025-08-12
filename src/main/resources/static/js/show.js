const show = {

    // 예매하기
    book() {
        const showDateId = $("[name='showDateId']:checked").val();
        if (showDateId == undefined) {
            com.alert("날짜를 선택해주세요.");
            return;
        }
        const popup = window.open('/shows/getTickets?showDateId=' + showDateId, '예매하기', 'width=1000px,height=650px,scrollbars=no,resizable=no');
    },

    // 좋아요
    like() {
        let cnt = parseInt($("#likeCount").text());
        com.ajaxForm('POST','/shows/api/like','showForm',function(result) {
            if (result.likeId > 0) {
                // 좋아요
                // 하트 채우기 추가해야 함
                cnt++;
                $("#likeCount").text(cnt);
                $("#like-btn").attr("src", "/images/fill_like.svg");
            } else {
                // 좋아요 취소
                cnt--;
                $("#likeCount").text(cnt);
                $("#like-btn").attr("src", "/images/like.svg");
            }
        });
    },

    // 이 공연 알림 받기
    setAlarm() {
        com.confirm('알림 설정','이 공연에 대한 알림을 받으시겠습니까?','question',function() {
            com.ajaxForm('POST','/shows/api/setAlarm','showForm',function(result) {
                if (result != null) {
                    // 알람 받기
                    com.alert('알림 설정이 완료되었습니다.',function() {
                        location.reload();
                    });
                } else {
                    // 알람 받기 취소
                    com.alert('알림 설정이 취소되었습니다.',function() {
                        location.reload();
                    });
                }
            });
        });
    },

    // 리뷰 등록
    saveReview() {
        com.confirm('리뷰 등록','리뷰를 등록하시겠습니까?','question',function() {
            com.ajaxForm('POST','/shows/api/saveReview','reviewForm',function(result) {
                if (result.reviewId > 0) {
                    com.alert('리뷰가 등록되었습니다.',function() {
                        location.reload();
                    });
                }
            });
        });
    },

    // 리뷰 삭제
    delReview(reviewId) {
        com.confirm('리뷰 삭제','해당 리뷰를 삭제하시겠습니까?','question',function() {
            com.ajaxParams('POST','/shows/api/delReview',{'reviewId':reviewId},function(result) {
                if (result > 0) {
                    com.alert('리뷰가 삭제되었습니다.',function() {
                        location.reload();
                    });
                }
            });
        });
    },

    // 상세정보 더보기
    loadMore() {
    },

    // 팝업 다음 페이지 이동
    popupNext() {
        const form = $('#ticketingForm');
        form.attr('method','POST');
        form.attr('action','/shows/payment');
        form.submit();
    },

    // 팝업 이전 페이지 이동
    popupPre(showDateId) {
        window.location = "/shows/getTickets?showDateId=" + showDateId;
    },

    // 팝업 닫기
    popupClose() {
        window.close();
    },

    // 결제 (아임포트 연동)
    payment(title, amount, email, name) {
        IMP.request_pay({
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
    const IMP = window.IMP; 
    IMP.init("imp00040455"); 
});