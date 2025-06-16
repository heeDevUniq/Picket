<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/noheader.jsp"%>
<script>
    window.onload = function () {
        if ("${alertMsg}" != null && "${alertMsg}" != "") alert("${alertMsg}");
        const email = sessionStorage.getItem("email");
        if (email) {
            $("#email").val(email);
            $("#providerType").val("google");
            $("#email").attr("readonly", true);
            sessionStorage.removeItem("email");
        }
    }
</script>
<div class="login-box">
<div class="signup">
<div class="logo" alt="logo">
       <img src="/images/com/logo.png" alt="PICKET 로고">
       </div>
       <div class="tabs-radio">
               <input type="radio" name="role" id="tab1" value="user" class="tabs_btn" checked  />
               <label for="tab1" class="tab_radio_label" >일반</label>
               <input type="radio" name="role" id="tab2" value="seller" class="tabs_btn"  /><br/>
               <label for="tab2"  class="tab_radio_label" >티켓셀러</label>
       </div>
<div>
    <form name="form">

        <input type="hidden" name="providerType" value="" />
        <div class="input-group email">
        <input type="text" name="name" id="name" placeholder="이름" /><br/>
        </div>
         <div class="input-group">
        <input type="email" name="email" id="email" placeholder="이메일" value="${email}" ${email != null? 'readonly':''} />
        <span id="duplText"></span>
        <a href="#" onclick="user.fnChkDupl();" class="duplbtn">중복체크</a>
        </div>
         <div class="input-group">
        <input type="password" name="password" id="password" placeholder="비밀번호" oninput="user.fnChkPw();" /><span class="icon lock"></span>
        </div>
         <div class="input-group pw">
        <input type="password" name="confPassword" id="confPassword" placeholder="비밀번호 확인" oninput="user.fnChkPw();" /><br/>
        <span id="pwText"></span>
        </div>
        <p style="text-align: left; margin: 5px; padding-top: 15px;"> 이벤트 알람 수신 동의</p>
         <div class="checkbox">
        <input type="checkbox" name="kakaoOn" id="kakaoOn">
        <label for="checkbox">카카오톡</label>
        <input type="checkbox" name="emailOn" id="emailOn">
         <label for="checkbox">메일</label>
        </div>
        <a href="#" onclick="user.join();" class="main_btn">가입하기</a>
    </form>
    </div>
</div>
</div>