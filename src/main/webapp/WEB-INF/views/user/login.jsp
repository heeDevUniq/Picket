<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div>
    <h2>로긘페이지</h2>
    <form method="post" action="/doLogin">
        이메일 : <input type="email" name="email" />
        비밀번호 : <input type="password" name="password" />
        <button type="submit">로그인</button>
    </form>
</div>
<%@include file="../com/footer.jsp"%>