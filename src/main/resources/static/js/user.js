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
    },

    // 구글로그인
    googleLogin(response) {
        const jwt = response.credential;
        console.log("jwt : " + jwt);

        // 백엔드로 JWT 전송
        $.ajax({
            url: "/user/api/googleLogin",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ credential: jwt }),
            success: function (res) {
                if (res.success) {
                    alert("로그인 성공!");
                    window.location.href = "/index";
                } else {
                    alert("로그인 실패");
                }
            },
            error: function () {
            alert("에러 발생");
            }
        });
    },
}
$(document).ready(function() {
    Kakao.init('3f3d8ba12e822fd113873d2914be079f');
    Kakao.isInitialized();
    console.log(Kakao.isInitialized());
    // GSI 초기화
    google.accounts.id.initialize({
        client_id: "363711896074-5mb07i2qch83a1ob8qh0ce8lg8a5p43c.apps.googleusercontent.com",
        callback: user.googleLogin
    });

    // 로그인 버튼 렌더링
    google.accounts.id.renderButton(
        document.getElementById("googleLogin"),
        { theme: "outline", size: "large" }
    );
});