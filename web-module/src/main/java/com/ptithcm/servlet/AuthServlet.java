package com.ptithcm.servlet;

import com.ptithcm.ejb.entity.User;
import com.ptithcm.ejb.service.AuthenticationServiceRemote;
import com.ptithcm.ejb.service.UserServiceRemote;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    @EJB
    private AuthenticationServiceRemote authenticationService;

    @EJB
    private UserServiceRemote userService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            // Handle logout
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Forward to appropriate JSP
        String jspPath = "/login".equals(path) ? "/WEB-INF/home.jsp" : "/WEB-INF/register.jsp";
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            if ("/login".equals(path)) {
                handleLogin(request, response);
            } else if ("/register".equals(path)) {
                handleRegister(request, response);}
//            } else {
//                response.sendError(HttpServletResponse.SC_NOT_FOUND);
//            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            throw new Exception("Username and password are required");
        }

        // Attempt login
        User user = authenticationService.login(username, password);

        // Create session and store user
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");


        // Validate input
        if (password == null || confirmPassword == null || email == null|| password.trim().isEmpty() ||
                confirmPassword.trim().isEmpty() ||
                email.trim().isEmpty() ) {
            throw new Exception("All fields are required");
        }

        if (!password.equals(confirmPassword)) {
            throw new Exception("Passwords do not match");
        }

        // Register user
        User user = userService.createUser(email, password, email);

        // Create session and store user
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }
}

