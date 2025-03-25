package com.ptithcm.ejb.service;

import com.ptithcm.ejb.entity.ProductVariant;
import jakarta.ejb.Remote;

import java.util.List;
import java.util.Map;

@Remote
public interface ProductVariantServiceRemote {
    List<ProductVariant> updateProductVariant(Map<Integer, ProductVariant> productVariantRequests);
    String deleteProductVariant(List<Integer> ids);
}
