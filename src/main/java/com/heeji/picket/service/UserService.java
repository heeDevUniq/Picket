package com.heeji.picket.service;

import com.heeji.picket.dto.UserDTO;
import org.apache.ibatis.annotations.Param;

public interface UserService {

    void register(UserDTO userDTO);

    UserDTO login(@Param("id") String id, @Param("password") String password);

    boolean isDuplicatedId(@Param("id") String id);

    UserDTO getUserInfo(@Param("id") String id);

    void updatePassword(@Param("id") String id, @Param("beforePassword") String beforePassword, @Param("afterPassword") String afterPassword);

    void deleteId(@Param("id") String id, @Param("password") String password);

}
