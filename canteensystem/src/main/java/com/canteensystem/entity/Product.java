package com.canteensystem.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "products")

public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private Double price;
    @Lob // Báo hiệu đây là dữ liệu lớn
    @Column(columnDefinition = "LONGTEXT") // Bắt buộc MySQL dùng kiểu LONGTEXT
    private String image;
    private String description;

    @Column(name = "is_available")
    private Boolean isAvailable;

    // Mối quan hệ: Nhiều món ăn thuộc về 1 Danh mục
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "discount_percentage", columnDefinition = "integer default 0")
    private Integer discountPercentage = 0;

    public Product() {
    }

    public Product(Long id, String name, Double price, String image, String description, Boolean isAvailable, Category category) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.image = image;
        this.description = description;
        this.isAvailable = isAvailable;
        this.category = category;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(Boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Integer getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(Integer discountPercentage) {
        this.discountPercentage = discountPercentage;
    }
}
