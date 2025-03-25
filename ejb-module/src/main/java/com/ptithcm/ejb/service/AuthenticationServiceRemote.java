package com.ptithcm.ejb.service;

import com.ptithcm.ejb.entity.User;
import jakarta.ejb.Remote;

@Remote
public interface AuthenticationServiceRemote {
    User login(String username, String password) throws Exception;
}

