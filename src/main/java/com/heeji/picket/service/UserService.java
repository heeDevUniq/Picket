package com.heeji.picket.service;

import com.heeji.picket.domain.User;
import com.heeji.picket.repository.UserRepository;
import lombok.extern.log4j.Log4j2;
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
    public void register(User user) {
        // Optional<User>로 반환되니까 ifPresent 대신 isPresent 써서 체크
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            log.debug("// 회원가입 실패, params : {}", user);
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");
        }
        // 비밀번호 암호화 후 저장
        user.setPassword(encoder.encode(user.getPassword()));
        userRepository.save(user);
        // save()는 void가 아니고 저장된 엔티티를 리턴하므로 insertNum 체크 필요 없음
        log.info("// 회원가입 성공, params : {}", user);
    }

    public User login(String email, String password) {
        // email로 User 찾기
        User user = userRepository.findByEmail(email).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));
        if (!encoder.matches(password, user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        // UserLoginResponse를 UserDTO의 하위 클래스로 가정
        return user;
    }

    public User findUser(String email) {
        User user = userRepository.findByEmail(email).orElseGet(() -> {
            return null;
        });
        return user;
    }

    @Transactional
    public void updatePassword(String email, String beforePassword, String afterPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));
        if (!encoder.matches(beforePassword, user.getPassword())) {
            log.error("// 비밀번호 변경 실패, params : {}", email);
            throw new RuntimeException("기존 비밀번호가 일치하지 않습니다.");
        }
        user.setPassword(encoder.encode(afterPassword));
        userRepository.save(user);
        log.info("// 비밀번호 변경 성공, params : {}", email);
    }

    @Transactional
    public void delete(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        if (!encoder.matches(password, user.getPassword())) {
            log.error("// 회원 삭제 실패, params : {}", email);
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }

        userRepository.delete(user);
        log.info("// 회원 삭제 성공, params : {}", email);
    }
}