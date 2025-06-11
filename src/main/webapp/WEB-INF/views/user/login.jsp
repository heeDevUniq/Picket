<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<meta name="google-signin-client_id" content="363711896074-5mb07i2qch83a1ob8qh0ce8lg8a5p43c.apps.googleusercontent.com">
<div>
    <h2>로긘페이지</h2>
    <form name="form" id="form">
        이메일 : <input type="email" name="email" /><br/>
        비밀번호 : <input type="password" name="password" />
        <a href="#" onclick="user.login();">로그인</a>
        <a href="#" onclick="com.locateUrl('/signup');">회원가입</a>
        <a href="#" onclick="user.kakaoLogin();"><img src="/images/user/kakao_login_btn.png"></a>
        <div id="googleLogin"></div>
    </form>
</div>
<%@include file="../com/footer.jsp"%>