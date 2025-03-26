package com.ptithcm.ejb.service.remote;

import com.ptithcm.ejb.entity.Product;
import com.ptithcm.ejb.entity.ProductVariant;
import com.ptithcm.ejb.service.ProductServiceRemote;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@Stateless
public class ProductService implements ProductServiceRemote {

    @PersistenceContext
    private EntityManager entityManager;


    @Override
    public Product getProductById(int id) {
        Product product = entityManager.find(Product.class, id);
        if (product == null) {
            throw new RuntimeException("Product not found!");
        }
        return product;
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> products = entityManager.createQuery("SELECT p FROM products p", Product.class).getResultList();
        return products;
    }

    @Override
    @Transactional
    public Product addProduct(Product request) {
        Product product = new Product();
        product.setName(request.getName());
        product.setPrice(request.getPrice());
        product.setBrand(request.getBrand());
        product.setCategory(request.getCategory());
        product.setDescription(request.getDescription());
        product.setStock_quantity(request.getStock_quantity());
        product.setImages(request.getImages());
        product.setThumbnail(request.getThumbnail());

        List<ProductVariant> list = request.getProductVariantList().stream().map(productVariantRequest ->{
            ProductVariant product_variant = ProductVariant.builder()
                    .color(productVariantRequest.getColor())
                    .image(productVariantRequest.getImage())
                    .price(productVariantRequest.getPrice())
                    .quantity(productVariantRequest.getQuantity())
                    .size( productVariantRequest.getSize())
                    .product(product)
                    .build();
            return product_variant;
        } ).toList();

        int tempQuantity = request.getProductVariantList().stream().mapToInt(ProductVariant::getQuantity).sum();

        product.setStock_quantity(tempQuantity != 0 ? tempQuantity : request.getStock_quantity());
        product.setProductVariantList(list);

        entityManager.persist(product);
        return product;
    }

    @Override
    public Product updateProduct(Product request) {
        Product product = entityManager.find(Product.class, request.getId());
        if (product == null) throw new RuntimeException("Product not found!");

        product.setName(request.getName());
        product.setPrice(request.getPrice());
        product.setDescription(request.getDescription());
        product.setBrand(request.getBrand());
        product.setCategory(request.getCategory());

        entityManager.merge(product);
        return product;
    }

    @Override
    public String deleteProduct(int id) {
        Product product = entityManager.find(Product.class, id);
        if (product == null) throw new RuntimeException("Product not found!");
        entityManager.remove(product);
        return "Product deleted successfully!";
    }

}

