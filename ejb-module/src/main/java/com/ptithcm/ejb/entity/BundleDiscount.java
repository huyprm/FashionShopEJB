//package com.ptithcm.ejb.entity;
//
//import com.ptithcm.ejb.enums.DiscountTypeEnum;
//import jakarta.persistence.*;
//import lombok.*;
//import org.hibernate.annotations.NaturalId;
//
//
//import java.time.LocalDateTime;
//
//@Entity(name = "bundle_discounts")
//@AllArgsConstructor
//@NoArgsConstructor
//@Setter
//@Getter
//@Builder
//public class BundleDiscount {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private int id;
//
//    @ManyToOne
//    @JoinColumn(name = "main_product_id")
//    private Product mainProduct;
//
//    @ManyToOne
//    @NaturalId
//    @JoinColumn(name = "bundle_product_id")
//    private Product bundledProduct;
//
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false)
//    private DiscountTypeEnum discountType;
//
//    @Column(nullable = false)
//    private double discountValue;
//
//    @NaturalId
//    @Column(nullable = false)
//    private LocalDateTime startDate;
//
//    @Column(nullable = false)
//    private LocalDateTime endDate;
//
//}
