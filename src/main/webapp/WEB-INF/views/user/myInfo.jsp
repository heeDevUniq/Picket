<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

 <main class="main-content">
  <h2>회원정보수정</h2>
          <div class="tabs">
              <button class="tab_btn active">기본</button>
              <button class="tab_btn">티켓셀러</button>
          </div>
           <button type="submit" class="main_btn min_btn">저장하기</button>
           <span>기본정보</span>
           <div class="userbox1">
           <div class="idbox"><p>azxc1234</p></div>
           <div class="pwbox">
           <input type="pw" name="" placeholder="비밀번호">
           </div>
            <div class="pwckbox">
            <input type="pw" name="" placeholder="비밀번호확인"></div>
           </div>

           <span>전화번호 수정</span>
            <div class="userbox2">
            <div class="telbox">
            <input type="name" name="" placeholder="홍길동" >
            <select></select> <input type="tel" placeholder="비밀번호">
             <input type="tel" placeholder="비밀번호 확인"><button></button>
            </div>
            </div>
           <span>이벤트 알람</span>
           <div class="userbox3"></div>
          <a href=""><p>픽켓회원탈퇴하기</p></a>

 </mian>
</div>
<%@include file="../com/footer.jsp"%>