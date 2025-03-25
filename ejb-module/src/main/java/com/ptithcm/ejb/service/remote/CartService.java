package com.ptithcm.ejb.service.remote;

import com.ptithcm.ejb.entity.*;
import com.ptithcm.ejb.enums.DiscountTypeEnum;
import com.ptithcm.ejb.service.CartServiceRemote;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

@Stateless
public class CartService implements CartServiceRemote {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public Cart createCart(String userId, int quantity, int productVariantId) {
        try {
            ProductVariant productVariant = entityManager.find(ProductVariant.class, productVariantId);
            if (productVariant == null) {
                throw new RuntimeException("Product variant not found");
            }

            User user = entityManager.find(User.class, userId);
            if (user == null) {
                throw new RuntimeException("User not found");
            }

            Cart newCart = new Cart();
            newCart.setUser(user);
            newCart.setProductVariant(productVariant);
            newCart.setQuantity(quantity);
            newCart.setTotalPrice(quantity * productVariant.getPrice());

            entityManager.persist(newCart);
            return newCart;
        } catch (Exception e) {
            throw new RuntimeException("ErrorCode.DATABASE_ERROR");
        }
    }

    @Override
    public Cart updateCart(Cart request) {
        Cart cart = entityManager.find(Cart.class, request.getId());
        if (cart == null) {
            throw new RuntimeException("Cart not found");
        }
        cart.setQuantity(request.getQuantity());
        cart.setTotalPrice(request.getQuantity() * cart.getProductVariant().getPrice());

        entityManager.merge(cart);
        return cart;
    }

    @Override
    public List<Cart> getCartByUserId(String userId) {
        TypedQuery<Cart> query = entityManager.createQuery("SELECT c FROM carts c WHERE c.user.id = :userId", Cart.class);
        query.setParameter("userId", userId);

        List<Cart> carts = query.getResultList();
        return carts;
    }

    @Override
    public String deleteCart(int id) {
        Cart cart = entityManager.find(Cart.class, id);
        if (cart != null) {
            entityManager.remove(cart);
            return "Cart deleted";
        } else {
            throw new RuntimeException("ErrorCode.CART_NOT_FOUND");
        }
    }

}
