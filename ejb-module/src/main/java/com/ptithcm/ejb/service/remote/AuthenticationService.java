package com.ptithcm.ejb.service.remote;

import com.ptithcm.ejb.entity.User;
import com.ptithcm.ejb.enums.AccountStatusEnum;
import com.ptithcm.ejb.service.AuthenticationServiceRemote;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;


import org.mindrot.jbcrypt.BCrypt;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;


@Stateless
public class AuthenticationService implements AuthenticationServiceRemote {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public User login( String username, String password) throws Exception {
        String emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        User user = null;

        try {
            TypedQuery<User> query;
            if (username.matches(emailRegex)) {
                query = entityManager.createQuery("SELECT u FROM users  u WHERE u.email = :username", User.class);
            } else {
                query = entityManager.createQuery("SELECT u FROM users u WHERE u.phone = :username", User.class);
            }

            user = query.getSingleResult();
        } catch (NoResultException e) {
            throw new Exception(" username không tồn tại");
        }

        // Sử dụng jBCrypt thay vì PasswordEncoder của Spring
        if (!BCrypt.checkpw(password, user.getPassword())) {
            throw new Exception(" Wrongpass word");
        }

        return user;
    }

}
