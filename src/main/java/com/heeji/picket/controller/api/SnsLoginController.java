package com.heeji.picket.controller.api;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.heeji.picket.service.UserService;
import com.heeji.picket.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.beans.factory.annotation.Value;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user/api")
public class SnsLoginController {

    private static final Logger logger = LoggerFactory.getLogger(SnsLoginController.class);

    private final UserService userService;

    @Value("${picket.oauth.kakao.client-id:}")
    private String kakaoClientId;

    @Value("${picket.oauth.kakao.redirect-uri:}")
    private String kakaoRedirectUri;

    public SnsLoginController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/kakaoLogin")
    public String kakaoLogin(@RequestParam("code") String code, HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
        // code -> access_token
        String tokenUrl = "https://kauth.kakao.com/oauth/token";

        HttpClient tokenClient = HttpClient.newHttpClient();

        String form = "grant_type=authorization_code"
                + "&client_id=" + URLEncoder.encode(kakaoClientId, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(kakaoRedirectUri, StandardCharsets.UTF_8)
                + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8);

        HttpRequest tokenRequest = HttpRequest.newBuilder()
                .uri(URI.create(tokenUrl))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(form))
                .build();

        HttpResponse<String> tokenResponse = tokenClient.send(tokenRequest, HttpResponse.BodyHandlers.ofString());

        if (tokenResponse.statusCode() != 200) {
            logger.error("카카오 토큰 요청 실패, status : {}", tokenResponse.statusCode());
            redirectAttributes.addFlashAttribute("alertMsg", "카카오 로그인에 실패하였습니다. 잠시 후 다시 시도해주세요.");
            return "redirect:/login";
        }

        ObjectMapper mapper = new ObjectMapper();
        String accessToken = mapper.readTree(tokenResponse.body()).path("access_token").asText();

        // access_token -> 사용자 정보
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

        HttpClient userClient = HttpClient.newHttpClient();

        HttpRequest userRequest = HttpRequest.newBuilder()
                .uri(URI.create(userInfoUrl))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();

        HttpResponse<String> res = userClient.send(userRequest, HttpResponse.BodyHandlers.ofString());

        if (res.statusCode() != 200) {
            logger.error("카카오 사용자 정보 요청 실패, status : {}", res.statusCode());
            redirectAttributes.addFlashAttribute("alertMsg", "카카오 사용자 정보를 가져오지 못했습니다.");
            return "redirect:/login";
        }

        JsonNode jsonNode = mapper.readTree(res.body());
        String email = jsonNode.path("kakao_account").path("email").asText(null);
        if (email == null || email.isEmpty()) {
            redirectAttributes.addFlashAttribute("alertMsg", "카카오 계정의 이메일 제공에 동의해야 로그인할 수 있습니다.");
            return "redirect:/login";
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("email", email);

        // 가입 이력 있으면 로그인, 없으면 회원가입으로
        Map<String, Object> info = userService.info(map);
        if (info != null) {
            String returnUrl = SessionUtil.popReturnUrl(session);
            SessionUtil.setLoginUser(session, info);
            return "redirect:" + returnUrl;
        }

        redirectAttributes.addFlashAttribute("email", email);
        redirectAttributes.addFlashAttribute("providerType", "kakao");
        redirectAttributes.addFlashAttribute("alertMsg", "회원정보를 찾을 수 없어 회원가입 페이지로 이동합니다.");
        return "redirect:/signup";
    }

    @RequestMapping("/googleLogin")
    @ResponseBody
    public Map<String, Object> googleLogin(@RequestBody Map<String, String> body, HttpSession session) throws Exception {
        Map<String, Object> returnMap = new HashMap<>();
        String accessToken = body.get("credential");

        // access_token -> 사용자 정보
        HttpRequest userInfoRequest = HttpRequest.newBuilder()
                .uri(URI.create("https://www.googleapis.com/oauth2/v3/userinfo"))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = client.send(userInfoRequest, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            logger.error("구글 사용자 정보 요청 실패, status : {}", response.statusCode());
            returnMap.put("alertMsg", "구글 사용자 정보를 가져오지 못했습니다.");
            returnMap.put("returnUrl", "/login");
            return returnMap;
        }

        ObjectMapper mapper = new ObjectMapper();
        JsonNode userInfo = mapper.readTree(response.body());
        String email = userInfo.path("email").asText(null);
        if (email == null || email.isEmpty()) {
            returnMap.put("alertMsg", "구글 계정의 이메일을 확인할 수 없습니다.");
            returnMap.put("returnUrl", "/login");
            return returnMap;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("email", email);

        // 가입 이력 있으면 로그인, 없으면 회원가입으로
        Map<String, Object> info = userService.info(map);
        if (info != null) {
            String returnUrl = SessionUtil.popReturnUrl(session);
            SessionUtil.setLoginUser(session, info);
            returnMap.put("returnUrl", returnUrl);
        } else {
            returnMap.put("email", email);
            returnMap.put("providerType", "google");
            returnMap.put("alertMsg", "회원정보를 찾을 수 없어 회원가입 페이지로 이동합니다.");
            returnMap.put("returnUrl", "/signup");
        }
        return returnMap;
    }

}
