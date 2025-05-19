package com.heeji.picket.mapper;

import com.heeji.picket.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserProfileMapper {

    public UserDTO getUserProfile(@Param("userId") String userId);

    int insertUserProfile(UserDTO userDTO);

    public UserDTO findByIdAndPassword(@Param("userId") String userId, @Param("password") String password);

    int idCheck(@Param("id") String id);

    public int updateUserProfile(UserDTO userDTO);

    int deleteUserProfile(@Param("userId") String userId, @Param("password") String password);

}
