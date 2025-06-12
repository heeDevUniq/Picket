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

    // 구글 로그인
    googleLogin() {
       const client = google.accounts.oauth2.initTokenClient({
           client_id: '363711896074-5mb07i2qch83a1ob8qh0ce8lg8a5p43c.apps.googleusercontent.com',
           scope: 'email',
           callback: (tokenResponse) => {
               const accessToken = tokenResponse.access_token;

               com.ajaxParams('POST', '/user/api/googleLogin', { credential: accessToken }, function(result) {
                   if (result.alertMsg != null) alert(result.alertMsg);
                   sessionStorage.setItem('email', result.email);
                   location.href = result.returnUrl;
               });
           }
       });

       client.requestAccessToken();
    },

    // 이메일 중복 체크
    fnChkDupl() {
        com.ajaxForm('POST','/user/api/chkDupl','form',function(result) {
            if (result > 0) {
                $('#duplText').text('이미 사용중인 이메일입니다.').css('color', 'red');
            } else {
                $('#duplText').text('이미 사용중인 이메일입니다.').css('color', 'blue');
            }
        });
    },

    // 비밀번호 일치 확인
    fnChkConfPw() {
        if ($('#password').val() == $('#confPassword').val()) {
            $('#pwText').text('비밀번호 일치').css('color', 'blue');
        } else {
            $('#pwText').text('비밀번호 불일치').css('color', 'red');
        }
    },

}