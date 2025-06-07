package com.heeji.picket.controller.api;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.heeji.picket.domain.User;
import com.heeji.picket.dto.request.UserDeleteRequest;
import com.heeji.picket.dto.request.UserLoginRequest;
import com.heeji.picket.dto.request.UserUpdateRequest;
import com.heeji.picket.dto.response.UserLoginResponse;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@RestController
@RequestMapping("/user/api")
@Log4j2
public class UserRestController {

    private final UserService userService;
    private static UserLoginResponse userLoginResponse;

    public UserRestController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/sign-up")
    @ResponseStatus(HttpStatus.CREATED)
    public void signUp(@RequestBody User user) {
        userService.register(user);
    }

    @PostMapping("/sign-in")
    public HttpStatus login(@RequestBody UserLoginRequest userLoginRequest, HttpSession session) {
        System.out.println("진입!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!userLoginRequest: " + userLoginRequest);
        ResponseEntity<UserLoginResponse> responseEntity = null;
        String userEmail = userLoginRequest.getEmail();
        String password = userLoginRequest.getPassword();
        User user = userService.login(userEmail, password);
        if (user != null) {
            SessionUtil.setLoginUser(session, user);
            userLoginResponse = UserLoginResponse.success(user);
            log.info("로그인 성공, user: {}", user);
            responseEntity = new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK);
        } else {
            log.error("로그인 실패, user: {}", user);
            return HttpStatus.NOT_FOUND;
        }
        return HttpStatus.OK;
    }

    @GetMapping("/my-info")
    public User memberInfo(HttpSession session) {
        String loginEmail = (String)SessionUtil.getLoginUser(session).get("LOGIN_EMAIL");
        return userService.findUser(loginEmail);
    }

    @PutMapping("/logout")
    public void logout(HttpSession session) {
        SessionUtil.clearSession(session);
    }

    @PatchMapping("/update")
    public ResponseEntity<UserLoginResponse> updatePassword(@RequestBody UserUpdateRequest userUpdateRequest, HttpSession session) {
        ResponseEntity<UserLoginResponse> resposneEntity = null;
        String userEmail = (String)SessionUtil.getLoginUser(session).get("LOGIN_EMAIL");
        String beforePassword = userUpdateRequest.getBeforePassword();
        String afterPassword = userUpdateRequest.getAfterPassword();
        try {
            userService.updatePassword(userEmail, beforePassword, afterPassword);
            resposneEntity.ok(new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK));
        } catch(IllegalArgumentException e) {
            log.error("updatePassword 실패, params : {}", userEmail, beforePassword, afterPassword);
            resposneEntity = new ResponseEntity<UserLoginResponse>(HttpStatus.BAD_REQUEST);
        }
        return resposneEntity;
    }

    @DeleteMapping
    public ResponseEntity<UserLoginResponse> delete(@RequestBody UserDeleteRequest userDeleteRequest, HttpSession session) {
        ResponseEntity<UserLoginResponse> resposneEntity = null;
        String userEmail = userDeleteRequest.getUserEmail();
        try {
            userService.delete(userEmail, userDeleteRequest.getPassword());
            resposneEntity = new ResponseEntity<UserLoginResponse>(userLoginResponse, HttpStatus.OK);
        } catch(RuntimeException e) {
            log.error("회원 삭제 실패, params : {}", userEmail, userDeleteRequest.getPassword());
            resposneEntity = new ResponseEntity<UserLoginResponse>(HttpStatus.BAD_REQUEST);
        }
        SessionUtil.clearSession(session);
        return resposneEntity;
    }

    @GetMapping("/kakaoLogin")
    public void kakaoLogin(@RequestParam String code, HttpSession session, HttpServletResponse response) throws Exception {
        System.out.println("진입!!!!!!!!!!!!!!!!!! : " + code);
//        String redirectUrl = "redirect:/index";

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
            System.out.println("token : " + accessToken);
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

            System.out.println("jsonNode : " + jsonNode.toString());

            // 카카오 사용자 정보 파싱
            String email = jsonNode.get("kakao_account").get("email").asText();

            // 3. DB 조회 후 로그인 or 회원가입
            User user = userService.findUser(email);
            if (user != null) {
                // 4. 세션 저장
                user = userService.findUser(email);
                SessionUtil.setLoginUser(session, user);
                System.out.println("!!!!!!!!!!!!!!!!!!!1 user 값 있음 성공: " + user);
                System.out.println("!!!!!!!!!!!!!!!!!!!1 user 값 있음 성공: " + session);
                response.sendRedirect("/index");
            } else {
                System.out.println("!!!!!!!!!!!!!!!!!!!1 user 값 없음 성공: " + user);
                System.out.println("!!!!!!!!!!!!!!!!!!!1 user 값 없음 성공: " + session);
                user = new User();
                user.setEmail(email);
                SessionUtil.setLoginUser(session, user);
                response.sendRedirect("/signup");
//                redirectUrl = "redirect:/signup";
            }
        } else {
            throw new RuntimeException("사용자 정보 요청 실패: " + res.body());
        }

        // 5. 리다이렉트
//        return redirectUrl;
    }

}
