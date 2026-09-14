<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.sw-form { max-width: 900px; }
.sw-head { margin: 16px 0 26px; }
.sw-head h2 {
    margin: 0 0 4px;
    font-family: var(--pk-font-ui);
    font-size: 28px;
    font-weight: 600;
    letter-spacing: -.03em;
}
.sw-head p { margin: 0; font-size: 13.5px; color: var(--pk-muted); }

.sw-section { margin-bottom: 40px; }
.sw-section > h3 {
    display: flex;
    align-items: baseline;
    gap: 12px;
    margin-bottom: 18px;
    font-family: var(--pk-font-ui);
    font-size: 17px;
    font-weight: 700;
    letter-spacing: -.02em;
}
.sw-section > h3 .hint { margin-left: auto; font-size: 13px; font-weight: 400; color: var(--pk-muted); }

.sw-field { margin-bottom: 18px; }
.sw-field > label {
    display: block;
    margin-bottom: 8px;
    font-size: 13.5px;
    font-weight: 500;
    color: #33383F;
}
.sw-field .req { color: #E14B4B; margin-left: 3px; }
.sw-form input[type="text"],
.sw-form input[type="url"],
.sw-form input[type="number"],
.sw-form input[type="datetime-local"],
.sw-form select,
.sw-form textarea {
    width: 100%;
    height: 46px;
    padding: 0 15px;
    border: 1px solid var(--pk-line);
    border-radius: 11px;
    background: var(--pk-surface);
    font-family: inherit;
    font-size: 14.5px;
    color: var(--pk-ink);
    box-sizing: border-box;
    transition: border-color .16s cubic-bezier(.2,.8,.2,1);
}
.sw-form textarea { height: 150px; padding: 13px 15px; line-height: 1.7; resize: vertical; }
.sw-form input:focus, .sw-form select:focus, .sw-form textarea:focus { border-color: var(--pk-accent); outline: none; }
.sw-form input:disabled, .sw-form select:disabled { background: #F4F6F8; color: #8A9099; cursor: not-allowed; }
.sw-grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

/* 입력 + 옆 버튼 */
.sw-inline { display: flex; gap: 10px; }
.sw-inline .grow { flex: 1; min-width: 0; }
.sw-side {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    flex: none;
    height: 46px;
    padding: 0 16px;
    border: 1px solid var(--pk-line);
    border-radius: 11px;
    background: #fff;
    color: #33383F;
    font-family: var(--pk-font-ui);
    font-size: 14px;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.sw-side:hover { border-color: var(--pk-accent); color: var(--pk-accent-dark); }
.sw-side--quiet { color: #8A9099; }
.sw-side--quiet:hover { border-color: #E14B4B; color: #E14B4B; }

/* 포스터를 왼쪽에 두고 오른쪽에 공연명·장르 */
.sw-top { display: grid; grid-template-columns: 150px 1fr; gap: 24px; align-items: start; margin-bottom: 26px; }
.sw-poster-field { margin-bottom: 0; }
.sw-top-fields { display: grid; grid-template-columns: repeat(12, 1fr); gap: 0 16px; align-content: start; }
.sw-top-fields > .sw-field { grid-column: span 6; }
.sw-top-fields > .sw-field.col-place { grid-column: span 4; }
.sw-top-fields > .sw-field.col-addr { grid-column: span 8; }
.sw-thumb {
    width: 150px;
    aspect-ratio: 3 / 4;
    display: grid;
    place-items: center;
    border: 1px solid var(--pk-line);
    border-radius: 12px;
    background: #F4F6F8;
    overflow: hidden;
}
.sw-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
.sw-thumb .ph { color: #C2C7D0; }
.sw-thumb .ph svg { width: 34px; height: 34px; }
.sw-poster-act { display: flex; gap: 6px; margin-top: 10px; }
.sw-poster-act .sw-side { flex: 1; }
.sw-hint { margin: 8px 0 0; font-size: 12px; color: var(--pk-muted); line-height: 1.6; }
.sw-side--sm { height: 38px; padding: 0 10px; font-size: 13px; }


/* 회차 · 등급 행 */
.sw-rows { display: grid; gap: 10px; }
.sw-row { display: flex; align-items: center; gap: 10px; }
.sw-row .grow { flex: 1; min-width: 0; }
.sw-row .w-grade { flex: 0 0 150px; }
.sw-row .w-num { flex: 0 0 130px; }
.sw-del {
    width: 46px; height: 46px;
    flex: none;
    display: grid; place-items: center;
    border: 1px solid var(--pk-line);
    border-radius: 11px;
    background: #fff;
    color: #A0A6B2;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.sw-del:hover { border-color: #E14B4B; color: #E14B4B; }
.sw-del svg { width: 16px; height: 16px; }
.sw-rowfoot {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-top: 10px;
}
.sw-rowfoot .sw-add { margin-left: auto; }
.sw-rowfoot .sw-total { margin: 0; }

.sw-add {
    height: 42px;
    padding: 0 16px;
    border: 1px dashed var(--pk-line);
    border-radius: 11px;
    background: #fff;
    color: #5A6272;
    font-family: var(--pk-font-ui);
    font-size: 13.5px;
    font-weight: 600;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.sw-add:hover { border-color: var(--pk-accent); color: var(--pk-accent-dark); }

/* 예매가 있어 구성이 잠겼을 때 */
.sw-lock {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 14px 16px;
    margin-bottom: 18px;
    border-radius: 11px;
    background: #FFF7E8;
    color: #8A6316;
    font-size: 13.5px;
    line-height: 1.6;
}
.sw-lock svg { width: 17px; height: 17px; flex: none; margin-top: 2px; }

.sw-total { font-size: 13.5px; color: var(--pk-muted); }
.sw-total b { color: var(--pk-accent-dark); font-variant-numeric: tabular-nums; }

.sw-foot {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 36px;
    padding-top: 24px;
    border-top: 1px solid var(--pk-line);
}
.sw-foot .right { margin-left: auto; display: flex; gap: 10px; }
.sw-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    height: 46px;
    padding: 0 22px;
    border: 1px solid var(--pk-line);
    border-radius: 11px;
    background: #fff;
    color: #33383F;
    font-family: var(--pk-font-ui);
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: all .16s cubic-bezier(.2,.8,.2,1);
}
.sw-btn:hover { border-color: #C7CDD6; }
.sw-btn--primary { min-width: 128px; background: var(--pk-accent); border-color: var(--pk-accent); color: #fff; }
.sw-btn--primary:hover { background: var(--pk-accent-dark); border-color: var(--pk-accent-dark); }

@media (max-width: 768px) {
    .sw-form { max-width: none; }
    .sw-head h2 { font-size: 24px; }
    .sw-grid2 { grid-template-columns: 1fr; gap: 0; }
    .sw-grid2 .sw-field { margin-bottom: 18px; }
    .sw-top { grid-template-columns: 120px 1fr; gap: 16px; }
    .sw-thumb { width: 120px; }
    .sw-top-fields { grid-template-columns: 1fr; }
    .sw-top-fields > .sw-field,
    .sw-top-fields > .sw-field.col-place,
    .sw-top-fields > .sw-field.col-addr { grid-column: auto; }
    .sw-row { flex-wrap: wrap; }
    .sw-row .w-grade, .sw-row .w-num { flex: 1 1 100px; }
    .sw-foot { flex-wrap: wrap; }
    .sw-foot .right { width: 100%; margin-left: 0; }
    .sw-foot .right .sw-btn { flex: 1; }
    .sw-row { flex-wrap: wrap; }
    .sw-row .w-grade, .sw-row .w-num { flex: 1 1 100px; }
    .sw-foot { flex-wrap: wrap; }
    .sw-foot .right { width: 100%; margin-left: 0; }
    .sw-foot .right .sw-btn { flex: 1; }
}
</style>

<c:set var="isEdit" value="${not empty show}" />

<div class="container">
    <aside class="left-menu">
        <%@ include file="/WEB-INF/views/com/leftmenu.jsp" %>
    </aside>

    <main class="main-content">
        <div class="sw-head">
            <h2>${isEdit ? '공연 수정' : '공연 등록'}</h2>
            <p>회차와 좌석 등급을 입력하면 좌석이 자동으로 생성됩니다.</p>
        </div>

        <form class="sw-form" id="showForm" onsubmit="return false;">
            <input type="hidden" id="showId" value="${show.showId}">

            <div class="sw-section">
                <h3>공연 정보</h3>

                <div class="sw-top">
                    <div class="sw-field sw-poster-field">
                        <label>포스터</label>
                        <div class="sw-thumb" id="posterThumb">
                            <c:choose>
                                <c:when test="${not empty show.posterLink}">
                                    <img src="${fn:escapeXml(show.posterLink)}" alt="포스터 미리보기">
                                </c:when>
                                <c:otherwise>
                                    <span class="ph">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                            <rect x="3" y="4" width="18" height="16" rx="2"/>
                                            <circle cx="9" cy="10" r="1.6"/><path d="M21 16l-5-5-6 6"/>
                                        </svg>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sw-poster-act">
                            <input type="file" id="posterFile" accept="image/jpeg,image/png,image/gif,image/webp" hidden>
                            <button type="button" class="sw-side sw-side--sm" onclick="document.getElementById('posterFile').click();">이미지 선택</button>
                            <button type="button" class="sw-side sw-side--sm sw-side--quiet" id="btnPosterClear"
                                    <c:if test="${empty show.posterLink}">hidden</c:if>>제거</button>
                        </div>
                        <p class="sw-hint">JPG · PNG · GIF · WEBP<br>5MB 이하 · 3:4 비율 권장</p>
                        <input type="hidden" id="posterLink" value="${fn:escapeXml(show.posterLink)}">
                    </div>

                    <div class="sw-top-fields">
                        <div class="sw-field">
                            <label for="title">공연명<span class="req">*</span></label>
                            <input type="text" id="title" value="${fn:escapeXml(show.title)}" placeholder="공연명을 입력하세요" maxlength="100">
                        </div>
                        <div class="sw-field">
                            <label for="genre">장르</label>
                            <select id="genre">
                                <c:forEach var="g" items="${genreLabels}">
                                    <option value="${g.key}" ${show.genre eq g.key ? 'selected' : ''}>${g.value}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="sw-field">
                            <label for="host">주최</label>
                            <input type="text" id="host" value="${fn:escapeXml(show.host)}" placeholder="주최사를 입력하세요" maxlength="100">
                        </div>
                        <div class="sw-field">
                            <label for="contact">문의처</label>
                            <input type="text" id="contact" value="${fn:escapeXml(show.contact)}" placeholder="예) 02-1234-5678" maxlength="50">
                        </div>

                        <div class="sw-field col-place">
                            <label for="place">공연장명<span class="req">*</span></label>
                            <input type="text" id="place" value="${fn:escapeXml(show.place)}"
                                   placeholder="예) 서울 예술극장" maxlength="100">
                        </div>
                        <div class="sw-field col-addr">
                            <label for="placeAddress">주소</label>
                            <div class="sw-inline">
                                <input type="text" id="placeAddress" class="grow" value="${fn:escapeXml(show.placeAddress)}"
                                       placeholder="주소 검색을 눌러주세요" maxlength="200" readonly>
                                <button type="button" class="sw-side" onclick="showAdmin.searchAddress();">주소 검색</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="sw-grid2">
                    <div class="sw-field">
                        <label for="ageLimit">관람가</label>
                        <input type="text" id="ageLimit" value="${fn:escapeXml(show.ageLimit)}" placeholder="예) 8세 이상" maxlength="30">
                    </div>
                    <div class="sw-field">
                        <label for="openDate">티켓 오픈일시</label>
                        <input type="datetime-local" id="openDate"
                               value="<fmt:formatDate value="${show.openDate}" pattern="yyyy-MM-dd'T'HH:mm" />">
                    </div>
                </div>

                <div class="sw-field">
                    <label for="info">공연 소개</label>
                    <textarea id="info" placeholder="공연 소개를 입력하세요">${fn:escapeXml(show.info)}</textarea>
                </div>
            </div>

            <c:if test="${hasBooking}">
                <div class="sw-lock">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9">
                        <rect x="4" y="10" width="16" height="10" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/>
                    </svg>
                    <span>이미 예매된 좌석이 있어 회차와 좌석 등급은 수정할 수 없습니다. 공연 정보만 저장됩니다.</span>
                </div>
            </c:if>

            <div class="sw-section">
                <h3>관람 회차<span class="hint">회차마다 아래 좌석 등급이 그대로 만들어집니다.</span></h3>
                <div class="sw-rows" id="dateRows"></div>
                <div class="sw-rowfoot">
                    <button type="button" class="sw-add" id="addDate" ${hasBooking ? 'disabled' : ''}>+ 회차 추가</button>
                </div>
            </div>

            <div class="sw-section">
                <h3>좌석 등급<span class="hint">등급명 · 가격 · 좌석 수</span></h3>
                <div class="sw-rows" id="gradeRows"></div>
                <div class="sw-rowfoot">
                    <p class="sw-total" id="seatTotal"></p>
                    <button type="button" class="sw-add" id="addGrade" ${hasBooking ? 'disabled' : ''}>+ 등급 추가</button>
                </div>
            </div>

            <div class="sw-foot">
                <a href="/shows/my/list" class="sw-btn">목록</a>
                <div class="right">
                    <button type="button" class="sw-btn" onclick="location.href='/shows/my/list';">취소</button>
                    <button type="button" class="sw-btn sw-btn--primary" id="btnSave">${isEdit ? '저장하기' : '등록하기'}</button>
                </div>
            </div>
        </form>
    </main>
</div>

<script>
const showAdmin = {
    locked: ${hasBooking ? 'true' : 'false'},

    // 카카오 우편번호, 건물명은 공연장명 나머지는 주소로 분리
    searchAddress() {
        new kakao.Postcode({ oncomplete: showAdmin.applyAddress }).open();
    },

    // 카카오 우편번호 결과를 공연장명과 주소로 분리
    applyAddress(data) {
        // 선택 유형에 따라 비는 값이 있어 대체 주소까지 훑는다
        const addr = (data.userSelectedType === 'J')
            ? (data.jibunAddress || data.autoJibunAddress || data.roadAddress || data.address)
            : (data.roadAddress || data.autoRoadAddress || data.jibunAddress || data.address);

        document.getElementById('placeAddress').value =
            (data.zonecode ? '[' + data.zonecode + '] ' : '') + (addr || '');

        const place = document.getElementById('place');
        if (data.buildingName) {
            place.value = data.buildingName;
        }
        place.focus();
    },

    uploadPoster(file) {
        if (!file) return;
        const form = new FormData();
        form.append('file', file);

        $.ajax({
            url: '/shows/my/poster',
            method: 'POST',
            data: form,
            processData: false,
            contentType: false,
            success(res) {
                if (!res.success) {
                    com.alert(res.message || '업로드하지 못했습니다.');
                    return;
                }
                document.getElementById('posterLink').value = res.url;
                document.getElementById('posterThumb').innerHTML =
                    '<img src="' + res.url + '" alt="포스터 미리보기">';
                document.getElementById('btnPosterClear').hidden = false;
                pk.toast('포스터가 등록되었습니다.', 'ok');
            },
            error(xhr) { com.ajaxError(xhr); }
        });
    },

    clearPoster() {
        document.getElementById('posterLink').value = '';
        document.getElementById('posterFile').value = '';
        document.getElementById('posterThumb').innerHTML =
            '<span class="ph"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">' +
            '<rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="1.6"/><path d="M21 16l-5-5-6 6"/>' +
            '</svg></span>';
        document.getElementById('btnPosterClear').hidden = true;
    },

    dateRow(value) {
        const wrap = document.createElement('div');
        wrap.className = 'sw-row';
        wrap.innerHTML =
            '<input type="datetime-local" class="grow sw-date" aria-label="관람 회차 일시">' +
            '<button type="button" class="sw-del" aria-label="회차 삭제">' +
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>' +
            '</button>';
        wrap.querySelector('input').value = value || '';
        if (showAdmin.locked) {
            wrap.querySelectorAll('input, button').forEach(function (el) { el.disabled = true; });
        }
        return wrap;
    },

    gradeRow(g) {
        const wrap = document.createElement('div');
        wrap.className = 'sw-row';
        wrap.innerHTML =
            '<input type="text" class="w-grade sw-grade" placeholder="등급명 (예: VIP)" maxlength="20">' +
            '<input type="number" class="w-num sw-price" placeholder="가격" min="0" step="1000">' +
            '<input type="number" class="w-num sw-count" placeholder="좌석 수" min="1" max="500">' +
            '<span class="grow"></span>' +
            '<button type="button" class="sw-del" aria-label="등급 삭제">' +
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>' +
            '</button>';
        if (g) {
            wrap.querySelector('.sw-grade').value = g.gradeName || '';
            wrap.querySelector('.sw-price').value = g.price != null ? g.price : '';
            wrap.querySelector('.sw-count').value = g.seatCount != null ? g.seatCount : '';
        }
        if (showAdmin.locked) {
            wrap.querySelectorAll('input, button').forEach(function (el) { el.disabled = true; });
        }
        return wrap;
    },

    // 회차 수 × 등급별 좌석 수
    updateTotal() {
        const dates = document.querySelectorAll('#dateRows .sw-date').length;
        let perDate = 0;
        document.querySelectorAll('#gradeRows .sw-count').forEach(function (el) {
            perDate += Number(el.value) || 0;
        });
        const el = document.getElementById('seatTotal');
        el.innerHTML = (dates && perDate)
            ? '회차 <b>' + dates + '</b>개 × 회차당 <b>' + perDate + '</b>석 = 총 <b>' + (dates * perDate) + '</b>석이 만들어집니다.'
            : '회차와 좌석 등급을 입력하면 생성될 좌석 수가 표시됩니다.';
    },

    collect() {
        const showDates = [];
        document.querySelectorAll('#dateRows .sw-date').forEach(function (el) {
            if (el.value) showDates.push(el.value);
        });
        const grades = [];
        document.querySelectorAll('#gradeRows .sw-row').forEach(function (row) {
            const name = row.querySelector('.sw-grade').value.trim();
            if (!name) return;
            grades.push({
                gradeName: name,
                price: row.querySelector('.sw-price').value,
                seatCount: row.querySelector('.sw-count').value
            });
        });
        return { showDates: showDates, grades: grades };
    },

    save() {
        const v = id => document.getElementById(id).value.trim();
        if (!v('title')) { pk.toast('공연명을 입력해주세요', 'err'); document.getElementById('title').focus(); return; }
        if (!v('place')) { pk.toast('장소를 입력해주세요', 'err'); document.getElementById('place').focus(); return; }

        const picked = showAdmin.collect();
        if (!showAdmin.locked) {
            if (!picked.showDates.length) { pk.toast('관람 회차를 한 개 이상 등록해주세요', 'err'); return; }
            if (!picked.grades.length) { pk.toast('좌석 등급을 한 개 이상 등록해주세요', 'err'); return; }
        }

        const btn = document.getElementById('btnSave');
        btn.disabled = true;
        pk.busy(btn, true);

        $.ajax({
            url: '/shows/my/save',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                showId: v('showId'),
                title: v('title'),
                genre: v('genre'),
                place: v('place'),
                placeAddress: v('placeAddress'),
                host: v('host'),
                contact: v('contact'),
                ageLimit: v('ageLimit'),
                posterLink: v('posterLink'),
                openDate: v('openDate'),
                info: v('info'),
                showDates: picked.showDates,
                grades: picked.grades
            }),
            success(res) {
                if (res.success) {
                    com.alert('저장되었습니다.', function () { location.href = '/shows/my/list'; });
                } else {
                    btn.disabled = false;
                    pk.busy(btn, false);
                    com.alert(res.message || '저장하지 못했습니다.');
                }
            },
            error(xhr) {
                btn.disabled = false;
                pk.busy(btn, false);
                com.ajaxError(xhr);
            }
        });
    }
};

$(function () {
    const dateRows = document.getElementById('dateRows');
    const gradeRows = document.getElementById('gradeRows');

    <c:choose>
        <c:when test="${not empty showDates}">
            <c:forEach var="d" items="${showDates}">
    dateRows.appendChild(showAdmin.dateRow('<fmt:formatDate value="${d.showDate}" pattern="yyyy-MM-dd'T'HH:mm" />'));
            </c:forEach>
        </c:when>
        <c:otherwise>
    dateRows.appendChild(showAdmin.dateRow(''));
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${not empty grades}">
            <c:forEach var="g" items="${grades}">
    gradeRows.appendChild(showAdmin.gradeRow({ gradeName: '${fn:escapeXml(g.gradeName)}', price: ${g.price}, seatCount: ${g.seatCount} }));
            </c:forEach>
        </c:when>
        <c:otherwise>
    gradeRows.appendChild(showAdmin.gradeRow(null));
        </c:otherwise>
    </c:choose>

    document.getElementById('addDate').addEventListener('click', function () {
        dateRows.appendChild(showAdmin.dateRow(''));
        showAdmin.updateTotal();
    });
    document.getElementById('addGrade').addEventListener('click', function () {
        gradeRows.appendChild(showAdmin.gradeRow(null));
        showAdmin.updateTotal();
    });

    // 마지막 한 줄은 유지
    document.getElementById('showForm').addEventListener('click', function (e) {
        const del = e.target.closest('.sw-del');
        if (!del || del.disabled) return;
        const rows = del.closest('.sw-rows');
        if (rows.children.length <= 1) {
            pk.toast('최소 한 줄은 필요합니다.', 'err');
            return;
        }
        del.closest('.sw-row').remove();
        showAdmin.updateTotal();
    });

    document.getElementById('showForm').addEventListener('input', showAdmin.updateTotal);
    document.getElementById('btnSave').addEventListener('click', showAdmin.save);
    document.getElementById('posterFile').addEventListener('change', function () {
        showAdmin.uploadPoster(this.files[0]);
    });
    document.getElementById('btnPosterClear').addEventListener('click', showAdmin.clearPoster);
    showAdmin.updateTotal();
});
</script>
<%@include file="../com/footer.jsp"%>
