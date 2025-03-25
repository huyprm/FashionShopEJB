package com.ptithcm.ejb.service.remote;

import com.ptithcm.ejb.entity.Cart;
import com.ptithcm.ejb.entity.Order;
import com.ptithcm.ejb.entity.OrderDetail;
import com.ptithcm.ejb.entity.User;
import com.ptithcm.ejb.enums.PaymentMethodEnum;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class OrderService {
    @PersistenceContext
    private EntityManager entityManager;

    public Order createOrder(List<Integer> cartIds, String id) {
        User user = entityManager.find(User.class, id);
        if (user == null) {
            throw new RuntimeException("USER_NOT_FOUND");
        }

        List<OrderDetail> orderDetails =new ArrayList<>();
        double totalPrice = 0;
        for (int cartId : cartIds) {
            Cart cart = entityManager.find(Cart.class, cartId);
            if (cart == null) {
                throw new RuntimeException("CART_NOT_FOUND");
            }
            OrderDetail orderDetail = OrderDetail.builder()
                    .price(cart.getTotalPrice()/cart.getQuantity())
                    .productVariant(cart.getProductVariant())
                    .quantity(cart.getQuantity())
                    .build();

            orderDetails.add(orderDetail);

            totalPrice += cart.getTotalPrice();

            entityManager.remove(cart);
        }

        Order order = new Order();
        order.setUser(user);
        order.setPaymentMethod(PaymentMethodEnum.COD);
        order.setTotal_price(totalPrice);
        order.setOrderDetails(orderDetails);
        entityManager.persist(order);

        return order;
    }



}

