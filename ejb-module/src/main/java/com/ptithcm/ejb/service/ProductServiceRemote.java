package com.ptithcm.ejb.service;

import com.ptithcm.ejb.entity.Product;
import jakarta.ejb.Remote;

import java.util.List;

@Remote
public interface ProductServiceRemote {

    Product getProductById(int id);

    List<Product> getAllProducts();

    Product addProduct(Product product);

    Product updateProduct(Product product);

    String deleteProduct(int id);

}

