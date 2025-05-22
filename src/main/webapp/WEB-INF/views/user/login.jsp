<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div>
    <h2>로긘페이지</h2>
    <form name="form" id="form">
        이메일 : <input type="email" name="email" /><br/>
        비밀번호 : <input type="password" name="password" />
        <a href="#" onclick="user.login();">로그인</a>
    </form>
</div>
<%@include file="../com/footer.jsp"%>