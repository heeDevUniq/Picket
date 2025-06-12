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
<div>
    <h2>회원가입</h2>
    <form name="form">
        <input type="hidden" name="providerType" value="" />
        <label for="email">이메일</label>
        <input type="email" name="email" id="email" value="${email}" ${email != null? 'readonly':''} />
        <a href="#" onclick="user.fnChkDupl();">중복체크</a><span id="duplText"></span><br/>
        <label for="password">비밀번호</label>
        <input type="password" name="password" id="password" oninput="user.fnChkConfPw();" /><br/>
        <label for="confPassword">비밀번호 확인</label>
        <input type="password" name="confPassword" id="confPassword" oninput="user.fnChkConfPw();" /><br/>
        <span id="pwText"></span>
        <label for="">구분</label>
        <label for="">일반</label>
        <input type="radio" name="role" id="role" value="user" />
        <label for="">티켓셀러</label>
        <input type="radio" name="role" id="role" value="seller" /><br/>
        <label for="name">이름</label>
        <input type="text" name="name" id="name" /><br/>
        <label for="name">카카오톡</label>
        <input type="checkbox" name="kakaoOn" id="kakaoOn"><br/>
        <label for="name">메일</label>
        <input type="checkbox" name="emailOn" id="emailOn">
        <a href="#" onclick="user.join();">회원가입</a>
    </form>
</div>
<%@include file="../com/footer.jsp"%>