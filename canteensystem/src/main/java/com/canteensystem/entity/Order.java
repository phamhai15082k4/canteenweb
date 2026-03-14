package com.canteensystem.entity;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "orders") // Tên bảng trong Database
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Liên kết với User (Ai đặt đơn này?)
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "order_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date orderDate = new Date(); // Mặc định lấy giờ hiện tại

    @Column(name = "total_amount")
    private Double totalAmount;

    private String status; // Trạng thái: PENDING, COOKING, READY, COMPLETED
    
    @Column(name = "payment_method")
    private String paymentMethod;
    
    private String note; // Ghi chú của sinh viên (Ví dụ: Không hành)
    
    @Column(name = "wait_time")
    private Integer waitTime;

    // Liên kết 1-nhiều với OrderDetail (1 đơn có nhiều món)
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderDetail> orderDetails;

    // --- GETTER & SETTER ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public List<OrderDetail> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetail> orderDetails) { this.orderDetails = orderDetails; }
    
    public Integer getWaitTime() { return waitTime; }
    public void setWaitTime(Integer waitTime) { this.waitTime = waitTime;}
}