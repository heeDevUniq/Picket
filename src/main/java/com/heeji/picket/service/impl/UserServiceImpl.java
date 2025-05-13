package com.heeji.picket.service.impl;

import com.heeji.picket.dto.UserDTO;
import com.heeji.picket.mapper.UserProfileMapper;
import com.heeji.picket.service.UserService;
import com.heeji.picket.service.exception.DuplicateIdException;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

import static com.heeji.picket.utils.SHA256Util.encryptSHA256;

@Service
@Log4j2
public class UserServiceImpl implements UserService {

    @Autowired
    private UserProfileMapper userProfileMapper;

    @Override
    public void register(UserDTO userDTO) {
        boolean duplIdResult = isDuplicatedId(userDTO.getUserId());
        if (duplIdResult) {
            throw new DuplicateIdException("중복된 아이디입니다.");
        }
        userDTO.setCreateTime(new Date());
        userDTO.setPassword(encryptSHA256(userDTO.getPassword()));
        int insertNum = userProfileMapper.insertUserProfile(userDTO);
        if (insertNum != 1) {
            log.debug("// 회원가입 실패, params : {}", userDTO);
            throw new RuntimeException("회원가입 실패, params : " + userDTO);
        }
    }

    @Override
    public UserDTO login(String id, String password) {
        String cryptoPassword = encryptSHA256(password);
        return userProfileMapper.findByIdAndPassword(id, password);
    }

    @Override
    public boolean isDuplicatedId(String id) {
        return userProfileMapper.isCheck(id);
    }

    @Override
    public UserDTO getUserInfo(String id) {
        return userProfileMapper.getUserProfile(id);
    }

    @Override
    public void updatePassword(String id, String beforePassword, String afterPassword) {
        String cryptoPassword = encryptSHA256(beforePassword);
        UserDTO userInfo = userProfileMapper.findByIdAndPassword(id, beforePassword);
        if (userInfo != null) {
            userProfileMapper.updateProfile(id, afterPassword);
        } else {
            log.error("// 비밀번호 변경 실패, params : {}", id, beforePassword, afterPassword);
            throw new RuntimeException("비밀번호 변경 실패, params : " + id + " / " + beforePassword + " / " + afterPassword);
        }
    }

    @Override
    public void deleteId(String id, String password) {
        String cryptoPassword = encryptSHA256(password);
        UserDTO userInfo = userProfileMapper.findByIdAndPassword(id, password);
        if (userInfo != null) {
            userProfileMapper.deleteUserProfile(id, password);
        } else {
            log.error("//회원 삭제 실패, params : {}", id, password);
            throw new RuntimeException("회원정보 삭제 실패, params : " + id + " / " + password);
        }
    }
}
