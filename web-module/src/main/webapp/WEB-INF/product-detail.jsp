<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <title>Fashion Style - Chi Tiết Sản Phẩm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="/WEB-INF/common/header.jsp"/>

<main class="container product-detail-container">
  <div class="row">
    <div class="col-md-6 product-image">
      <img src="${product.thumbnail}" alt="Product Image" id="productImage"/>
    </div>
    <div class="col-md-6 product-info">
      <h1 class="product-title" id="productName">${product.name}</h1>
      <p class="product-price" id="productPrice">${product.price} VNĐ</p>
      <p class="product-stock" id="productStock">Còn lại: ${product.stock_quantity} sản phẩm</p>
      <p class="product-rating" id="productRating">Đánh giá: ${product.rating}/5</p>
      <p class="product-description" id="productDescription">${product.description}</p>

      <!-- Color Options -->
      <c:if test="${not empty colors}">
        <div class="option-group">
          <label>Màu sắc:</label>
          <div class="color-options" id="colorOptions">
            <c:forEach items="${colors}" var="color" varStatus="loop">
              <button class="color-btn ${loop.first ? 'active' : ''}"
                      onclick="toggleOption(this, document.getElementById('colorOptions')); setSelectedColor('${color}')">
                  ${color}
              </button>
            </c:forEach>
          </div>
        </div>
      </c:if>

      <!-- Size Options -->
      <c:if test="${not empty sizes}">
        <div class="option-group">
          <label>Kích thước:</label>
          <div class="size-options" id="sizeOptions">
            <c:forEach items="${sizes}" var="size" varStatus="loop">
              <button class="size-btn ${loop.first ? 'active' : ''}"
                      onclick="toggleOption(this, document.getElementById('sizeOptions')); setSelectedSize('${size}')">
                  ${size}
              </button>
            </c:forEach>
          </div>
        </div>
      </c:if>

      <!-- Quantity -->
      <div class="quantity-group">
        <label>Số lượng:</label>
        <button id="decreaseQty" class="quantity-btn">-</button>
        <input type="text" class="quantity-input" value="1" id="quantity" name="quantity" readonly/>
        <button id="increaseQty" class="quantity-btn">+</button>
      </div>

      <!-- Action Buttons -->
      <div class="action-buttons">
        <button id="addToCartBtn" class="btn-add-to-cart">Thêm vào giỏ hàng</button>
        <button id="buyNowBtn" class="btn-buy-now">Mua ngay</button>
      </div>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/common/footer.jsp"/>

<script>
  const colors = [<c:forEach items="${colors}" var="color">"${color}",</c:forEach>];
  const sizes = [<c:forEach items="${sizes}" var="size">"${size}",</c:forEach>];
  let selectedColor = colors.length > 0 ? colors[0] : "";
  let selectedSize = sizes.length > 0 ? sizes[0] : "";
  let quantity = 1;
  const productId = ${product.id};
  const maxQuantity = ${product.stock_quantity};
  const contextPath = "${pageContext.request.contextPath}";

  function toggleOption(selectedBtn, container) {
    const buttons = container.getElementsByTagName("button");
    for (let btn of buttons) btn.classList.remove("active");
    selectedBtn.classList.add("active");
  }

  function setSelectedColor(color) { selectedColor = color; }
  function setSelectedSize(size) { selectedSize = size; }

  document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("decreaseQty").addEventListener("click", () => {
      let value = parseInt(document.getElementById("quantity").value);
      if (value > 1) {
        document.getElementById("quantity").value = value - 1;
        quantity = value - 1;
      }
    });

    document.getElementById("increaseQty").addEventListener("click", () => {
      let value = parseInt(document.getElementById("quantity").value);
      if (value < maxQuantity) {
        document.getElementById("quantity").value = value + 1;
        quantity = value + 1;
      } else {
        alert("Số lượng vượt quá số lượng tồn kho!");
      }
    });

    document.getElementById("addToCartBtn").addEventListener("click", async () => {
      try {
        const response = await fetch('${pageContext.request.contextPath}/product-detail', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: new URLSearchParams({
            productId: ${product.id},
            color: document.querySelector('.color-options .active')?.textContent || '',
            size: document.querySelector('.size-options .active')?.textContent || '',
            quantity: document.getElementById('quantity').value
          })
        });

        const result = await response.json();

        if (result.error === 'login_required') {
          window.location.href = '${pageContext.request.contextPath}/login?redirect=' + encodeURIComponent(window.location.href);
          return;
        }

        if (result.success) {
          alert('Thêm vào giỏ hàng thành công!');
        } else {
          alert('Lỗi: ' + (result.error || 'Không xác định'));
        }
      } catch (error) {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi kết nối tới server');
      }
    });

    document.getElementById("buyNowBtn").addEventListener("click", () => {
      window.location.href = contextPath + '/checkout?productId=' + productId + '&color=' + encodeURIComponent(selectedColor) + '&size=' + encodeURIComponent(selectedSize) + '&quantity=' + quantity;
    });
  });
</script>
</body>
</html>