<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Style - Trang Chủ</title>

    <!-- CSS -->
    <link rel="stylesheet" href="/src/main/webapp/assets/css/home.css">
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
<script src="/src/main/webapp/assets/js/home.js"></script>

</body>
</html>
