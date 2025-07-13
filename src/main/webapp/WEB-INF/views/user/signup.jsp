<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../com/noheader.jsp" %>
<script>
    window.onload = function () {
        if ('${alertMsg}' != null && '${alertMsg}' != '') {
            com.alert('${alertMsg}');
            return;
        }
        const email = sessionStorage.getItem('email');
        const providerType = sessionStorage.getItem('providerType');
        if (email) {
            $('#email').val(email);
            $('#providerType').val(providerType);
            $('#email').attr('readonly', true);
            sessionStorage.removeItem('email');
        }
    }
</script>
<div class="login-box">
    <div class="signup">
        <!-- 로고 -->
        <div class="logo">
          <a href="index.jsp"><img src="/images/com/logo.png" alt="PICKET 로고"></a>
        </div>
        <!-- 회원가입 폼 -->
        <form name="signupForm" id="signupForm">

        <!-- 회원 유형 선택 -->
        <div class="tabs-radio">
            <input type="radio" name="role" id="tab1" value="user" class="tabs_btn" checked />
            <label for="tab1" class="tab_radio_label">일반</label>

            <input type="radio" name="role" id="tab2" value="seller" class="tabs_btn" />
            <label for="tab2" class="tab_radio_label">티켓셀러</label>
        </div>

            <!-- SNS 가입 유형 hidden -->
            <input type="hidden" name="providerType" id="providerType" value="" />

            <!-- 이름 입력 -->
            <div class="input-group email">
                <input type="text" name="name" id="name" placeholder="이름" /><br/>
            </div>

            <!-- 이메일 입력 및 중복 체크 -->
            <div class="input-group">
                <input type="email" name="email" id="email"
                       placeholder="이메일"
                       value="${email}"
                       ${email != null ? 'readonly' : ''} />
                <span id="duplText"></span>
                <a href="#" onclick="user.fnChkDupl();" class="duplbtn">중복체크</a>
            </div>

            <!-- 비밀번호 입력 -->

            <div class="input-group">
                <input type="password" name="password" id="password"
                       placeholder="비밀번호"
                       oninput="user.fnChkPw();" />
                <span class="icon lock2"></span>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="input-group pw">
                <input type="password" name="confPassword" id="confPassword"
                       placeholder="비밀번호 확인"
                       oninput="user.fnChkPw();" />
                <span id="pwText"></span>
            </div>

            <!-- 알림 수신 동의 -->
            <p style="text-align: left; margin: 5px; padding-top: 15px;">이벤트 알람 수신 동의</p>
            <div class="checkbox">
                <input type="checkbox" name="kakaoOn" id="kakaoOn">
                <label for="kakaoOn">카카오톡</label>

                <input type="checkbox" name="emailOn" id="emailOn">
                <label for="emailOn">메일</label>
            </div>

            <!-- 가입 버튼 -->
            <a href="#" onclick="user.join();" class="main_btn">가입하기</a>
        </form>
    </div>
</div>



