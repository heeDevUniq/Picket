package com.heeji.picket.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.heeji.picket.mapper.UserMapper;

@Service
public class UserService {

    @Autowired
    private UserMapper userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @Transactional
    public void register(Map<String, Object> params) {
        String email = str(params.get("email"));
        String password = str(params.get("password"));
        if (email.isEmpty()) {
            throw new IllegalArgumentException("이메일은 필수입니다.");
        }
        if (password.isEmpty()) {
            throw new IllegalArgumentException("비밀번호는 필수입니다.");
        }
        if (userRepository.info(params) != null) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");
        }
        params.put("password", encoder.encode(password));
        userRepository.insert(params);
    }

    public Map<String, Object> login(Map<String, Object> params) {
        Map<String, Object> info = userRepository.info(params);
        if (info == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        if (!encoder.matches(str(params.get("password")), str(info.get("password")))) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        return info;
    }

    public Map<String, Object> info(Map<String, Object> params) {
        return userRepository.info(params);
    }

    @Transactional
    public void updatePassword(Map<String, Object> params) {
        String beforePassword = str(params.get("beforePassword"));
        String afterPassword = str(params.get("afterPassword"));
        if (afterPassword.isEmpty()) {
            throw new IllegalArgumentException("변경할 비밀번호를 입력해주세요.");
        }
        Map<String, Object> info = userRepository.info(params);
        if (info == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        if (!encoder.matches(beforePassword, str(info.get("password")))) {
            throw new IllegalArgumentException("기존 비밀번호가 일치하지 않습니다.");
        }
        params.put("password", encoder.encode(afterPassword));
        userRepository.update(params);
    }

    // 비밀번호를 제외한 프로필 저장
    @Transactional
    public void updateProfile(Map<String, Object> params) {
        if (userRepository.info(params) == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        userRepository.update(params);
    }

    @Transactional
    public void delete(Map<String, Object> params) {
        Map<String, Object> info = userRepository.info(params);
        if (info == null) {
            throw new IllegalArgumentException("존재하지 않는 사용자입니다.");
        }
        if (!encoder.matches(str(params.get("password")), str(info.get("password")))) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        userRepository.delete(params);
    }

    private String str(Object value) {
        return value == null ? "" : value.toString();
    }
}
