<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../com/header.jsp" %>

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

        <div class="title_btn">
            <span>기본정보</span>
        </div>

        <div class="userbox1">
            <div class="idbox">
                <p>azxc1234</p>
            </div>

            <div class="pwbox">
                <input type="password" name="" placeholder="비밀번호">
                   <button type="button" class="btn_in">비밀변호변경</button>
            </div>

            <div class="pwckbox">
                <input type="password" name="" placeholder="비밀번호 확인">
            </div>
        </div>

        <div class="title_btn">
            <span>전화번호 수정</span>
        </div>

        <div class="userbox2">
                <div class="namebox">
                    <input type="text" name="" placeholder="홍길동">
                </div>

                <div class="telbox">
                    <select name="" id="">
                        <option value="" disabled selected>통신사</option>
                        <option value="SKT">SKT</option>
                        <option value="KT">KT</option>
                        <option value="U+">U+</option>
                        <option value="알뜰폰 SKT">알뜰폰 SKT</option>
                        <option value="알뜰폰 KT">알뜰폰 KT</option>
                        <option value="알뜰폰 U+">알뜰폰 U+</option>
                    </select>
                    <input type="tel" placeholder="전화번호">
                    <button type="button" class="btn_in">인증번호 발송</button>
                </div>

                <div class="telcheck">
                    <input type="tel" placeholder="전화번호 확인">
                    <button type="button" class="btn_in">확인</button>
                </div>
        </div>


     <div class="title_btn">
        <span>이벤트 알람</span>
        </div>
<div class="alarm-wrap">
  <div class="alarm-item">
    <div class="alarm-label">메일</div>
    <label class="toggle-switch">
      <input type="checkbox">
      <span class="slider"></span>
    </label>
  </div>

  <div class="alarm-item">
    <div class="alarm-label">카카오톡</div>
    <label class="toggle-switch">
      <input type="checkbox" checked>
      <span class="slider"></span>
    </label>
  </div>
  </div>
  <div class="edit-link">
  <a href="#">픽켓회원탈퇴하기 > </a>
        <div class="button-container">
            <button type="submit" class="main_btn min_btn">저장하기</button>
        </div>
  </div>
    </main>
</div>

<%@ include file="../com/footer.jsp" %>
