<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../com/noheader.jsp" %>
<meta name="google-signin-client_id" content="363711896074-5mb07i2qch83a1ob8qh0ce8lg8a5p43c.apps.googleusercontent.com">
<script>
    window.onload = function () {
        // Kakao 초기화
        Kakao.init('3f3d8ba12e822fd113873d2914be079f');
        Kakao.isInitialized();
    }
</script>
<div class="login-box">
    <div class="login">
        <div class="logo" alt="logo">
       <a href="/index"><img src="/images/com/logo.png" alt="PICKET 로고"></a></div>

        <form name="loginForm" id="loginForm">
            <div class="input-group email">
                <span class="icon user"></span>
                <input type="email" name="email" placeholder="이메일" />
            </div>

            <div class="input-group pw">
                <span class="icon lock"></span>
                <input type="password" name="password" placeholder="비밀번호" />
            </div>

            <label class="checkbox-group">
                <input type="checkbox" />
                <span class="checkmark"></span>
                아이디 저장
            </label>

            <a href="#" onclick="user.login();" class="main_btn">로그인</a>
        </form>

        <div class="signup_btn">
            <p>계정이 없으신가요? <a href="/signup">가입하기</a></p>
        </div>

        <div class="min_login">
            <div class="divider">
                <span>간편 로그인</span>
            </div>

            <div class="min_login_box">
                <a href="#"  class="btn kakao" onclick="user.kakaoLogin();">
                <i class="fa-solid fa-comment"></i> 카카오로 계속하기
                </a>

                <a href="#" class="btn google" onclick="user.googleLogin();">
                    <i class="fa-brands fa-google"></i> google로 계속하기
                </a>
            </div>
        </div>
    </div>