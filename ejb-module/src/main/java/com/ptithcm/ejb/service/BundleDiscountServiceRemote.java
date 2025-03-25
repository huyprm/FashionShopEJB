//package com.ptithcm.ejb.service;
//
//import com.ptithcm.ejb.entity.BundleDiscount;
//import com.ptithcm.ejb.enums.DiscountTypeEnum;
//import jakarta.ejb.Remote;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@Remote
//public interface BundleDiscountServiceRemote {
//    BundleDiscount createBundleDiscount(BundleDiscount bundleDiscount);
//    BundleDiscount updateBundleDiscount(DiscountTypeEnum type, double value, LocalDateTime start, LocalDateTime end, int bundleId);
//    String deleteBundleDiscount(int id);
//    BundleDiscount getBundleDiscount(int id);
//    List<BundleDiscount> getAllBundleDiscount();
//}
