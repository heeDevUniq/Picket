const show = {

    // 예매하기
    book() {
        const popup = window.open('/shows/getTickets', '예매하기', 'width=1000px,height=650px,scrollbars=no');
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
    },

    // 리뷰 등록
    saveReview() {
        com.ajaxForm('POST','/shows/api/saveReview','reviewForm',function(result) {
            console.log('리뷰저장 : ' + result);
        });
    },

    // 리뷰 삭제
    delReview() {
        com.ajaxForm('POST','/shows/api/delReview','reviewForm',function(result) {
            console.log('리뷰삭제 : ' + result);
        });
    },

    // 상세정보 더보기
    loadMore() {
    }

}

 $(document).ready(function() {
});