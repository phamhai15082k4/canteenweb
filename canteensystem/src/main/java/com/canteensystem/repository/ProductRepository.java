package com.canteensystem.repository;

import com.canteensystem.entity.Product;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Chỉ cần để trống thế này thôi.
    // Spring Boot sẽ tự động viết code thêm/sửa/xóa/tìm kiếm cho cậu ngầm bên dưới.
    // Phép thuật là ở chỗ "extends JpaRepository" này đấy.
    java.util.List<Product> findByIsAvailableTrue();
    List<Product> findByCategoryId(Long categoryId);
    @Query
        ("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Product> searchProducts(@Param("keyword") String keyword);
    @Query
        ("SELECT p FROM Product p WHERE p.category.id = :categoryId AND (LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Product> searchProductsByCategoryAndKeyword(@Param("categoryId") Long categoryId, @Param("keyword") String keyword);
}