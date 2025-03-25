<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
<!-- Navbar -->
<nav class="fs-navbar navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">FASHION <span>STYLE</span></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/home.jsp">Trang Chủ</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Quần</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Áo</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Phụ Kiện</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Giày</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <!-- Nếu chưa đăng nhập -->
                <c:if test="${empty sessionScope.user}">
                    <button class="btn btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#loginModal">Đăng Nhập</button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerModal">Đăng Ký</button>
                </c:if>

                <!-- Nếu đã đăng nhập -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="profile-icon">
                        <img src="https://cdn-icons-png.flaticon.com/512/6858/6858504.png" alt="Profile" class="avatar-img">
                        <span class="ms-2">${sessionScope.user.email}</span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger ms-2">Đăng Xuất</a>
                    </div>
                    <!-- Biểu tượng giỏ hàng -->
                    <div class="cart-icon">
                        <img src="https://cdn-icons-png.flaticon.com/512/263/263142.png" alt="Cart" class="cart-img">
                        <span class="cart-count" id="cartCount">0</span>
                    </div>
                </c:if>

        </div>
    </div>
    </div>
</nav>

<!-- Modals -->
<div id="modals">
    <!-- Modal Login -->
    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="loginModalLabel">Đăng Nhập Fashion Style</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/login"
                          method="post">
                        <div class="mb-3">
                            <label for="loginEmail" class="form-label">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="loginEmail" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="loginPassword" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="loginPassword" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Đăng Nhập</button>
                    </form>
                    <div class="text-center mt-3">
                        <a href="#" class="text-decoration-none">Quên mật khẩu?</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Register -->
    <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerModalLabel">Đăng Ký Fashion Style</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="registerForm"
                    action="${pageContext.request.contextPath}/register"
                    method="post">
                        <div class="mb-3">
                            <label for="registerEmail" class="form-label">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="registerEmail"  name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="registerPassword" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="registerPassword" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Đăng Ký</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
