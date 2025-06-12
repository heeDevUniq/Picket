const user = {
    // 회원가입
    join() {
        com.ajaxForm('POST','/user/api/sign-up','form',function() {
            alert('회원가입이 완료되었습니다.');
            location.href = '/index';
        });
    },

    // 로그인
    login() {
        com.ajaxForm('POST','/user/api/sign-in','form');
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
        com.ajaxParams('POST','/user/api/googleLogin',{ credential: jwt },function(result) {
            if (result.alertMsg != null) alert(result.alertMsg);
            sessionStorage.setItem('email', result.email);
            location.href = result.returnUrl;
        });
    },

    // 이메일 중복 체크
    fnChkDuplId() {
        com.ajaxForm('POST','url','form',function(result) {
            console.log('다녀옴', result);
        });
    },

    // 비밀번호 일치 확인
    fnChkConfPw() {
        if ($('#password').val() == $('#confPassword').val()) {
            $('#pwText').text('비밀번호 일치').css('color', 'green')
        } else {
            $('#pwText').text('비밀번호 불일치').css('color', 'red');
        }
    },

}