//package com.ptithcm.ejb.service.remote;
//
//import com.ptithcm.ejb.entity.Product;
//import com.ptithcm.ejb.enums.DiscountTypeEnum;
//import com.ptithcm.ejb.service.BundleDiscountServiceRemote;
//import jakarta.ejb.Stateless;
//import jakarta.persistence.EntityManager;
//import jakarta.persistence.PersistenceContext;
//import org.hibernate.exception.ConstraintViolationException;
//
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//import java.util.Date;
//import java.util.List;
//
//@Stateless
//public class BundleDiscountService implements BundleDiscountServiceRemote {
//
//    @PersistenceContext
//    private EntityManager entityManager;
//
//
//    @Override
//    //@RolesAllowed({"ADMIN", "STAFF_SALES"})
//    public BundleDiscount createBundleDiscount(BundleDiscount bundleDiscount) {
//
//        Product mainProduct = entityManager.find(Product.class, bundleDiscount.getMainProduct());
//        if (mainProduct == null) {
//            throw new RuntimeException("Product not found");
//        }
//
//        Product bundledProduct = entityManager.find(Product.class, bundleDiscount.getBundledProduct());
//        if (bundledProduct == null) {
//            throw new RuntimeException("Product not found");
//        }
//
//        bundleDiscount.setMainProduct(mainProduct);
//        bundleDiscount.setBundledProduct(bundledProduct);
//
//        if (bundleDiscount.getStartDate().isBefore(LocalDateTime.now())) {
//            throw new RuntimeException("Invalid start time.");
//        }
//
//        if (!bundleDiscount.getStartDate().isBefore(bundleDiscount.getEndDate())) {
//            throw new RuntimeException("Start date must be before end date.");
//        }
//
//        try {
//            entityManager.persist(bundleDiscount);
//            return bundleDiscount;
//        } catch (ConstraintViolationException e) {
//            throw new RuntimeException("BundleDiscount already exists for this product and start date!", e);
//        }
//    }
//
//    @Override
//   // @RolesAllowed({"ADMIN", "STAFF_SALES"})
//    public BundleDiscount updateBundleDiscount(DiscountTypeEnum type, double value, LocalDateTime start, LocalDateTime end, int bundleId) {
//        BundleDiscount bundleDiscount = entityManager.find(BundleDiscount.class, bundleId);
//        if (bundleDiscount == null) {
//            throw new RuntimeException("BundleDiscount not found");
//        }
//
//        if (bundleDiscount.getStartDate().isBefore(LocalDateTime.now())
//                && bundleDiscount.getEndDate().isAfter(LocalDateTime.now())) {
//            throw new RuntimeException("The bundle discount is active, no changes allowed.");
//        }
//
//        if (bundleDiscount.getEndDate().isBefore(LocalDateTime.now())) {
//            throw new RuntimeException("The bundle discount is expired, no changes allowed.");
//        }
//
//        bundleDiscount.setDiscountValue(value);
//        bundleDiscount.setDiscountType(type);
//        bundleDiscount.setStartDate(start);
//        bundleDiscount.setEndDate(end);
//        entityManager.merge(bundleDiscount);
//
//        return bundleDiscount;
//    }
//
//    @Override
//   // @RolesAllowed({"ADMIN", "STAFF_SALES"})
//    public String deleteBundleDiscount(int id) {
//        BundleDiscount bundleDiscount = entityManager.find(BundleDiscount.class, id);
//        if (bundleDiscount == null) {
//            throw new RuntimeException("BundleDiscount not found");
//        }
//
//        if (bundleDiscount.getStartDate().isBefore(LocalDateTime.now())
//                && bundleDiscount.getEndDate().isAfter(LocalDateTime.now())) {
//            throw new RuntimeException("The bundle discount is active, no changes allowed.");
//        }
//
//        entityManager.remove(bundleDiscount);
//        return "BundleDiscount deleted successfully";
//    }
//
//    @Override
//    public BundleDiscount getBundleDiscount(int id) {
//        BundleDiscount bundleDiscount = entityManager.find(BundleDiscount.class, id);
//        if (bundleDiscount == null) {
//            throw new RuntimeException("BundleDiscount not found");
//        }
//
//        return bundleDiscount;
//    }
//
//    @Override
//    public List<BundleDiscount> getAllBundleDiscount() {
//        List<BundleDiscount> bundleDiscounts = entityManager.createQuery("SELECT b FROM bundle_discounts b", BundleDiscount.class).getResultList();
//        return bundleDiscounts;
//    }
//}
//
//
