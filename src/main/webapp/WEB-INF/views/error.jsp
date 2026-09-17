<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="./com/header.jsp"%>
<style>
.err-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    min-height: 58vh;
    padding: 60px 20px 90px;
}

.err-code {
    font-family: var(--pk-font-ui);
    font-size: 84px;
    font-weight: 800;
    line-height: 1;
    letter-spacing: -.04em;
    color: var(--pk-accent);
}

.err-ico {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 64px;
    height: 64px;
    margin-bottom: 22px;
    border-radius: 18px;
    background: var(--pk-accent-soft);
    color: var(--pk-accent);
}
.err-ico svg { width: 30px; height: 30px; }

.err-title {
    margin: 18px 0 0;
    font-family: var(--pk-font-ui);
    font-size: 24px;
    font-weight: 700;
    letter-spacing: -.02em;
    color: var(--pk-ink);
}

.err-desc {
    margin: 10px 0 0;
    font-size: 15px;
    line-height: 1.65;
    color: var(--pk-muted);
}

.err-path {
    margin-top: 16px;
    padding: 7px 14px;
    border: 1px solid var(--pk-line);
    border-radius: 999px;
    background: var(--pk-bg-soft);
    font-size: 12.5px;
    color: #8A9099;
    word-break: break-all;
}

.err-btns { display: flex; gap: 10px; margin-top: 30px; flex-wrap: wrap; justify-content: center; }

.err-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    height: 46px;
    padding: 0 26px;
    border: 1px solid var(--pk-line);
    border-radius: 11px;
    background: var(--pk-surface);
    color: var(--pk-ink);
    font-family: var(--pk-font-ui);
    font-size: 14.5px;
    font-weight: 700;
    cursor: pointer;
    transition: background var(--pk-fast) var(--pk-ease), border-color var(--pk-fast) var(--pk-ease);
}
.err-btn:hover { background: var(--pk-bg-soft); }

.err-btn--main {
    border-color: var(--pk-accent);
    background: var(--pk-accent);
    color: #fff;
}
.err-btn--main:hover { background: var(--pk-accent-dark); border-color: var(--pk-accent-dark); }

.err-links { margin-top: 26px; font-size: 13.5px; color: #98A0AD; }
.err-links a { color: var(--pk-muted); }
.err-links a:hover { color: var(--pk-accent); text-decoration: underline; }
.err-links span { margin: 0 8px; color: var(--pk-line); }

@media (max-width: 768px) {
    .err-wrap { min-height: 52vh; padding: 44px 16px 70px; }
    .err-code { font-size: 62px; }
    .err-title { font-size: 20px; }
    .err-desc { font-size: 14px; }
    .err-btns { width: 100%; }
    .err-btn { flex: 1; min-width: 132px; }
}
</style>

<div class="container">
    <main class="main-content">
        <div class="err-wrap">

            <c:choose>
                <%-- 없는 주소 --%>
                <c:when test="${status == 404}">
                    <div class="err-ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <circle cx="11" cy="11" r="7"/><path d="M20 20l-3.6-3.6"/>
                        </svg>
                    </div>
                    <div class="err-code">404</div>
                    <h2 class="err-title">페이지를 찾을 수 없어요</h2>
                    <p class="err-desc">
                        주소가 바뀌었거나 삭제된 페이지입니다.<br>
                        입력하신 주소가 맞는지 확인해주세요.
                    </p>
                </c:when>

                <%-- 권한 없음 --%>
                <c:when test="${status == 401 or status == 403}">
                    <div class="err-ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <rect x="4" y="10" width="16" height="10" rx="2"/>
                            <path d="M8 10V7a4 4 0 0 1 8 0v3"/>
                        </svg>
                    </div>
                    <div class="err-code">${status}</div>
                    <h2 class="err-title">접근 권한이 없어요</h2>
                    <p class="err-desc">
                        로그인이 필요하거나, 이 페이지를 볼 수 있는 권한이 없습니다.
                    </p>
                </c:when>

                <%-- 서버 문제 --%>
                <c:when test="${status >= 500}">
                    <div class="err-ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M12 9v4"/><path d="M12 17h.01"/>
                            <path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z"/>
                        </svg>
                    </div>
                    <div class="err-code">${status}</div>
                    <h2 class="err-title">잠시 문제가 생겼어요</h2>
                    <p class="err-desc">
                        서버에서 요청을 처리하지 못했습니다.<br>
                        잠시 후 다시 시도해주세요.
                    </p>
                </c:when>

                <%-- 나머지 --%>
                <c:otherwise>
                    <div class="err-ico">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <circle cx="12" cy="12" r="9"/><path d="M12 8v5"/><path d="M12 16h.01"/>
                        </svg>
                    </div>
                    <div class="err-code">${empty status ? '오류' : status}</div>
                    <h2 class="err-title">요청을 처리하지 못했어요</h2>
                    <p class="err-desc">
                        예상하지 못한 문제가 발생했습니다.<br>
                        잠시 후 다시 시도해주세요.
                    </p>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty path}">
                <div class="err-path">${fn:escapeXml(path)}</div>
            </c:if>

            <div class="err-btns">
                <button type="button" class="err-btn" onclick="history.back();">이전 페이지</button>
                <a href="/index" class="err-btn err-btn--main">메인으로</a>
            </div>

            <p class="err-links">
                <a href="/notice">공지사항</a>
                <span>|</span>
                <a href="/open">예매오픈안내</a>
                <span>|</span>
                <a href="mailto:picket.help@email.com">문의하기</a>
            </p>

        </div>
    </main>
</div>
<%@include file="./com/footer.jsp"%>
