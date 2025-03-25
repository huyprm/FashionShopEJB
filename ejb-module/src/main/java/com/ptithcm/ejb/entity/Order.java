package com.ptithcm.ejb.entity;

import com.ptithcm.ejb.enums.OrderStatusEnum;
import com.ptithcm.ejb.enums.PaymentMethodEnum;
import com.ptithcm.ejb.enums.PaymentStatusEnum;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    private OrderStatusEnum status = OrderStatusEnum.PENDING;

    private double total_price;

    private LocalDateTime date;

    private String address;

    private String phone;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderDetail> orderDetails;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    private PaymentStatusEnum paymentStatus = PaymentStatusEnum.PENDING;

    @Enumerated(EnumType.STRING)
    private PaymentMethodEnum paymentMethod;
}
