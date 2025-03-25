package com.ptithcm.ejb.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity(name ="roles")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Role {
    @Id
    private String role;
    @Column(nullable = false)
    private String description;
    @OneToMany(mappedBy = "role", cascade = CascadeType.PERSIST)
    private List<User> users;
}
