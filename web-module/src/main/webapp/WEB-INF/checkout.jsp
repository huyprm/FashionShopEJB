<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Style - Thanh Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
</head>
<body>
<jsp:include page="/WEB-INF/common/header.jsp"/>

<!-- Checkout Content -->
<main class="checkout-container">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty checkoutType}">
        <div class="alert alert-info">
            <c:choose>
                <c:when test="${checkoutType eq 'buynow'}">
                    Bạn đang thực hiện mua nhanh sản phẩm
                </c:when>
                <c:otherwise>
                    Bạn đang thanh toán từ giỏ hàng
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <div class="row">
        <div class="col-md-7">
            <!-- Thông tin giao hàng -->
            <div class="shipping-info">
                <h3 class="section-title">Thông tin giao hàng</h3>
                <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="post">
                    <div class="form-group">
                        <label for="fullName">Họ và tên *</label>
                        <input type="text" id="fullName" name="fullName" required class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại *</label>
                        <input type="tel" id="phone" name="phone" required class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="email">Email (tùy chọn)</label>
                        <input type="email" id="email" name="email" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ giao hàng *</label>
                        <textarea id="address" name="address" rows="3" required class="form-control"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="notes">Ghi chú đơn hàng (tùy chọn)</label>
                        <textarea id="notes" name="notes" rows="2" class="form-control"></textarea>
                    </div>
                    <input type="hidden" id="paymentMethod" name="paymentMethod" value="cod">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                </form>
            </div>

            <!-- Phương thức thanh toán -->
            <div class="payment-method">
                <h3 class="section-title">Phương thức thanh toán</h3>
                <div class="payment-option">
                    <input type="radio" id="cod" name="payment" value="cod" checked>
                    <label for="cod">Thanh toán khi nhận hàng (COD)</label>
                </div>
                <div class="payment-option">
                    <input type="radio" id="bank" name="payment" value="bank">
                    <label for="bank">Chuyển khoản ngân hàng</label>
                </div>
                <div class="payment-option">
                    <input type="radio" id="wallet" name="payment" value="wallet">
                    <label for="wallet">Ví điện tử (Momo, ZaloPay)</label>
                </div>
            </div>
        </div>

        <div class="col-md-5">
            <!-- Tóm tắt đơn hàng -->
            <div class="order-summary">
                <h3 class="section-title">Tóm tắt đơn hàng</h3>
                <div id="orderItems">
                    <c:forEach items="${displayItems}" var="item">
                        <div class="order-item">
                            <img src="${pageContext.request.contextPath}/images/${item.variant.product.thumbnail}"
                                 alt="${item.variant.product.name}" class="img-thumbnail">
                            <div class="item-details">
                                <p class="item-name">${item.variant.product.name}</p>
                                <p>Màu: ${item.variant.color} - Kích thước: ${item.variant.size}</p>
                                <p>Số lượng: ${item.quantity}</p>
                            </div>
                            <div class="item-price">
                                <fmt:formatNumber value="${item.variant.price * item.quantity}"
                                                  type="currency"
                                                  currencyCode="VND"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="summary-details">
                    <p>Tạm tính: <span id="subTotal"><fmt:formatNumber value="${subTotal}" type="currency" currencyCode="VND"/></span></p>
                    <p>Phí vận chuyển: <span id="shippingFee"><fmt:formatNumber value="${shippingFee}" type="currency" currencyCode="VND"/></span></p>
                    <p>Giảm giá: <span id="discount"><fmt:formatNumber value="${discount}" type="currency" currencyCode="VND"/></span></p>
                </div>
                <p class="total-price">Tổng cộng: <span id="totalPrice"><fmt:formatNumber value="${total}" type="currency" currencyCode="VND"/></span></p>
                <div class="discount-code">
                    <input type="text" id="discountCode" placeholder="Nhập mã giảm giá" class="form-control">
                    <button id="applyDiscount" class="btn btn-secondary">Áp dụng</button>
                </div>
                <button class="btn-confirm btn btn-primary" id="confirmOrder">Xác nhận đặt hàng</button>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/common/footer.jsp"/>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Xử lý thay đổi phương thức thanh toán
        document.querySelectorAll('input[name="payment"]').forEach(radio => {
            radio.addEventListener('change', function() {
                document.getElementById('paymentMethod').value = this.value;
            });
        });

        // Xử lý mã giảm giá
        document.getElementById("applyDiscount").addEventListener("click", function() {
            const code = document.getElementById("discountCode").value.trim();
            const discountElement = document.getElementById("discount");

            if (code === "SAVE10") {
                fetch('${pageContext.request.contextPath}/DiscountServlet?code=' + code)
                    .then(response => {
                        if (!response.ok) throw new Error('Network error');
                        return response.json();
                    })
                    .then(data => {
                        if (data.valid) {
                            discountElement.textContent = new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(data.discountAmount);
                            alert("Áp dụng mã giảm giá thành công!");
                        } else {
                            alert("Mã giảm giá không hợp lệ!");
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert("Có lỗi xảy ra khi áp dụng mã giảm giá");
                    });
            } else if (code) {
                alert("Mã giảm giá không hợp lệ!");
            }
        });

        // Xử lý xác nhận đặt hàng
        document.getElementById("confirmOrder").addEventListener("click", function() {
            // Validate form trước khi submit
            const fullName = document.getElementById("fullName").value.trim();
            const phone = document.getElementById("phone").value.trim();
            const address = document.getElementById("address").value.trim();

            if (!fullName || !phone || !address) {
                alert("Vui lòng điền đầy đủ thông tin bắt buộc");
                return;
            }

            document.getElementById("checkoutForm").submit();
        });
    });
</script>
</body>
</html>