package com.ptithcm.ejb.service.remote;

import com.ptithcm.ejb.entity.Product;
import com.ptithcm.ejb.entity.ProductVariant;
import com.ptithcm.ejb.service.ProductVariantServiceRemote;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Stateless
public class ProductVariantService implements ProductVariantServiceRemote {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    public List<ProductVariant> updateProductVariant(Map<Integer, ProductVariant> productVariantRequests) {
        List<ProductVariant> list = productVariantRequests.entrySet().stream()
                .map(entry -> {
                    int variantId = entry.getKey();
                    ProductVariant request = entry.getValue();

                    ProductVariant productVariant = entityManager.find(ProductVariant.class, variantId);
                    if (productVariant == null) {
                        throw new RuntimeException("Product variant not found");
                    }
                    return productVariant;
                })
                .toList();

        list.forEach(entityManager::merge);
        entityManager.flush();

        return list;
    }


    @Override
    @Transactional
    public String deleteProductVariant(List<Integer> ids) {
        List<ProductVariant> variants = entityManager.createQuery(
                        "SELECT v FROM ProductVariant v WHERE v.id IN :ids", ProductVariant.class)
                .setParameter("ids", ids)
                .getResultList();

        if (variants.isEmpty()) {
            throw new RuntimeException("Product variant not found");
        }

        variants.forEach(entityManager::remove);
        entityManager.flush();

        return "List product variant deleted";
    }

    @Override
    public List<ProductVariant> getListProductVariantById(int id) {
        return entityManager.createQuery("SELECT pv FROM ProductVariant pv WHERE pv.product.id = :id", ProductVariant.class)
                .setParameter("id", id)
                .getResultList();
    }

}

