<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script>
    window.onload = function () {
        if ("${alertMsg}" != null && "${alertMsg}" != "") alert("${alertMsg}");
        const email = sessionStorage.getItem("email");
        if (email) {
            $("#email").val(email);
            $("#email").attr("readonly", true);
            sessionStorage.removeItem("email");
        }
    }
</script>
<div>
    <h2>회원가입</h2>
    <form name="form">
        <label for="email">이메일</label>
        <input type="email" name="email" id="email" value="${email}" ${email != null? 'readonly':''} /><br/>
        <label for="password">비밀번호</label>
        <input type="password" name="password" id="password" /><br/>
        <label for="confPassword">비밀번호 확인</label>
        <input type="password" name="confPassword" id="confPassword" /><br/>
        <label for="">구분</label>
        <label for="">일반</label>
        <input type="radio" name="role" id="role" value="user" />
        <label for="">티켓셀러</label>
        <input type="radio" name="role" id="role" value="seller" /><br/>
        <label for="name">이름</label>
        <input type="text" name="name" id="name" /><br/>
        <a href="#" onclick="user.join();">회원가입</a>
    </form>
</div>
<%@include file="../com/footer.jsp"%>