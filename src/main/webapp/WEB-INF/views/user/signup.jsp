<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div>
    <h2>회원가입</h2>
    <form method="post" action="/user/api/signup">
        <label for="email">이메일</label>
        <input type="email" name="email" id="email" />
        <label for="password">비밀번호</label>
        <input type="password" name="password" id="password" />
        <label for="confPassword">비밀번호 확인</label>
        <input type="password" name="confPassword" id="confPassword" />
        <label for="name">이름</label>
        <input type="text" name="name" id="name" />
        <button type="submit">회원가입</button>
    </form>
</div>
<%@include file="../com/footer.jsp"%>