<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Giỏ Hàng - Fashion Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css" />
</head>
<body>
<jsp:include page="/WEB-INF/common/header.jsp" />

<!-- Main Content -->
<main class="container py-5">
    <h1 class="mb-4 text-center">Giỏ Hàng Của Bạn</h1>
    <div class="row">
        <div class="col-lg-8">
            <div class="mb-3">
                <input type="checkbox" id="select-all" checked onchange="toggleSelectAll()" />
                <label for="select-all" class="ms-2">Chọn tất cả</label>
            </div>

            <div id="cart-items">
                <c:forEach items="${cartItems}" var="item">
                    <div class="card mb-3 cart-item" data-id="${item.id}">
                        <div class="row g-0">
                            <div class="col-md-2 d-flex align-items-center">
                                <input type="checkbox" class="item-checkbox ms-2" checked
                                       data-id="${item.id}" onchange="updateTotal()">
                                <img src="${pageContext.request.contextPath}/images/${item.image}"
                                     class="img-fluid rounded-start" alt="${item.name}">
                            </div>
                            <div class="col-md-6">
                                <div class="card-body">
                                    <h5 class="card-title">${item.name}</h5>
                                    <p class="card-text">Màu: ${item.color} | Size: ${item.size}</p>
                                    <div class="d-flex align-items-center">
                                        <button class="btn btn-sm btn-outline-secondary quantity-btn"
                                                onclick="changeQuantity('${item.id}', -1)">-</button>
                                        <span class="mx-2 quantity">${item.quantity}</span>
                                        <button class="btn btn-sm btn-outline-secondary quantity-btn"
                                                onclick="changeQuantity('${item.id}', 1)">+</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 d-flex align-items-center justify-content-end">
                                <div class="me-3 price">
                                    <fmt:formatNumber value="${item.price * item.quantity}"
                                                      type="currency" currencyCode="VND"/>
                                </div>
                                <button class="btn btn-danger btn-sm"
                                        onclick="removeItem('${item.id}')">Xóa</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card summary-card">
                <div class="card-body">
                    <h5 class="card-title">Thông tin đơn hàng</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Tạm tính:</span>
                        <span id="subtotal"><fmt:formatNumber value="${subtotal}"
                                                              type="currency" currencyCode="VND"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Phí vận chuyển:</span>
                        <span id="shipping"><fmt:formatNumber value="30000"
                                                              type="currency" currencyCode="VND"/></span>
                    </div>
                    <hr />
                    <div class="d-flex justify-content-between fw-bold mb-3">
                        <span>Tổng cộng:</span>
                        <span id="total"><fmt:formatNumber value="${subtotal + 30000}"
                                                           type="currency" currencyCode="VND"/></span>
                    </div>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100">
                        Đặt Hàng
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/common/footer.jsp" />

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>

<script>
    function toggleSelectAll() {
        const selectAll = document.getElementById('select-all').checked;
        document.querySelectorAll('.item-checkbox').forEach(checkbox => {
            checkbox.checked = selectAll;
        });
        updateTotal();
    }

    function updateTotal() {
        // Gọi AJAX để cập nhật giỏ hàng
        const selectedItems = [];
        document.querySelectorAll('.item-checkbox:checked').forEach(checkbox => {
            selectedItems.push(checkbox.dataset.id);
        });

        // Cập nhật UI hoặc gọi server để tính toán lại
        calculateTotal(selectedItems);
    }

    function calculateTotal(selectedItems) {
        fetch('${pageContext.request.contextPath}/cart/calculate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({items: selectedItems})
        })
            .then(response => response.json())
            .then(data => {
                document.getElementById('subtotal').textContent =
                    new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.subtotal);
                document.getElementById('total').textContent =
                    new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.total);
            });
    }

    function changeQuantity(itemId, delta) {
        fetch('${pageContext.request.contextPath}/cart/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({itemId: itemId, delta: delta})
        })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    location.reload(); // Hoặc cập nhật UI động
                }
            });
    }

    function removeItem(itemId) {
        if(confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
            fetch('${pageContext.request.contextPath}/cart/remove', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({itemId: itemId})
            })
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        document.querySelector(`.cart-item[data-id="${itemId}"]`).remove();
                        updateTotal();
                    }
                });
        }
    }
</script>
</body>
</html>