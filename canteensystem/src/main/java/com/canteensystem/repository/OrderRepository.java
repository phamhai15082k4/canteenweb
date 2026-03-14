package com.canteensystem.repository;

import com.canteensystem.entity.Order;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.canteensystem.repository.OrderRepository;
import java.util.List;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.query.Param;
@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    // Đếm số đơn theo trạng thái (Dùng cho Dashboard)
    long countByStatus(String status);

    // Tính tổng doanh thu
    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.status = 'COMPLETED'")
    Double sumRevenue();
    
    // Tìm đơn hàng theo Username
    List<Order> findByUser_Username(String username, Sort sort);
    //  Lọc đơn hàng theo 4 điều kiện 
    @Query("SELECT o FROM Order o WHERE " +
           "(:orderId IS NULL OR o.id = :orderId) AND " +
           "(:username IS NULL OR LOWER(o.user.username) LIKE LOWER(CONCAT('%', :username, '%')) OR LOWER(o.user.fullName) LIKE LOWER(CONCAT('%', :username, '%'))) AND " +
           "(:status IS NULL OR o.status = :status) AND " +
           "(:orderDate IS NULL OR DATE(o.orderDate) = :orderDate) " +
           "ORDER BY o.id DESC")
    List<Order> searchOrders(@Param("orderId") Long orderId, 
                             @Param("username") String username, 
                             @Param("status") String status, 
                             @Param("orderDate") String orderDate);
    
    // Tính tổng doanh thu theo NGÀY (Chỉ tính các đơn Đã hoàn thành)
    @Query(value = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(order_date) = :date AND status = 'COMPLETED'", nativeQuery = true)
    Double sumRevenueByDate(@Param("date") java.time.LocalDate date);

    // Tính tổng doanh thu theo THÁNG
    @Query(value = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE MONTH(order_date) = :month AND YEAR(order_date) = :year AND status = 'COMPLETED'", nativeQuery = true)
    Double sumRevenueByMonth(@Param("month") int month, @Param("year") int year);
    
    // Lấy tất cả hóa đơn (Đơn đã hoàn thành)
    @Query("SELECT o FROM Order o WHERE o.status = 'COMPLETED' ORDER BY o.orderDate DESC, o.id DESC")
    List<Order> findAllCompletedOrders();

    // Tìm kiếm hóa đơn theo Mã SV/Tên và Ngày
    @Query("SELECT o FROM Order o WHERE o.status = 'COMPLETED' AND " +
           "(:keyword IS NULL OR LOWER(o.user.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(o.user.fullName) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:date IS NULL OR DATE(o.orderDate) = :date) " +
           "ORDER BY o.orderDate DESC, o.id DESC")
    List<Order> searchInvoices(@Param("keyword") String keyword, @Param("date") String date);
}
