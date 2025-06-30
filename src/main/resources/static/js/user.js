const user = {
    // 회원가입
    join() {
        user.fnChkValidate('form');
        com.ajaxForm('POST','/user/api/sign-up','signupForm',function() {
            alert('회원가입이 완료되었습니다.');
            location.href = '/index';
        });
    },

    // 로그인
    login() {
        com.ajaxForm('POST','/user/api/sign-in','loginForm');
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
        com.ajaxForm('POST','/user/api/chkDupl','signupForm',function(result) {
            if (result > 0) {
                $('#duplText').text('이미 사용중인 이메일입니다.').css('color', 'red');
            } else {
                $('#duplText').text('이미 사용중인 이메일입니다.').css('color', 'blue');
            }
        });
    },

    // 비밀번호 체크
    fnChkPw() {
        // 비밀번호 일치 확인
        if ($('#password').val() == $('#confPassword').val()) {
            $('#pwText').text('비밀번호 일치합니다.').css('color', 'blue');
        } else {
            $('#pwText').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
        }

        // 비밀번호 유효성 검사 (8자이상 12자이하 영문, 숫자, 특수문자 조합)
        const regex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()])[a-zA-Z\d!@#$%^&*()]{8,12}$/;
        if (regex.test($('#password').val())) {
            $('#pwText').text('8자이상 12자이하 영문, 숫자, 특수문자 조합').css('color', 'blue');
        } else {
            $('#pwText').text('비밀번호가 유효하지 않습니다.').css('color', 'red');
        }
    },

//    fnChkValidate(formId) {
//        const form = $('#' + formId);
//        let rules = {};
//        let messages = {};
//
//        form.validate().resetForm();
//        form.find('.error').removeClass('error');
//
//        form.find('input, select, textarea').each(function() {
//            let name = $(this).attr('name');
//            if (!name) return;
//
//            rules[name] = {};
//            messages[name] = {};
//
//            // required 검사
//            if ($(this).prop('required')) {
//                rules[name].required = true;
//                messages[name].required = '필수  입력 항목입니다.';
//            }
//
//            // minlength 검사
//            if ($(this).prop('minlength')) {
//                let minlength = $(this).attr('minlength');
//                rules[name].minlength = parseInt(minlength);
//                messages[name].minlength = '최소 ' + minlength + '글자 이상 입력하세요.';
//            }
//
//            // maxlength 검사
//            if ($(this).prop('maxlength')) {
//                let maxlength = $(this).attr('maxlength');
//                rules[name].maxlength = parseInt(maxlength);
//                messages[name].maxlength = '최대 ' + maxlength + '글자까지 입력할 수 있습니다.';
//            }
//
//            // email 검사
//            if ($(this).attr('type') == 'email') {
//                rules[name].email = true;
//                messages[name].email = '올바른 이메일 형식으로 입력하세요.';
//            }
//
//        });
//        console.log(rules);
//        console.log(messages);
//        // jquery plugin 적용
//        form.validate({
//            rules: rules,
//            messages: messages,
//            debug: true,
//            errorPlacement: function(error, element) {
//                console.log('유효성 검사 실패: ' + element.attr('name', error.text()));
//                error.insertAfter(element);
//            }
//        });
//        return form.valid();
//    },

    logout() {
        vex.dialog.confirm({
            message: '로그아웃 하시겠습니까?',
            callback: function(value) {
                if (value) location.href = "/logout";
            }
        });
    }

}