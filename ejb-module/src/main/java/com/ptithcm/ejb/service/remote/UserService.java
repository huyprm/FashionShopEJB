package com.ptithcm.ejb.service.remote;

import com.ptithcm.ejb.entity.Role;
import com.ptithcm.ejb.entity.User;
import com.ptithcm.ejb.enums.AccountStatusEnum;
import com.ptithcm.ejb.enums.RoleEnum;
import com.ptithcm.ejb.service.AuthenticationServiceRemote;
import com.ptithcm.ejb.service.UserServiceRemote;
import com.ptithcm.ejb.utils.PasswordUtil;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import org.mindrot.jbcrypt.BCrypt;

import java.util.ArrayList;
import java.util.List;

import static com.ptithcm.ejb.utils.PasswordUtil.hashPassword;

@Stateless
public class UserService implements UserServiceRemote {

    @PersistenceContext
    private EntityManager entityManager;


    @EJB
    private AuthenticationServiceRemote authenticationService;


    @Override
    public User createUser(String email, String password, String fullName) {
        User user = new User();

        user.setEmail(email);
        user.setPassword(hashPassword(password));
        user.setFullName(fullName);

        entityManager.persist(user);
        return user;
    }

    @Override
    public void updateUser(User user) throws Exception {
        User existingUser = entityManager.find(User.class, user.getId());
        if (existingUser == null) {
            throw new Exception("User not found");
        }

        // If password is empty, keep the old password
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            user.setPassword(existingUser.getPassword());
        } else {
            user.setPassword(hashPassword(user.getPassword()));
        }

        entityManager.merge(user);
    }

    @Override
    public void deleteUser(String id) throws Exception {
        User user = entityManager.find(User.class, id);
        if (user == null) {
            throw new Exception("User not found");
        }
        user.setStatus(AccountStatusEnum.CANCELED);
        entityManager.merge(user);
    }

    @Override
    public User getUser(String id) throws Exception {
        User user = entityManager.find(User.class, id);
        if (user == null) {
            throw new Exception("User not found");
        }
        return user;
    }

    @Override
    public List<User> getAllUsers() {

        return entityManager.createQuery("SELECT u FROM users u", User.class).getResultList();
    }
}




