const user = {
    // 회원가입
    join() {
        //user.fnChkValidate('form');
        com.ajaxForm('POST','/user/api/sign-up','signupForm',function(result) {
            if (result && result.success) {
                com.alert('회원가입이 완료되었습니다.',function() {
                    location.href = '/login';
                });
            } else {
                com.alert((result && result.message) ? result.message : '회원가입에 실패하였습니다.');
            }
        });
    },

    // 로그인
    login() {
        com.ajaxForm('POST','/user/api/sign-in','loginForm',function(result) {
            if (result && result.success) {
                const back = new URLSearchParams(location.search).get('returnUrl');
                location.href = back || result.returnUrl;
            } else {
                com.alert((result && result.message) ? result.message : '로그인에 실패하였습니다.');
            }
        });
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
                   if (result.alertMsg != null) {
                       com.confirm('안내',result.alertMsg,'info',function() {
                           sessionStorage.setItem('email', result.email);
                           sessionStorage.setItem('providerType', result.providerType);
                           location.href = result.returnUrl;
                       });
                   } else {
                       location.href = result.returnUrl;
                   }
               });
           }
       });

       client.requestAccessToken();
    },

    // 이메일 중복 체크
    fnChkDupl() {
        const email = $('#email').val().trim();
        if (!email) {
            pk.shake(document.getElementById('email'));
            pk.toast('이메일을 입력해주세요.', 'err');
            return;
        }
        com.ajaxForm('POST','/user/api/chkDupl','signupForm',function(result) {
            const dup = result > 0;
            $('#duplText')
                .text(dup ? '이미 사용중인 이메일입니다.' : '사용 가능한 이메일입니다.')
                .css('color', dup ? '#D92D20' : '#12B76A');
            $('#email')
                .toggleClass('pk-field-error', dup)
                .toggleClass('pk-field-ok', !dup);
            if (dup) pk.shake(document.getElementById('email'));
        });
    },

    // 비밀번호 유효성/강도/일치 검사
    fnChkPw() {
        const pw = $('#password').val() || '';
        const conf = $('#confPassword').val() || '';

        const rule = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()])[a-zA-Z\d!@#$%^&*()]{8,12}$/;
        const valid = rule.test(pw);

        // 강도 막대
        let score = 0;
        if (pw.length >= 8) score++;
        if (/[a-zA-Z]/.test(pw)) score++;
        if (/\d/.test(pw)) score++;
        if (/[!@#$%^&*()]/.test(pw)) score++;
        const bar = document.querySelector('#pwMeter i');
        if (bar) {
            const colors = ['#F04438', '#F79009', '#F79009', '#12B76A'];
            bar.style.width = (score * 25) + '%';
            bar.style.background = colors[Math.max(0, score - 1)];
        }

        $('#password')
            .toggleClass('pk-field-ok', valid && pw.length > 0)
            .toggleClass('pk-field-error', !valid && pw.length > 0);

        if (!pw) {
            $('#pwText').text('');
        } else if (!valid) {
            $('#pwText').text('8~12자, 영문·숫자·특수문자를 모두 포함해야 합니다.').css('color', '#D92D20');
        } else if (conf && pw !== conf) {
            $('#pwText').text('비밀번호가 일치하지 않습니다.').css('color', '#D92D20');
        } else if (conf && pw === conf) {
            $('#pwText').text('사용 가능한 비밀번호입니다.').css('color', '#12B76A');
        } else {
            $('#pwText').text('비밀번호 확인란에 한 번 더 입력해주세요.').css('color', '#6B7280');
        }

        $('#confPassword')
            .toggleClass('pk-field-ok', conf.length > 0 && pw === conf)
            .toggleClass('pk-field-error', conf.length > 0 && pw !== conf);
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
        com.confirm('로그아웃','로그아웃 하시겠습니까?','question',function() {
            location.href = "/logout";
        });
    }
}

// 엔터로 제출
$(function () {
    $('#loginForm input').on('keydown', function (e) {
        if (e.key === 'Enter') { e.preventDefault(); user.login(); }
    });
    $('#signupForm input').on('keydown', function (e) {
        if (e.key === 'Enter') { e.preventDefault(); user.join(); }
    });
});