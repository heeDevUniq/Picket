<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../com/header.jsp" %>

<div class="login-box">
    <div class="login">
        <div class="logo" alt="logo"></div>

        <form name="form" id="form">
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
                로그인 상태 유지
            </label>

            <a href="#" onclick="user.login();" class="main_btn">로그인</a>
        </form>

        <div class="signup">
            <p>계정이 없으신가요? <a href="">가입하기</a></p>
        </div>

        <div class="min_login">
            <div class="divider">
                <span>간편 로그인</span>
            </div>

            <div class="min_login_box">
                <a href="#" class="btn kakao">
                    <i class="fa-solid fa-comment"></i> 카카오로 계속하기
                </a>
                <a href="#" class="btn google">
                    <i class="fa-brands fa-google"></i> google로 계속하기
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="../com/footer.jsp" %>
