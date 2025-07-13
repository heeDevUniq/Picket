const show = {

    // 예매하기
    book(showId) {
        const popup = window.open('/shows/getTickets?showId=' + showId, '예매하기', 'width=1000px,height=650px,scrollbars=no,resizable=no');
    },

    // 좋아요
    like() {
        let cnt = parseInt($("#likeCount").text());
        com.ajaxForm('POST','/shows/api/like','showForm',function(result) {
            if (result.postLikeId > 0) {
                // 좋아요
                // 하트 채우기 추가해야 함
                cnt++;
                $("#likeCount").text(cnt);
            } else {
                // 좋아요 취소
                cnt--;
                $("#likeCount").text(cnt);
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
    }

}

 $(document).ready(function() {
});