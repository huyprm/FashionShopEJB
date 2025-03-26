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
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLDecoder;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/checkout")
public class CheckOutServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CheckOutServlet.class.getName());

    @EJB
    private ProductServiceRemote productService;

    @EJB
    private ProductVariantServiceRemote productVariantService;

    @EJB
    private CartServiceRemote cartService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        try {
            List<Map<String, Object>> displayItems = new ArrayList<>();
            BigDecimal subTotal = BigDecimal.ZERO;
            BigDecimal shippingFee = new BigDecimal("30000");

            // Xử lý trường hợp mua ngay
            String productId = request.getParameter("productId");
            if (productId != null) {
                String color = URLDecoder.decode(request.getParameter("color"), "UTF-8");
                String size = request.getParameter("size");
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                Product product = productService.getProductById(Integer.parseInt(productId));
                List<ProductVariant> allVariants = productVariantService.getListProductVariantById(product.getId());

                Optional<ProductVariant> variantOpt = allVariants.stream()
                        .filter(v -> {
                            String dbColor = v.getColor().trim().toLowerCase().replaceAll("\\s+", " ");
                            String dbSize = v.getSize().trim().toLowerCase();
                            return dbColor.equals(color.trim().toLowerCase().replaceAll("\\s+", " "))
                                    && dbSize.equals(size.trim().toLowerCase());
                        })
                        .findFirst();

                if (!variantOpt.isPresent()) {
                    throw new RuntimeException("Không tìm thấy biến thể sản phẩm phù hợp");
                }

                Map<String, Object> item = new HashMap<>();
                item.put("variant", variantOpt.get());
                item.put("quantity", quantity);
                displayItems.add(item);

                subTotal = new BigDecimal(variantOpt.get().getPrice()).multiply(new BigDecimal(quantity));
                request.setAttribute("checkoutType", "buynow");
            }
            // Xử lý giỏ hàng
            else {
                List<Cart> cartItems = cartService.getCartByUserId(user.getId());
                for (Cart cartItem : cartItems) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("variant", cartItem.getProductVariant());
                    item.put("quantity", cartItem.getQuantity());
                    displayItems.add(item);

                    subTotal = subTotal.add(
                            new BigDecimal(cartItem.getProductVariant().getPrice())
                                    .multiply(new BigDecimal(cartItem.getQuantity()))
                    );
                }
                request.setAttribute("checkoutType", "cart");
            }

            BigDecimal total = subTotal.add(shippingFee);

            request.setAttribute("displayItems", displayItems);
            request.setAttribute("subTotal", subTotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi hệ thống", e);
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}