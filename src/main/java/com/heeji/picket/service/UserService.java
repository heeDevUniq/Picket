package com.heeji.picket.service;

import com.heeji.picket.domain.User;
import com.heeji.picket.repository.UserRepository;
import lombok.extern.log4j.Log4j2;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Log4j2
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @Transactional
    public void register(Map<String, Object> params) {
        if (userRepository.info(params) != null) {
            log.debug("// 회원가입 실패, params : {}", params);
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");
        }
        // 비밀번호 암호화 후 저장
        params.put("password", encoder.encode(params.get("password").toString()));
        userRepository.insert(params);
        // save()는 void가 아니고 저장된 엔티티를 리턴하므로 insertNum 체크 필요 없음
    }

    public Map<String, Object> login(Map<String, Object> params) {
        HashMap<String, Object> info = userRepository.info(params);
        // email로 User 찾기
        if (info == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        if (!encoder.matches(params.get("password").toString(), info.get("password").toString())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        return info;
    }

    public HashMap<String, Object> info(Map<String, Object> params) {
        return userRepository.info(params);
    }

    @Transactional
    public void updatePassword(Map<String, Object> params) {
        String beforePassword = params.get("beforePassword").toString();
        String afterPassword = params.get("afterPassword").toString();
        HashMap<String, Object> info = userRepository.info(params);
        if (info == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        if (!encoder.matches(beforePassword, info.get("password").toString())) {
            log.error("// 비밀번호 변경 실패, params : {}", params);
            throw new RuntimeException("기존 비밀번호가 일치하지 않습니다.");
        }
        params.put("password", encoder.encode(afterPassword));
        userRepository.insert(params);
        log.info("// 비밀번호 변경 성공, params : {}", params);
    }

    @Transactional
    public void delete(Map<String, Object> params) {
        HashMap<String, Object> info = userRepository.info(params);
        if (info == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        if (!encoder.matches(params.get("password").toString(), info.get("password").toString())) {
            log.error("// 회원 삭제 실패, params : {}", params);
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }

        userRepository.delete(params);
        log.info("// 회원 삭제 성공, params : {}", params);
    }
}