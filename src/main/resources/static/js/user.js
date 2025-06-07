const user = {
    // 회원가입
    join() {
        com.ajax('POST','/user/api/sign-up','form','회원가입이 완료되었습니다.',function() {
        location.href = '/index'});
    },

    // 로그인
    login() {
        console.log('로그인시도');
        com.ajax('POST','/user/api/sign-in','form','로그인이 완료되었습니다.');
    },

    // 카카오 로그인
    kakaoLogin() {
        Kakao.Auth.authorize({
           redirectUri: window.location.origin + "/user/api/kakaoLogin"
        });
    }
}
$(document).ready(function() {
    Kakao.init('3f3d8ba12e822fd113873d2914be079f');
    Kakao.isInitialized();
    console.log(Kakao.isInitialized());
});