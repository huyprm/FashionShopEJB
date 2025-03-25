<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 3/25/2025
  Time: 10:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Shop - Quản lý sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/addProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>
<div class="admin-container">
    <aside class="sidebar">
        <div class="logo">
            <i class="fas fa-tshirt"></i>
            <span>Fashion Admin</span>
        </div>
        <nav>
            <ul>
                <li class="active"><a href="#"><i class="fas fa-box"></i> Sản phẩm</a></li>
                <li><a href="#"><i class="fas fa-tags"></i> Danh mục</a></li>
                <li><a href="#"><i class="fas fa-star"></i> Thương hiệu</a></li>
                <li><a href="#"><i class="fas fa-file-invoice-dollar"></i> Đơn hàng</a></li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <header class="header">
            <h1><i class="fas fa-plus-circle"></i> Thêm sản phẩm mới</h1>
            <div class="user-info">
                <img src="https://via.placeholder.com/40" alt="User Avatar">
                <span>Admin</span>
            </div>
        </header>

        <div class="content">
            <form id="productForm" class="product-form"
            action="${pageContext.request.contextPath}/product" method="post" enctype="multipart/form-data">
                <div class="form-section">
                    <h2><i class="fas fa-info-circle"></i> Thông tin cơ bản</h2>
                    <div class="form-group">
                        <label for="productName">Tên sản phẩm *</label>
                        <input type="text" id="productName" name="productName" required>
                    </div>
                    <div class="form-group">
                        <label for="productDesc">Mô tả (ít nhất 100 ký tự) *</label>
                        <textarea id="productDesc" minlength="100" name="productDesc" required></textarea>
                        <div class="char-count"><span id="descCount">0</span>/100 ký tự</div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="productPrice">Giá bán *</label>
                            <input type="number" id="productPrice" min="0" step="1000" name="productPrice" required>
                        </div>
                        <div class="form-group">
                            <label for="productStock">Số lượng tồn *</label>
                            <input type="number" id="productStock" min="1" name="productStock" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="productBrand">Thương hiệu *</label>
                            <select id="productBrand"  name="productBrand">
                                <option value="">-- Chọn thương hiệu --</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="productCategory">Danh mục *</label>
                            <select id="productCategory" name="productCategory">
                                <option value="">-- Chọn danh mục --</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h2><i class="fas fa-images"></i> Hình ảnh sản phẩm</h2>
                    <div class="form-group">
                        <label for="productThumbnail">Ảnh đại diện *</label>
                        <div class="file-upload">
                            <input type="file" id="productThumbnail" accept="image/*" name="productThumbnail" required>
                            <label for="productThumbnail" class="upload-btn">
                                <i class="fas fa-cloud-upload-alt"></i> Chọn ảnh
                            </label>
                            <div class="file-name" id="thumbnailName">Chưa chọn ảnh</div>
                        </div>
                        <div class="image-preview" id="thumbnailPreview"></div>
                    </div>
                    <div class="form-group">
                        <label for="productImages">Ảnh chi tiết (tối đa 5 ảnh)</label>
                        <div class="file-upload">
                            <input type="file" id="productImages" accept="image/*" name="productImages" multiple>
                            <label for="productImages" class="upload-btn">
                                <i class="fas fa-cloud-upload-alt"></i> Chọn nhiều ảnh
                            </label>
                            <div class="file-name" id="imagesName">Chưa chọn ảnh</div>
                        </div>
                        <div class="image-preview-grid" id="imagesPreview"></div>
                    </div>
                </div>

                <div class="form-section">
                    <h2><i class="fas fa-list-alt"></i> Biến thể sản phẩm</h2>
                    <div id="variantsContainer">
                        <div class="variant-item">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Màu sắc</label>
                                    <input type="text" class="variant-color" placeholder="Ví dụ: Đỏ, Xanh..." name="color">
                                </div>
                                <div class="form-group">
                                    <label>Kích thước</label>
                                    <input type="text" class="variant-size" placeholder="Ví dụ: S, M, L..." name="size">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Giá</label>
                                    <input type="number" class="variant-price" min="0" step="1000" placeholder="Nếu khác giá chung" name="price">
                                </div>
                                <div class="form-group">
                                    <label>Số lượng</label>
                                    <input type="number" class="variant-quantity" min="1" value="1" name="quantity">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Ảnh biến thể (nếu có)</label>
                                <div class="file-upload">
                                    <input type="file" class="variant-image" accept="image/*" name="image">
                                    <label class="upload-btn">
                                        <i class="fas fa-cloud-upload-alt"></i> Chọn ảnh
                                    </label>
                                </div>
                            </div>
                            <button type="button" class="remove-variant-btn">
                                <i class="fas fa-trash"></i> Xóa biến thể
                            </button>
                        </div>
                    </div>
                    <button type="button" id="addVariantBtn" class="add-variant-btn">
                        <i class="fas fa-plus"></i> Thêm biến thể
                    </button>
                </div>

                <div class="form-actions">
                    <button type="button" id="resetBtn" class="cancel-btn">
                        <i class="fas fa-undo"></i> Nhập lại
                    </button>
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-save"></i> Lưu sản phẩm
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<div id="notification" class="notification hidden">
    <span id="notificationMessage"></span>
