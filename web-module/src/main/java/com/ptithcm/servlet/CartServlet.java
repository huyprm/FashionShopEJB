package com.ptithcm.servlet;

import com.ptithcm.ejb.entity.Cart;
import com.ptithcm.ejb.entity.ProductVariant;
import com.ptithcm.ejb.entity.User;
import com.ptithcm.ejb.service.CartServiceRemote;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {

    @EJB
    private CartServiceRemote cartService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session nhưng không tạo mới nếu chưa có
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); // Chuyển hướng về trang home
            return;
        }
        User user = (User) session.getAttribute("user");
        String userId = user.getId();

        try {
            List<Cart> carts = cartService.getCartByUserId(userId);
            double subtotal = carts.stream().mapToDouble(Cart::getTotalPrice).sum();

            // Chuẩn bị dữ liệu cho cart.jsp
            request.setAttribute("cartItems", convertToCartItems(carts));
            request.setAttribute("subtotal", subtotal);

            request.getRequestDispatcher("/WEB-INF/cart.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải giỏ hàng: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String action = request.getPathInfo();

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            switch (action) {
                case "/add":
                    handleAddToCart(request, userId);
                    break;

                case "/update":
                    handleUpdateCart(request);
                    break;

                case "/remove":
                    handleRemoveCart(request);
                    break;

                case "/calculate":
                    handleCalculate(request, userId);
                    break;

                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
            }

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private void handleAddToCart(HttpServletRequest request, String userId) {
        int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        cartService.createCart(userId, quantity, productVariantId);
    }

    private void handleUpdateCart(HttpServletRequest request) {
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Cart cart = new Cart();
        cart.setId(cartId);
        cart.setQuantity(quantity);

        cartService.updateCart(cart);
    }

    private void handleRemoveCart(HttpServletRequest request) {
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        cartService.deleteCart(cartId);
    }

    private void handleCalculate(HttpServletRequest request, String userId) {
        // Xử lý tính toán cho các item được chọn (nếu cần)
        // Có thể implement thêm logic tính toán giảm giá ở đây
    }

    private List<Map<String, Object>> convertToCartItems(List<Cart> carts) {
        return carts.stream().map(cart -> {
            Map<String, Object> item = new HashMap<>();
            ProductVariant variant = cart.getProductVariant();

            item.put("id", cart.getId());
            item.put("name", variant.getProduct().getName());
            item.put("image", variant.getProduct().getThumbnail());
            item.put("color", variant.getColor());
            item.put("size", variant.getSize());
            item.put("price", variant.getPrice());
            item.put("quantity", cart.getQuantity());

            return item;
        }).collect(Collectors.toList());
    }
}