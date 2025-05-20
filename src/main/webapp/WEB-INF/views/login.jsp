<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<%@include file="/WEB-INF/views/com/header.jsp"%>
<body>
    <h2>로긘페이이지</h2>
    <form method="post" action="/doLogin">
        <input type="text" name="username" />
        <input type="password" name="password" />
        <button type="submit">로그인</button>
    </form>
</body>
</html>