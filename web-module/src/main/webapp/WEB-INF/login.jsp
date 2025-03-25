<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0">Đăng Nhập</h4>
                </div>
                <div class="card-body">
                    <form
                            action="${pageContext.request.contextPath}/login"
                            method="post">
                        <!-- Username field -->
                        <div class="mb-3">
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
                        </div>

                        <!-- Password field -->
                        <div class="mb-3">
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
                        </div>

                        <!-- Submit button -->
                        <div class="d-grid">
                            <button
                                    type="submit"
                                    class="btn btn-primary">
                                Đăng nhập
                            </button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <p class="mb-0">
                        Chưa có tài khoản?
                        <a href="${pageContext.request.contextPath}/register"
                        >Đăng ký ngay</a
                        >
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>