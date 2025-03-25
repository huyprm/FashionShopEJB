package com.ptithcm.ejb.service;

import com.ptithcm.ejb.entity.User;
import jakarta.ejb.Remote;
import java.util.List;

@Remote
public interface UserServiceRemote {
    User createUser(String email, String password, String fullName);
    void updateUser(User user) throws Exception;
    void deleteUser(String id) throws Exception;
    User getUser(String id) throws Exception;
    List<User> getAllUsers();
    //String changePassword(UserChangePasswordRequest userChangePasswordRequest, String id);
    //void changeRoleUser(String id, String roleId);
}
