<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Style - Trang Chủ</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Header -->
<jsp:include page="common/header.jsp"/>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>
<!-- Main Content -->
<main class="container mt-4">

    <!-- Hero Carousel -->
    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="https://images.unsplash.com/photo-1441986300917-64674bd600d8" class="d-block w-100" alt="Fashion Collection">
                <div class="carousel-caption">
                    <h2>Summer Collection 2024</h2>
                    <p>Khám phá xu hướng thời trang mới nhất</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1483985988355-763728e1935b" class="d-block w-100" alt="New Arrivals">
                <div class="carousel-caption">
                    <h2>Hàng Mới Về</h2>
                    <p>Mua sắm phong cách mới nhất</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Danh Mục Sản Phẩm -->
    <section class="categories mt-5">
        <h2 class="section-title">Danh Mục Sản Phẩm</h2>
        <div class="category-list" id="category-list"></div>
    </section>

    <div class="container py-5">
        <c:forEach var="product" items="${products}" varStatus="status">
            <!-- Mở hàng mới khi bắt đầu hoặc sau mỗi 4 sản phẩm -->
            <c:if test="${status.index % 4 == 0}">
                <div class="row g-4" style="padding-top: 20px;">
            </c:if>

            <div class="col-10 col-md-4 col-lg-3">
                <div class="card product-card" onclick="window.location.href='${pageContext.request.contextPath}/product-detail?id=${product.id}'" >
                    <div class="sale-badge">SALE</div>
                    <img src="${pageContext.request.contextPath}/${product.thumbnail}" class="card-img-top p-3" alt="${product.name}">
                    <div class="card-body">
                        <h5 class="card-title">${product.name}</h5>
                        <div class="rating mb-2">
                            <span class="stars">★★★★★</span>
                            <span class="rating-count">(${product.reviews})</span>
                        </div>
                        <div class="price-block mb-2">
                            <span class="original-price">$${product.price}</span>
                            <span class="current-price text-danger">VNĐ</span>
                        </div>
                        <p class="card-text">${product.description}</p>
                    </div>
                </div>
            </div>

            <!-- Đóng hàng khi đã đủ 4 sản phẩm -->
            <c:if test="${status.index % 4 == 3 or status.last}">
                </div>
            </c:if>
        </c:forEach>

    </div>
    <!-- Sản Phẩm Nổi Bật -->
    <section class="featured-products mt-5">
        <h2 class="section-title">Sản Phẩm Nổi Bật</h2>
        <div class="products-list" id="products-list"></div>
    </section>

</main>

<!-- Footer -->
<jsp:include page="common/footer.jsp"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
