package com.ptithcm.ejb.enums;

public enum RoleEnum {
    ADMIN("Administrator role with full access"),
    STAFF_WAREHOUSE("Staff role with limited permissions"),
    STAFF_SALES("Staff role with limited permissions"),
    CUSTOMER("Customer role with basic access");

    private final String description;

    RoleEnum(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

}
