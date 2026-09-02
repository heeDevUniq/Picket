<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../com/header.jsp" %>
<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.pk-page-title { font-size: 26px; margin-bottom: 40px; }
.info-form { max-width: 900px; }
.info-section { margin-bottom: 42px; }
.info-section > h3 {
    display: flex;
    align-items: baseline;
    gap: 12px;
    font-family: var(--pk-font-ui);
    font-size: 17px;
    font-weight: 700;
    letter-spacing: -.02em;
    margin-bottom: 18px;
}
.info-section > h3 .hint {
    margin-left: auto;
    font-size: 13px;
    font-weight: 400;
    color: var(--pk-muted);
}

.field { margin-bottom: 18px; }
.field:last-child { margin-bottom: 0; }
.field > label {
    display: block;
    margin-bottom: 8px;
    font-size: 13.5px;
    font-weight: 500;
    color: #33383F;
}
.field input[type="text"],
.field input[type="password"],
.field input[type="tel"] {
    width: 100%;
    height: 48px;
    padding: 0 16px;
    border: 1px solid var(--pk-line);
    border-radius: 12px;
    font-size: 15px;
    color: var(--pk-ink);
    box-sizing: border-box;
    transition: border-color .16s cubic-bezier(.2,.8,.2,1);
}
.field input::placeholder { font-size: 15px; color: #B4BAC4; }
.field input:focus { border-color: var(--pk-accent); outline: none; }

/* 두 칸 나란히 */
.field-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.field-row { display: flex; gap: 10px; }
.field-row input { flex: 1; min-width: 0; }

/* 변경 불가 항목 */
.field .readonly {
    display: flex;
    align-items: center;
    height: 48px;
    padding: 0 16px;
    border-radius: 12px;
    background: #F4F6F8;
    color: #6B7280;
    font-size: 15px;
}
.field .readonly .lock { margin-left: auto; font-size: 13px; color: #A0A6B2; }

.pk-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    height: 48px;
    padding: 0 20px;
    border: 1px solid var(--pk-line);
    border-radius: 12px;
    background: var(--pk-surface);
    color: var(--pk-ink);
    font-family: var(--pk-font-ui);
    font-size: 14.5px;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.pk-btn:hover { border-color: #C7CDD6; }
.pk-btn--primary { background: var(--pk-accent); border-color: var(--pk-accent); color: #fff; }
.pk-btn--primary:hover { background: var(--pk-accent-dark); border-color: var(--pk-accent-dark); }
.btn-passwd { margin-top: 4px; }

/* 알림 수신 카드 */
.alarm-card { border: 1px solid var(--pk-line); border-radius: 14px; }
.alarm-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 20px 24px;
}
.alarm-row + .alarm-row { border-top: 1px solid #F1F3F6; }
.alarm-row .nm { font-size: 15px; font-weight: 600; letter-spacing: -.015em; }
.alarm-row .desc { margin-top: 4px; font-size: 13.5px; color: var(--pk-muted); }

.switch { position: relative; width: 46px; height: 26px; flex: none; }
.switch input { position: absolute; opacity: 0; width: 0; height: 0; }
.switch span {
    position: absolute;
    inset: 0;
    border-radius: 999px;
    background: #D5D9E0;
    cursor: pointer;
    transition: background .2s cubic-bezier(.2,.8,.2,1);
}
.switch span::after {
    content: "";
    position: absolute;
    top: 3px; left: 3px;
    width: 20px; height: 20px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 1px 3px rgba(0,0,0,.2);
    transition: transform .2s cubic-bezier(.2,.8,.2,1);
}
.switch input:checked + span { background: var(--pk-accent); }
.switch input:checked + span::after { transform: translateX(20px); }
.switch input:focus-visible + span { outline: 2px solid var(--pk-accent); outline-offset: 2px; }

.form-foot {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 40px;
    padding-top: 26px;
    border-top: 1px solid var(--pk-line);
}
.form-foot .withdraw { font-size: 13.5px; color: var(--pk-muted); }
.form-foot .withdraw:hover { color: #D92D20; text-decoration: underline; }
.form-foot .btns { margin-left: auto; display: flex; gap: 10px; }
.form-foot .pk-btn--primary { min-width: 128px; }

@media (max-width: 768px) {
    .info-form { max-width: none; }
    .field-grid { grid-template-columns: 1fr; gap: 0; }
    .field-grid .field { margin-bottom: 18px; }
    .alarm-row { padding: 16px; }
    .form-foot { flex-wrap: wrap; }
    .form-foot .btns { width: 100%; margin-left: 0; }
    .form-foot .btns .pk-btn { flex: 1; }
}
</style>

<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <h2 class="pk-page-title">회원정보수정</h2>

        <form class="info-form" id="myInfoForm" onsubmit="return false;">
            <div class="info-section">
                <h3>기본정보</h3>

                <div class="field">
                    <label>이메일</label>
                    <div class="readonly">${user.email}<span class="lock">변경 불가</span></div>
                </div>

                <div class="field">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" value="${user.name}" placeholder="이름을 입력하세요">
                </div>

                <div class="field">
                    <label for="phoneNumber">전화번호</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" placeholder="숫자만 입력하세요">
                </div>
            </div>

            <div class="info-section">
                <h3>비밀번호 변경<span class="hint">8~12자, 영문·숫자·특수문자 조합</span></h3>

                <div class="field">
                    <label for="beforePassword">현재 비밀번호</label>
                    <input type="password" id="beforePassword" name="beforePassword" placeholder="현재 비밀번호">
                </div>

                <div class="field-grid">
                    <div class="field">
                        <label for="afterPassword">새 비밀번호</label>
                        <input type="password" id="afterPassword" name="afterPassword" placeholder="새 비밀번호">
                    </div>
                    <div class="field">
                        <label for="confirmPassword">새 비밀번호 확인</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="한 번 더 입력하세요">
                    </div>
                </div>

                <button type="button" class="pk-btn btn-passwd" onclick="myInfo.changePassword();">비밀번호 변경</button>
            </div>

            <div class="info-section">
                <h3>주소</h3>

                <div class="field">
                    <label for="address">주소</label>
                    <div class="field-row">
                        <input type="text" id="address" name="address" value="${user.address}" placeholder="주소 검색을 눌러주세요" readonly>
                        <button type="button" class="pk-btn" onclick="myInfo.searchAddress();">주소검색</button>
                    </div>
                </div>

                <div class="field">
                    <label for="detailAddress">상세주소</label>
                    <input type="text" id="detailAddress" name="detailAddress" value="${user.detailAddress}" placeholder="동·호수 등 상세주소">
                </div>
            </div>

            <div class="info-section">
                <h3>알림 수신</h3>

                <div class="alarm-card">
                    <div class="alarm-row">
                        <div>
                            <div class="nm">메일</div>
                            <div class="desc">예매 완료, 티켓 오픈 소식을 메일로 받습니다.</div>
                        </div>
                        <label class="switch">
                            <input type="checkbox" name="emailOn" ${user.emailOn eq 'on' ? 'checked' : ''}>
                            <span></span>
                        </label>
                    </div>

                    <div class="alarm-row">
                        <div>
                            <div class="nm">카카오톡</div>
                            <div class="desc">티켓팅 당일 알림톡을 받습니다.</div>
                        </div>
                        <label class="switch">
                            <input type="checkbox" name="kakaoOn" ${user.kakaoOn eq 'on' ? 'checked' : ''}>
                            <span></span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-foot">
                <a href="#" class="withdraw" onclick="myInfo.withdraw(); return false;">픽켓 회원탈퇴하기 ›</a>
                <div class="btns">
                    <button type="button" class="pk-btn" onclick="location.reload();">취소</button>
                    <button type="button" class="pk-btn pk-btn--primary" onclick="myInfo.save();">저장하기</button>
                </div>
            </div>
        </form>
    </main>
</div>

<script>
const myInfo = {
    // 전화번호 하이픈 표기
    formatPhone(v) {
        const n = String(v || '').replace(/[^0-9]/g, '').slice(0, 11);
        if (n.length < 4) return n;
        if (n.length < 8) return n.slice(0, 3) + '-' + n.slice(3);
        if (n.length === 10) return n.slice(0, 3) + '-' + n.slice(3, 6) + '-' + n.slice(6);
        return n.slice(0, 3) + '-' + n.slice(3, 7) + '-' + n.slice(7);
    },

    // 카카오 우편번호 검색
    searchAddress() {
        new kakao.Postcode({
            oncomplete: function (data) {
                let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                let extra = '';
                if (data.userSelectedType === 'R') {
                    if (data.bname && /[동|로|가]$/g.test(data.bname)) extra += data.bname;
                    if (data.buildingName && data.apartment === 'Y') {
                        extra += (extra !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if (extra !== '') addr += ' (' + extra + ')';
                }
                document.getElementById('address').value = '[' + data.zonecode + '] ' + addr;
                document.getElementById('detailAddress').focus();
                pk.toast('주소가 입력되었습니다.', 'ok');
            }
        }).open();
    },

    changePassword() {
        const before = $('#beforePassword').val();
        const after  = $('#afterPassword').val();
        const conf   = $('#confirmPassword').val();

        if (!before || !after) {
            pk.toast('현재 비밀번호와 새 비밀번호를 입력해주세요.', 'err');
            return;
        }
        if (after !== conf) {
            pk.shake(document.getElementById('confirmPassword'));
            pk.toast('새 비밀번호가 일치하지 않습니다.', 'err');
            return;
        }
        $.ajax({
            url: '/user/api/update',
            method: 'PATCH',
            contentType: 'application/json',
            data: JSON.stringify({ beforePassword: before, afterPassword: after }),
            success(result) {
                if (result > 0) {
                    pk.toast('비밀번호가 변경되었습니다.', 'ok');
                    $('#beforePassword, #afterPassword, #confirmPassword').val('');
                } else {
                    pk.toast('현재 비밀번호가 올바르지 않습니다.', 'err');
                }
            },
            error(xhr) { com.ajaxError(xhr); }
        });
    },

    save() {
        const params = {
            name: $('#name').val(),
            phoneNumber: $('#phoneNumber').val(),
            address: $('#address').val(),
            detailAddress: $('#detailAddress').val(),
            emailOn: $('[name=emailOn]').is(':checked') ? 'on' : '',
            kakaoOn: $('[name=kakaoOn]').is(':checked') ? 'on' : ''
        };
        com.ajaxParams('PATCH', '/user/api/profile', params, function (result) {
            if (result > 0) {
                pk.toast('저장되었습니다.', 'ok');
            } else {
                pk.toast('저장에 실패하였습니다.', 'err');
            }
        });
    },

    withdraw() {
        com.confirm('회원탈퇴', '탈퇴하시면 예매 내역과 관심 공연이 모두 삭제됩니다. 진행하시겠습니까?', 'warning', function () {
            const pw = prompt('본인 확인을 위해 비밀번호를 입력해주세요.');
            if (!pw) return;
            $.ajax({
                url: '/user/api',
                method: 'DELETE',
                contentType: 'application/json',
                data: JSON.stringify({ password: pw }),
                success(result) {
                    if (result > 0) {
                        com.alert('탈퇴가 완료되었습니다.', function () { location.href = '/index'; });
                    } else {
                        pk.toast('비밀번호가 올바르지 않습니다.', 'err');
                    }
                },
                error(xhr) { com.ajaxError(xhr); }
            });
        });
    }
};

$(function () {
    const phone = document.getElementById('phoneNumber');
    phone.value = myInfo.formatPhone(phone.value);
    phone.addEventListener('input', function () { this.value = myInfo.formatPhone(this.value); });
});
</script>

<%@ include file="../com/footer.jsp" %>
