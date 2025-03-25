
<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <!-- Search Bar -->
    <div class="row mb-4">
        <div class="col-md-6 mx-auto">
            <form action="${pageContext.request.contextPath}/products" method="get">
                <div class="input-group">
                    <input type="text" class="form-control" name="search"
                           placeholder="Tìm kiếm sản phẩm..." value="${search}">
                    <button class="btn btn-primary" type="submit">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Products Grid -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach items="${products}" var="product">
            <div class="col">
                <div class="card h-100">
                    <!-- Product Image -->
                    <img src="${product.image}"
                         class="card-img-top product-image" alt="${product.name}">

                    <div class="card-body">
                        <!-- Product Title with Link -->
                        <h5 class="card-title">
                            <a href="${pageContext.request.contextPath}/product/${product.id}"
                               class="text-decoration-none text-dark">
                                    ${product.name}
                            </a>
                        </h5>

                        <!-- Product Description -->
                        <p class="card-text text-truncate">${product.description}</p>

                        <!-- Rating -->
                        <div class="mb-2">
                            <div class="star-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star${i <= product.averageRating ? '' : '-o'}"></i>
                                </c:forEach>
                                <span class="ms-1">(${product.totalReviews})</span>
                            </div>
                        </div>

                        <!-- Price -->
                        <p class="card-text">
                            <strong>Giá: </strong>
                            <span class="text-danger fw-bold">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                            </span>
                        </p>

                        <!-- Stock Status -->
                        <p class="card-text">
                            <small class="text-muted">
                                Còn lại: ${product.stock} sản phẩm
                            </small>
                        </p>

                        <!-- Add to Cart Form -->
                        <div class="d-flex align-items-center">
                            <input type="number" class="form-control me-2"
                                   id="quantity-${product.id}" value="1" min="1"
                                   style="width: 80px;">
                            <button onclick="addToCart('${product.id}')"
                                    class="btn btn-primary flex-grow-1"
                                ${product.stock > 0 ? '' : 'disabled'}>
                                <i class="fas fa-cart-plus"></i>
                                    ${product.stock > 0 ? 'Thêm vào giỏ' : 'Hết hàng'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- No Products Found Message -->
    <c:if test="${empty products}">
        <div class="text-center py-5">
            <h3>Không tìm thấy sản phẩm nào</h3>
            <c:if test="${not empty search}">
                <p>Không có sản phẩm nào phù hợp với từ khóa "${search}"</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Xem tất cả sản phẩm
                </a>
            </c:if>
        </div>
    </c:if>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
