package com.ptithcm.ejb.entity;

import com.ptithcm.ejb.enums.AccountStatusEnum;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Entity(name = "users")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class User implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String phone;

    @Size(min = 5, message = "Password must be greater than 5 characters")
    @NotBlank(message = "Password cannot be blank")
    private String password;

    @Column(unique = true)
    @Email(message = "Email is not in correct format")
    private String email;

    private String fullName;
    private String address;
    private String birthday;
    private String gender;
    private String img;

    @Enumerated(EnumType.STRING)
    private AccountStatusEnum status = AccountStatusEnum.ACTIVE;

    @Column(columnDefinition = "text")
    private String refreshToken;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;


    @OneToMany(mappedBy = "user")
    private List<Order> orders;


}
