<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../com/header.jsp" %>

<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <h2>회원정보수정</h2>
        <div class="tabs">
            <button class="tab_btn ${user.role eq 'user'?'active':''}">기본</button>
            <button class="tab_btn ${user.role eq 'seller'?'active':''}">티켓셀러</button>
        </div>
        <div class="title_btn">
            <span>기본정보</span>
        </div>
        <div class="userbox1">
            <div class="idbox">
                <p>${user.email}</p>
            </div>
            <div class="pwbox">
                <input type="password" name="password" placeholder="비밀번호">
                <button type="button" class="btn_in">비밀변호변경</button>
            </div>
            <div class="pwckbox">
                <input type="password" name="confirmPassword" placeholder="비밀번호 확인">
            </div>
        </div>

        <div class="title_btn">
            <span>전화번호</span>
        </div>
        <div class="userbox2">
                    <div class="namebox">
                        <input type="text" name="name" value="${user.name}" placeholder="이름을 입력하세요.">
                    </div>
            <div class="telbox">
              <input type="text"  placeholder="주소입력">
                <button type="button" class="btn_in">주소검색</button>
            </div>
            <div class="telcheck">
             <input type="text" placeholder="상세주소입력">
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
            </div>

            <div class="edit-link">
                <a href="#">픽켓회원탈퇴하기 ></a>
                <div class="button-container">
                    <button type="submit" class="main_btn min_btn">저장하기</button>
                </div>
            </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="../com/footer.jsp" %>