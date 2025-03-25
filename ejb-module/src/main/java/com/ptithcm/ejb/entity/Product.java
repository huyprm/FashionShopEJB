package com.ptithcm.ejb.entity;

import com.ptithcm.ejb.enums.ProductStatusEnum;
import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import lombok.*;


import java.io.Serializable;
import java.util.List;

@Entity(name = "products")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @ElementCollection
    private List<String> images;

    private String thumbnail;

    private String price;

    @Min(value = 0, message = "Quantity must be greater than or equal to 0.")
    private int stock_quantity;

    @Column
    private double rating = 0;

    @Column
    private int sold = 0;

    @Enumerated(EnumType.STRING)
    private ProductStatusEnum status = ProductStatusEnum.IN_STOCK;

    private String category;

    private String brand;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
    private List<ProductVariant> productVariantList;


//    @OneToMany(mappedBy = "mainProduct")
//    private List<BundleDiscount> bundleDiscountList;
}
