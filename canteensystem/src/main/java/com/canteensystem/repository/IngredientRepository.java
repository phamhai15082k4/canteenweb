package com.canteensystem.repository;

import com.canteensystem.entity.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface IngredientRepository extends JpaRepository<Ingredient, Long> {

    // TÌM KIẾM THEO TÊN VÀ NGÀY NHẬP
    @Query("SELECT i FROM Ingredient i WHERE " +
           "(:keyword IS NULL OR LOWER(i.name) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:importDate IS NULL OR i.importDate = :importDate) " +
           "ORDER BY i.importDate DESC, i.id DESC")
    List<Ingredient> searchIngredients(@Param("keyword") String keyword, @Param("importDate") LocalDate importDate);
    
    // Tính tổng chi phí mua nguyên liệu theo NGÀY
    @Query(value = "SELECT COALESCE(SUM(price * quantity), 0) FROM ingredients WHERE import_date = :date", nativeQuery = true)
    Double sumExpenseByDate(@Param("date") java.time.LocalDate date);

    // Tính tổng chi phí mua nguyên liệu theo THÁNG
    @Query(value = "SELECT COALESCE(SUM(price * quantity), 0) FROM ingredients WHERE MONTH(import_date) = :month AND YEAR(import_date) = :year", nativeQuery = true)
    Double sumExpenseByMonth(@Param("month") int month, @Param("year") int year);
}