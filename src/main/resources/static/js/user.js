const user = {
    // 회원가입
    join() {
        com.ajax('POST','/user/api/sign-up','form','회원가입이 완료되었습니다.');
    },

    // 로그인
    login() {
        console.log('로그인시도');
        com.ajax('POST','/user/api/sign-in','form','로그인이 완료되었습니다.');
    }
}