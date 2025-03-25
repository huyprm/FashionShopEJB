package com.ptithcm.ejb.service;

import com.ptithcm.ejb.entity.Order;
import jakarta.ejb.Remote;

@Remote
public interface OrderServiceRemote {
    Order createOrder(Order orderRequest, String userId);
}
