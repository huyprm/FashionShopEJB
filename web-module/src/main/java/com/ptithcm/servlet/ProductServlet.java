package com.ptithcm.servlet;

import com.ptithcm.ejb.entity.Product;
import com.ptithcm.ejb.entity.ProductVariant;
import com.ptithcm.ejb.service.ProductServiceRemote;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)

@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    @EJB
    private ProductServiceRemote productService;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/addProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Hỗ trợ tiếng Việt

        // Đường dẫn lưu ảnh (cập nhật đường dẫn phù hợp)
        String uploadPath = req.getServletContext().getRealPath("/uploads");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir(); // Tạo thư mục nếu chưa có

        try {
            // Lấy thông tin sản phẩm từ form
            String productName = req.getParameter("productName");
            String productDesc = req.getParameter("productDesc");
            String productBrand = req.getParameter("productBrand");
            String productCategory = req.getParameter("productCategory");
            double productPrice = Double.parseDouble(req.getParameter("productPrice"));
            int productStock = Integer.parseInt(req.getParameter("productStock"));

            // Xử lý ảnh đại diện
            Part thumbnailPart = req.getPart("productThumbnail");
            String thumbnailFileName = Paths.get(thumbnailPart.getSubmittedFileName()).getFileName().toString();
            String thumbnailPath = "uploads/" + thumbnailFileName;
            if (!thumbnailFileName.isEmpty()) {
                thumbnailPart.write(uploadPath + File.separator + thumbnailFileName);
            }

            // Xử lý danh sách ảnh chi tiết
            List<String> detailImagePaths = new ArrayList<>();
            for (Part part : req.getParts()) {
                if (part.getName().equals("productImages") && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    String filePath = "uploads/" + fileName;
                    part.write(uploadPath + File.separator + fileName);
                    detailImagePaths.add(filePath);
                }
            }

            // Tạo đối tượng sản phẩm
            Product product = new Product();
            product.setName(productName);
            product.setDescription(productDesc);
            product.setBrand(productBrand);
            product.setCategory(productCategory);
            product.setPrice(String.valueOf(productPrice));
            product.setStock_quantity(productStock);
            product.setThumbnail(thumbnailPath); // Lưu đường dẫn ảnh đại diện
            product.setImages(detailImagePaths); // Lưu danh sách ảnh chi tiết

            String[] colors = req.getParameterValues("color");
            String[] sizes = req.getParameterValues("size");
            String[] prices = req.getParameterValues("price");
            String[] quantities = req.getParameterValues("quantity");

            List<ProductVariant> variants = new ArrayList<>();
            if (colors != null) {
                for (int i = 0; i < colors.length; i++) {
                    ProductVariant variant = new ProductVariant();
                    variant.setColor(colors[i]);
                    variant.setSize(sizes[i]);
                    variant.setPrice(prices[i].isEmpty() ? productPrice : Double.parseDouble(prices[i]));
                    variant.setQuantity(Integer.parseInt(quantities[i]));

                    // Xử lý ảnh biến thể
                    Part imagePart = req.getPart("image" + i);
                    if (imagePart != null && imagePart.getSize() > 0) {
                        String imageFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                        String imagePath = "uploads/" + imageFileName;
                        imagePart.write(uploadPath + File.separator + imageFileName);
                        variant.setImage(imagePath);
                    }

                    variant.setProduct(product);
                    variants.add(variant);
                }
            }

            product.setProductVariantList(variants);
            productService.addProduct(product);

            resp.sendRedirect(req.getContextPath() + "/product"); // Chuyển hướng sau khi thành công

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi lưu sản phẩm: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/addProduct.jsp").forward(req, resp);
        }
    }

}
