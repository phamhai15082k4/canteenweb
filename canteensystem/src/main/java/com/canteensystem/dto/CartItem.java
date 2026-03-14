package com.canteensystem.dto;

public class CartItem {
    private Long productId;
    private String name;
    private Double price;
    private Integer quantity;
    private String image;


    public CartItem(Long productId, String name, Double price, Integer quantity, String image) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    // Tính thành tiền (Giá x Số lượng)
    public Double getTotalPrice() {
        return price * quantity;
    }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}