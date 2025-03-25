package com.ptithcm.ejb.service;


import com.ptithcm.ejb.entity.Cart;
import jakarta.ejb.Remote;

import java.util.List;

@Remote
public interface CartServiceRemote {
    Cart createCart(String userId, int quantity, int productVariantId);
    Cart updateCart(Cart request);
    List<Cart> getCartByUserId(String userId);
    String deleteCart(int id);
}
