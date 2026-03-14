package com.canteensystem.repository;
import com.canteensystem.entity.OrderDetail;
import com.canteensystem.entity.OrderDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long> {}