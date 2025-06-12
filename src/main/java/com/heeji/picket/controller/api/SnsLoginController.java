package com.heeji.picket.controller.api;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.heeji.picket.domain.User;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user/api")
public class SnsLoginController {

    private final UserService userService;

    public SnsLoginController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/kakaoLogin")
    public String kakaoLogin(@RequestParam String code, HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
        // 1. code 로 access_token 요청
        String tokenUrl = "https://kauth.kakao.com/oauth/token";

        HttpClient tokenClient = HttpClient.newHttpClient();

        String form = "grant_type=authorization_code"
                + "&client_id=" + URLEncoder.encode("0ed4893e99b41c7e2c03e73937596f51", "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode("http://localhost:8080/user/api/kakaoLogin", "UTF-8")
                + "&code=" + URLEncoder.encode(code, "UTF-8");

        HttpRequest tokenRequest = HttpRequest.newBuilder()
                .uri(URI.create(tokenUrl))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(form))
                .build();

        HttpResponse<String> tokenResponse = tokenClient.send(tokenRequest, HttpResponse.BodyHandlers.ofString());

        String accessToken = "";

        if (tokenResponse.statusCode() == 200) {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(tokenResponse.body());
            accessToken = jsonNode.get("access_token").asText();
        } else {
            throw new RuntimeException("토큰 요청 실패: " + tokenResponse.body());
        }

        // 2. access_token 으로 사용자 정보 요청
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

        HttpClient userClient = HttpClient.newHttpClient();

        HttpRequest userRequest = HttpRequest.newBuilder()
                .uri(URI.create(userInfoUrl))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();

        HttpResponse<String> res = userClient.send(userRequest, HttpResponse.BodyHandlers.ofString());

        if (res.statusCode() == 200) {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(res.body());
            String email = jsonNode.get("kakao_account").get("email").asText();

            // 3. DB 조회 후 로그인 or 회원가입
            User user = userService.findUser(email);
            if (user != null) {
                // 4. 세션 저장
                user = userService.findUser(email);
                SessionUtil.setLoginUser(session, user);
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/index";
            } else {
                redirectAttributes.addFlashAttribute("email", email);
                redirectAttributes.addFlashAttribute("alertMsg", "회원정보를 찾을 수 없어 회원가입 페이지로 이동합니다.");
            }
        } else {
            redirectAttributes.addFlashAttribute("alertMsg", "회원정보를 찾을 수 없어 회원가입 페이지로 이동합니다.");
            throw new RuntimeException("사용자 정보 요청 실패: " + res.body());
        }
        return "redirect:/signup";
    }

    @RequestMapping("/googleLogin")
    @ResponseBody
    public Map<String, Object> googleLogin(@RequestBody Map<String, String> body, HttpSession session) throws Exception {
        Map<String, Object> returnMap = new HashMap<>();
        String accessToken = body.get("credential");

        // 1. access_token 으로 사용자 정보 요청
        HttpRequest userInfoRequest = HttpRequest.newBuilder()
                .uri(URI.create("https://www.googleapis.com/oauth2/v3/userinfo"))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = client.send(userInfoRequest, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode userInfo = mapper.readTree(response.body());
            String email = userInfo.get("email").asText();

            // 2. DB 조회 후 로그인 or 회원가입
            User user = userService.findUser(email);
            if (user != null) {
                // 3. 세션 저장
                user = userService.findUser(email);
                SessionUtil.setLoginUser(session, user);
                returnMap.put("returnUrl", "/index");
            } else {
                returnMap.put("email", email);
                returnMap.put("alertMsg", "회원정보를 찾을 수 없어 회원가입 페이지로 이동합니다.");
                returnMap.put("returnUrl", "/signup");
            }
        } else {
            returnMap.put("alertMsg", "회원정보를 찾을 수 없어 회원가입 페이지로 이동합니다.");
            returnMap.put("returnUrl", "/signup");
            throw new RuntimeException("사용자 정보 요청 실패: " + response.body());
        }
        return returnMap;
    }

}