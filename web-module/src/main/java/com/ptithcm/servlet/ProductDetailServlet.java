package com.ptithcm.servlet;

import com.ptithcm.ejb.entity.Cart;
import com.ptithcm.ejb.entity.Product;
import com.ptithcm.ejb.entity.ProductVariant;
import com.ptithcm.ejb.entity.User;
import com.ptithcm.ejb.service.CartServiceRemote;
import com.ptithcm.ejb.service.ProductServiceRemote;
import com.ptithcm.ejb.service.ProductVariantServiceRemote;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {

    @EJB
    private ProductServiceRemote productService;
    @EJB
    private ProductVariantServiceRemote productVariantService;

    @EJB
    private CartServiceRemote cartService; // Thêm CartServiceRemote


    @Override // Đảm bảo phương thức này tồn tại trong HttpServlet
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id");

        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(productId);


            List<ProductVariant> variants = productVariantService.getListProductVariantById(product.getId());

            List<String> colors = variants.stream()
                    .map(ProductVariant::getColor)
                    .distinct()
                    .collect(Collectors.toList());

            List<String> sizes = variants.stream()
                    .map(ProductVariant::getSize)
                    .distinct()
                    .collect(Collectors.toList());

            request.setAttribute("product", product);
            request.setAttribute("colors", colors);
            request.setAttribute("sizes", sizes);
            request.setAttribute("variants", variants);

            request.getRequestDispatcher("/WEB-INF/product-detail.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải chi tiết sản phẩm : " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession(false);

        try {
            // Kiểm tra đăng nhập
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"redirect\": \"" +
                        request.getContextPath() + "/login\"}");
                return;
            }

            // Lấy thông tin từ request
            User user = (User) session.getAttribute("user");
            int productId = Integer.parseInt(request.getParameter("productId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Tìm và validate product variant
            ProductVariant variant = findProductVariant(productId, color, size)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy biến thể sản phẩm phù hợp"));

            // Kiểm tra số lượng tồn kho
            if (quantity <= 0 || quantity > variant.getQuantity()) {
                throw new RuntimeException("Số lượng không hợp lệ hoặc vượt quá tồn kho");
            }

            // Thêm vào giỏ hàng
            cartService.createCart(user.getId(), quantity, variant.getId());

            // Trả về response thành công
            response.getWriter().write(String.format(
                    "{\"success\": true, \"cartCount\": %d}",
                    getCartCount(user.getId()))
            );

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(String.format(
                    "{\"success\": false, \"message\": \"%s\"}",
                    e.getMessage())
            );
        }
    }

    // Helper methods
    private List<String> getDistinctColors(List<ProductVariant> variants) {
        return variants.stream()
                .map(ProductVariant::getColor)
                .distinct()
                .collect(Collectors.toList());
    }

    private List<String> getDistinctSizes(List<ProductVariant> variants) {
        return variants.stream()
                .map(ProductVariant::getSize)
                .distinct()
                .collect(Collectors.toList());
    }

    private Optional<ProductVariant> findProductVariant(int productId, String color, String size) {
        List<ProductVariant> variants = productVariantService.getListProductVariantById(productId);

        String normalizedColor = color.trim().toLowerCase().replaceAll("\\s+", " ");
        String normalizedSize = size.trim().toLowerCase();

        return variants.stream()
                .filter(v -> {
                    String dbColor = v.getColor().trim().toLowerCase().replaceAll("\\s+", " ");
                    String dbSize = v.getSize().trim().toLowerCase();
                    return dbColor.equals(normalizedColor) && dbSize.equals(normalizedSize);
                })
                .findFirst();
    }

    private int getCartCount(String userId) {
        return cartService.getCartByUserId(userId).size();
    }

    private void sendErrorResponse(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
    }

    @Override // Đảm bảo phương thức này tồn tại trong HttpServlet
    public String getServletInfo() {
        return "Product Detail Servlet";
    }
}
