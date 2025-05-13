package com.heeji.picket.mapper;

import com.heeji.picket.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

@Mapper
public interface UserProfileMapper {

    public UserDTO getUserProfile(@Param("id") String id);

    int insertUserProfile(UserDTO userDTO);

    int deleteUserProfile(UserDTO userDTO);

    public UserDTO findByIdAndPassword(@Param("id") String id, @Param("password") String password);

    boolean isCheck(@Param("id") String id);

    public int updateProfile(UserDTO userDTO);

}
