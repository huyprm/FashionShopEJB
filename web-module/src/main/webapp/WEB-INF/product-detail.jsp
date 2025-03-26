<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Fashion Style - Chi Tiết Sản Phẩm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product-detail.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="/WEB-INF/common/header.jsp"/>

<main class="container product-detail-container">
  <div class="row">
    <div class="col-md-6 product-image">
      <img src="${product.thumbnail}" alt="Product Image"/>
    </div>
    <div class="col-md-6 product-info">
      <h1 class="product-title">${product.name}</h1>
      <p class="product-price">${product.price} VNĐ</p>
      <p class="product-stock">Còn lại: ${product.stock_quantity} sản phẩm</p>
      <p class="product-rating">Đánh giá: ${product.rating}/5</p>
      <p class="product-description">${product.description}</p>

      <!-- Color Options -->
      <div class="option-group">
        <label>Màu sắc:</label>
        <div class="color-options">
          <c:forEach items="${colors}" var="color">
            <button class="color-btn ${selectedColor eq color ? 'active' : ''}"
                    onclick="setSelectedColor('${color}')">
                ${color}
            </button>
          </c:forEach>
        </div>
      </div>

      <!-- Size Options -->
      <div class="option-group">
        <label>Kích thước:</label>
        <div class="size-options">
          <c:forEach items="${sizes}" var="size">
            <button class="size-btn ${selectedSize eq size ? 'active' : ''}"
                    onclick="setSelectedSize('${size}')">
                ${size}
            </button>
          </c:forEach>
        </div>
      </div>

      <!-- Quantity -->
      <div class="quantity-group">
        <label>Số lượng:</label>
        <form action="${pageContext.request.contextPath}/product/detail" method="post">
          <input type="hidden" name="action" value="decrease"/>
          <input type="hidden" name="id" value="${product.id}"/>
          <button type="submit" class="quantity-btn">-</button>
        </form>

        <input type="text" class="quantity-input" value="${quantity}" name="quantity"/>

        <form action="${pageContext.request.contextPath}/product/detail" method="post">
          <input type="hidden" name="action" value="increase"/>
          <input type="hidden" name="id" value="${product.id}"/>
          <button type="submit" class="quantity-btn">+</button>
        </form>
      </div>

      <!-- Action Buttons -->
      <div class="action-buttons">
        <form action="${pageContext.request.contextPath}/cart" method="post">
          <input type="hidden" name="action" value="add"/>
          <input type="hidden" name="productId" value="${product.id}"/>
          <input type="hidden" name="color" value="${selectedColor}"/>
          <input type="hidden" name="size" value="${selectedSize}"/>
          <input type="hidden" name="quantity" value="${quantity}"/>
          <button type="submit" class="btn btn-add-to-cart">Thêm vào giỏ hàng</button>
        </form>

        <form action="${pageContext.request.contextPath}/checkout" method="post">
          <input type="hidden" name="productId" value="${product.id}"/>
          <input type="hidden" name="color" value="${selectedColor}"/>
          <input type="hidden" name="size" value="${selectedSize}"/>
          <input type="hidden" name="quantity" value="${quantity}"/>
          <button type="submit" class="btn btn-buy-now">Mua ngay</button>
        </form>
      </div>
    </div>
  </div>
</main>

<!-- Bundle Deal Section -->
<c:if test="${not empty bundleDeal}">
  <section class="deal-section">
    <h3 class="title_deal">Mua thêm deal sốc</h3>
    <div class="bundle">
      <div class="deal-item main-item">
        <img src="${product.thumbnail}" alt="Product Image"/>
        <div class="deal-info">
          <p class="deal-name">
              ${product.name}
            <button class="open-popup">🎨</button>
          </p>
          <p class="deal-label">Deal Sốc <span>-0%</span></p>
          <p class="original-price">${product.price} VNĐ</p>
          <p class="deal-price">
            <strong>${product.price} VNĐ</strong>
          </p>
        </div>
      </div>
      <span class="plus-sign">+</span>
      <div class="bundle-items">
        <c:forEach items="${bundleProducts}" var="bundleProduct">
          <div class="deal-item">
            <input type="checkbox" class="deal-checkbox"
                   name="selectedBundleProducts" value="${bundleProduct.id}"
              ${selectedBundleProducts[bundleProduct.id] ? 'checked' : ''}/>
            <img src="${bundleProduct.thumbnail}" alt="Bundle Product"/>
            <div class="deal-info">
              <p class="deal-name">
                  ${bundleProduct.name}
                <button class="open-popup">🎨</button>
              </p>
              <p class="deal-label">Deal Sốc <span>-50%</span></p>
              <p class="original-price">200.000 VNĐ</p>
              <p class="deal-price"><strong>100.000 VNĐ</strong></p>
            </div>
          </div>
        </c:forEach>
      </div>
      <div class="bundle-summary">
        <p>
          <strong>Tổng cộng: <span>${bundleTotal} VNĐ</span></strong>
        </p>
        <p>Tiết kiệm: <span>${bundleDiscount} VNĐ</span></p>
        <form action="${pageContext.request.contextPath}/bundle" method="post">
          <input type="hidden" name="productId" value="${product.id}"/>
          <button type="submit" class="btn btn-buy-now">Bấm để mua deal sốc</button>
        </form>
      </div>
    </div>
  </section>
</c:if>

<jsp:include page="/WEB-INF/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/resources/js/product-detail.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
  function setSelectedColor(color) {
    // You can implement this with AJAX or form submission
    window.location.href = '${pageContext.request.contextPath}/product/detail?id=${product.id}&color=' + color;
  }

  function setSelectedSize(size) {
    // You can implement this with AJAX or form submission
    window.location.href = '${pageContext.request.contextPath}/product/detail?id=${product.id}&size=' + size;
  }
</script>
</body>
</html>