</div>
<script>
    // API Endpoints

    // DOM Elements
    const productForm = document.getElementById('productForm');
    const productDesc = document.getElementById('productDesc');
    const descCount = document.getElementById('descCount');
    const thumbnailInput = document.getElementById('productThumbnail');
    const thumbnailPreview = document.getElementById('thumbnailPreview');
    const thumbnailName = document.getElementById('thumbnailName');
    const imagesInput = document.getElementById('productImages');
    const imagesPreview = document.getElementById('imagesPreview');
    const imagesName = document.getElementById('imagesName');
    const variantsContainer = document.getElementById('variantsContainer');
    const addVariantBtn = document.getElementById('addVariantBtn');
    const resetBtn = document.getElementById('resetBtn');
    const notification = document.getElementById('notification');
    const notificationMessage = document.getElementById('notificationMessage');

    // Global variables
    let brands = [];
    let categories = [];

    // Initialize the page
    document.addEventListener('DOMContentLoaded', () => {
        console.log('Page loaded, initializing...');
        loadBrands();
        loadCategories();
        setupEventListeners();
    });

    // Load brands from API
    async function loadBrands() {
        try {
            console.log('Fetching brands from:', BRANDS_API);
            const response = await fetch(BRANDS_API);
            console.log('Brands API response status:', response.status);

            if (!response.ok) {
                throw new Error(`Không thể tải danh sách thương hiệu - Status: ${response.status}`);
            }

            const result = await response.json(); // Lấy toàn bộ object
            brands = result.data; // Gán mảng từ thuộc tính 'data'
            console.log('Brands data received:', brands);

            const brandSelect = document.getElementById('productBrand');

            while (brandSelect.options.length > 1) {
                brandSelect.remove(1);
            }

            brands.forEach(brand => {
                const option = document.createElement('option');
                option.value = brand.id;
                option.textContent = brand.name;
                brandSelect.appendChild(option);
            });
            console.log('Brands dropdown populated successfully');
        } catch (error) {
            console.error('Error loading brands:', error.message);
            showNotification('error', `Lỗi: ${error.message}`);
        }
    }

    // Load categories from API
    async function loadCategories() {
        try {
            console.log('Fetching categories from:', CATEGORIES_API);
            const response = await fetch(CATEGORIES_API);
            console.log('Categories API response status:', response.status);

            if (!response.ok) {
                throw new Error(`Không thể tải danh sách danh mục - Status: ${response.status}`);
            }

            const result = await response.json(); // Lấy toàn bộ object
            categories = result.data; // Gán mảng từ thuộc tính 'data'
            console.log('Categories data received:', categories);

            const categorySelect = document.getElementById('productCategory');

            while (categorySelect.options.length > 1) {
                categorySelect.remove(1);
            }

            categories.forEach(category => {
                const option = document.createElement('option');
                option.value = category.id;
                option.textContent = category.name;
                categorySelect.appendChild(option);
            });
            console.log('Categories dropdown populated successfully');
        } catch (error) {
            console.error('Error loading categories:', error.message);
            showNotification('error', `Lỗi: ${error.message}`);
        }
    }
    // Setup event listeners
    function setupEventListeners() {
        // Character count for description
        productDesc.addEventListener('input', () => {
            descCount.textContent = productDesc.value.length;
            console.log('Description character count updated:', productDesc.value.length);
        });

        // Thumbnail preview
        thumbnailInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (file) {
                thumbnailName.textContent = file.name;
                displayImagePreview(file, thumbnailPreview);
                console.log('Thumbnail selected:', file.name);
            }
        });

        // Multiple images preview
        imagesInput.addEventListener('change', (e) => {
            const files = e.target.files;
            if (files.length > 0) {
                imagesName.textContent = `${files.length} ảnh đã chọn`;
                imagesPreview.innerHTML = '';
                console.log('Multiple images selected:', files.length);

                Array.from(files).forEach(file => {
                    const previewContainer = document.createElement('div');
                    previewContainer.className = 'image-preview';

                    displayImagePreview(file, previewContainer);
                    imagesPreview.appendChild(previewContainer);
                });
            }
        });

        // Add variant button
        addVariantBtn.addEventListener('click', addVariant);

        // Reset form
        resetBtn.addEventListener('click', resetForm);

        // Form submission
    }

    // Add new variant
    function addVariant() {
        const variantItem = document.createElement('div');
        variantItem.className = 'variant-item';

        variantItem.innerHTML = `
        <div class="form-row">
            <div class="form-group">
                <label>Màu sắc</label>
                <input type="text" class="variant-color" placeholder="Ví dụ: Đỏ, Xanh..." name="color">
            </div>
            <div class="form-group">
                <label>Kích thước</label>
                <input type="text" class="variant-size" placeholder="Ví dụ: S, M, L..." name="size">
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>Giá</label>
                <input type="number" class="variant-price" min="0" step="1000" placeholder="Nếu khác giá chung" name="price">
            </div>
            <div class="form-group">
                <label>Số lượng</label>
                <input type="number" class="variant-quantity" min="1" value="1" name="quantity">
            </div>
        </div>
        <div class="form-group">
            <label>Ảnh biến thể (nếu có)</label>
            <div class="file-upload">
                <input type="file" class="variant-image" accept="image/*">
                <label class="upload-btn">
                    <i class="fas fa-cloud-upload-alt"></i> Chọn ảnh
                </label>
            </div>
        </div>
        <button type="button" class="remove-variant-btn">
            <i class="fas fa-trash"></i> Xóa biến thể
        </button>
    `;

        variantsContainer.appendChild(variantItem);
        console.log('New variant added');

        // Add event listener to remove button
        const removeBtn = variantItem.querySelector('.remove-variant-btn');
        removeBtn.addEventListener('click', () => {
            variantsContainer.removeChild(variantItem);
            console.log('Variant removed');
        });

        // Add event listener for image preview
        const imageInput = variantItem.querySelector('.variant-image');
        imageInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (file) {
                // Create preview container if it doesn't exist
                let previewContainer = variantItem.querySelector('.image-preview');
                if (!previewContainer) {
                    previewContainer = document.createElement('div');
                    previewContainer.className = 'image-preview';
                    variantItem.querySelector('.form-group').appendChild(previewContainer);
                }

                displayImagePreview(file, previewContainer);
                console.log('Variant image selected:', file.name);
            }
        });
    }

    // Display image preview
    function displayImagePreview(file, container) {
        const reader = new FileReader();

        reader.onload = (e) => {
            container.innerHTML = '';
            const img = document.createElement('img');
            img.src = e.target.result;
            container.appendChild(img);
            console.log('Image preview displayed for:', file.name);
        };

        reader.readAsDataURL(file);
    }

    // Reset form
    function resetForm() {
        if (confirm('Bạn có chắc muốn xóa tất cả dữ liệu đã nhập?')) {
            productForm.reset();
            descCount.textContent = '0';
            thumbnailPreview.innerHTML = '';
            thumbnailName.textContent = 'Chưa chọn ảnh';
            imagesPreview.innerHTML = '';
            imagesName.textContent = 'Chưa chọn ảnh';

            // Remove all variants except the first one
            const variantItems = variantsContainer.querySelectorAll('.variant-item');
            variantItems.forEach((item, index) => {
                if (index > 0) {
                    variantsContainer.removeChild(item);
                } else {
                    // Reset the first variant
                    item.querySelector('.variant-color').value = '';
                    item.querySelector('.variant-size').value = '';
                    item.querySelector('.variant-price').value = '';
                    item.querySelector('.variant-quantity').value = '1';

                    const imageInput = item.querySelector('.variant-image');
                    imageInput.value = '';

                    const preview = item.querySelector('.image-preview');
                    if (preview) preview.innerHTML = '';
                }
            });
            console.log('Form reset completed');
        }
    }

    // Handle form submission

    // Validate form
    function validateForm() {
        // Check description length
        if (productDesc.value.length < 100) {
            console.log('Validation failed: Description too short');
            showNotification('error', 'Mô tả phải có ít nhất 100 ký tự');
            return false;
        }

        // Check thumbnail
        if (!thumbnailInput.files[0]) {
            console.log('Validation failed: No thumbnail selected');
            showNotification('error', 'Vui lòng chọn ảnh đại diện cho sản phẩm');
            return false;
        }

        // Check variants
        const variantItems = variantsContainer.querySelectorAll('.variant-item');
        if (variantItems.length === 0) {
            console.log('Validation failed: No variants added');
            showNotification('error', 'Vui lòng thêm ít nhất một biến thể sản phẩm');
            return false;
        }

        console.log('Form validation passed');
        return true;
    }

    // Show notification
    function showNotification(type, message) {
        notification.className = `notification ${type}`;
        notificationMessage.textContent = message;
        notification.classList.add('show');
        console.log(`Notification shown: ${type} - ${message}`);

        setTimeout(() => {
            notification.classList.remove('show');
        }, 5000);
    }
</script>
</body>
