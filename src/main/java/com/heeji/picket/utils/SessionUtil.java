package com.heeji.picket.utils;

import jakarta.servlet.http.HttpSession;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class SessionUtil {

    private SessionUtil() {
        // Prevent instantiation
    }

    public static Map<String, Object> getLoginUser(HttpSession session) {
        Map<String, Object> sessionMap = new HashMap<String, Object>();
        sessionMap.put("USER", session.getAttribute("USER"));
        sessionMap.put("LOGIN_EMAIL", session.getAttribute("LOGIN_EMAIL"));
        sessionMap.put("LOGIN_NAME", session.getAttribute("LOGIN_NAME"));
        sessionMap.put("LOGIN_ID", session.getAttribute("LOGIN_ID"));
        sessionMap.put("LOGIN_ROLE", session.getAttribute("LOGIN_ROLE"));
        sessionMap.put("LOGIN_TIME", session.getAttribute("LOGIN_TIME"));
        return sessionMap;
    }

    // 로그인 회원 고유번호, 없으면 null
    public static Long getLoginId(HttpSession session) {
        Object loginId = session.getAttribute("LOGIN_ID");
        if (loginId == null) {
            return null;
        }
        return Long.valueOf(loginId.toString());
    }

    // 로그인 이메일, 없으면 null
    public static String getLoginEmail(HttpSession session) {
        Object email = session.getAttribute("LOGIN_EMAIL");
        return email == null ? null : email.toString();
    }

    public static boolean isLogin(HttpSession session) {
        String email = getLoginEmail(session);
        return email != null && !email.isEmpty();
    }

    public static void setLoginUser(HttpSession session, Map<String, Object> map) {
        session.setAttribute("USER", map);
        session.setAttribute("LOGIN_NAME", map.get("name"));
        session.setAttribute("LOGIN_EMAIL", map.get("email"));
        session.setAttribute("LOGIN_ID", map.get("userId"));
        session.setAttribute("LOGIN_ROLE", map.get("role"));
        session.setAttribute("LOGIN_TIME", new Date());
    }

    public static void clearSession(HttpSession session) {
        session.invalidate();
    }

}
