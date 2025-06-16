package com.heeji.picket.utils;

import com.heeji.picket.domain.User;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class SessionUtil {

    private static final String ROLE = "user";

    private SessionUtil() {
        // Prevent instantiation
    }

    @ModelAttribute("session")
    public static Map<String, Object> getLoginUser(HttpSession session) {
        Map<String, Object> sessionMap = new HashMap<String, Object>();
        sessionMap.put("LOGIN_EMAIL", session.getAttribute("LOGIN_EMAIL"));
        sessionMap.put("LOGIN_ID", session.getAttribute("LOGIN_ID"));
        sessionMap.put("LOGIN_ROLE", session.getAttribute("LOGIN_ROLE"));
        sessionMap.put("LOGIN_TIME", session.getAttribute("LOGIN_TIME"));
        return sessionMap;
    }

    public static void setLoginUser(HttpSession session, User user) {
        session.setAttribute("LOGIN_EMAIL", user.getEmail());
        session.setAttribute("LOGIN_ID", user.getUserId());
        session.setAttribute("LOGIN_ROLE", user.getRole());
        session.setAttribute("LOGIN_TIME", new Date());
    }

    public static void clearSession(HttpSession session) {
        session.invalidate();
    }

}
