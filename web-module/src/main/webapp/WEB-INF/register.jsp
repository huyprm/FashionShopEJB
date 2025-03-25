<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0">Đăng Ký Tài Khoản</h4>
                </div>
                <div class="card-body">
                    <form
                            action="${pageContext.request.contextPath}/register"
                            method="post"
                            class="needs-validation"
                            novalidate>
                        <div class="row">
                            <!-- Username field -->
                            <div class="col-md-6 mb-3">
                                <label
                                        for="username"
                                        class="form-label"
                                >Tên đăng nhập</label
                                >
                                <input
                                        type="text"
                                        class="form-control"
                                        id="username"
                                        name="username"
                                        required />
                                <div class="invalid-feedback">
                                    Vui lòng nhập tên đăng nhập
                                </div>
                            </div>

                            <!-- Full name field -->
                            <div class="col-md-6 mb-3">
                                <label
                                        for="fullName"
                                        class="form-label"
                                >Họ và tên</label
                                >
                                <input
                                        type="text"
                                        class="form-control"
                                        id="fullName"
                                        name="fullName"
                                        required />
                                <div class="invalid-feedback">
                                    Vui lòng nhập họ và tên
                                </div>
                            </div>

                            <!-- Password field -->
                            <div class="col-md-6 mb-3">
                                <label
                                        for="password"
                                        class="form-label"
                                >Mật khẩu</label
                                >
                                <input
                                        type="password"
                                        class="form-control"
                                        id="password"
                                        name="password"
                                        required />
                                <div class="invalid-feedback">
                                    Vui lòng nhập mật khẩu
                                </div>
                            </div>

                            <!-- Confirm password field -->
                            <div class="col-md-6 mb-3">
                                <label
                                        for="confirmPassword"
                                        class="form-label"
                                >Xác nhận mật khẩu</label
                                >
                                <input
                                        type="password"
                                        class="form-control"
                                        id="confirmPassword"
                                        name="confirmPassword"
                                        required />
                                <div class="invalid-feedback">
                                    Mật khẩu không khớp
                                </div>
                            </div>

                            <!-- Email field -->
                            <div class="col-md-6 mb-3">
                                <label
                                        for="email"
                                        class="form-label"
                                >Email</label
                                >
                                <input
                                        type="email"
                                        class="form-control"
                                        id="email"
                                        name="email"
                                        required />
                                <div class="invalid-feedback">
                                    Vui lòng nhập email hợp lệ
                                </div>
                            </div>

                            <!-- Phone field -->
                            <div class="col-md-6 mb-3">
                                <label
                                        for="phone"
                                        class="form-label"
                                >Số điện thoại</label
                                >
                                <input
                                        type="tel"
                                        class="form-control"
                                        id="phone"
                                        name="phone"
                                        required />
                                <div class="invalid-feedback">
                                    Vui lòng nhập số điện thoại
                                </div>
                            </div>

                            <!-- Address field -->
                            <div class="col-12 mb-3">
                                <label
                                        for="address"
                                        class="form-label"
                                >Địa chỉ</label
                                >
                                <textarea
                                        class="form-control"
                                        id="address"
                                        name="address"
                                        rows="3"
                                        required></textarea>
                                <div class="invalid-feedback">
                                    Vui lòng nhập địa chỉ
                                </div>
                            </div>
                        </div>

                        <!-- Submit button -->
                        <div class="d-grid">
                            <button
                                    type="submit"
                                    class="btn btn-primary">
                                Đăng ký
                            </button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <p class="mb-0">
                        Đã có tài khoản?
                        <a href="${pageContext.request.contextPath}/login"
                        >Đăng nhập</a
                        >
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Form validation
    (function () {
        'use strict';
        var forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener(
                'submit',
                function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }

                    // Check if passwords match
                    var password = document.getElementById('password');
                    var confirmPassword =
                        document.getElementById('confirmPassword');
                    if (password.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity(
                            'Passwords do not match'
                        );
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        confirmPassword.setCustomValidity('');
                    }

                    form.classList.add('was-validated');
                },
                false
            );
        });
    })();
</script>

<%@ include file="/WEB-INF/common/footer.jsp" %>