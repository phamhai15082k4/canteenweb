package com.canteensystem.controller; 

import com.canteensystem.entity.Order;
import com.canteensystem.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.util.List;

@Controller
public class ClientOrderController {

    @Autowired
    private OrderRepository orderRepository;

    // 1. XEM LỊCH SỬ ĐƠN HÀNG
    @GetMapping("/history")
    public String orderHistory(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/"; // Chưa đăng nhập thì đá về trang chủ
        }
        
        String username = principal.getName();
        
        // Lấy đơn của user đó, sắp xếp mới nhất lên đầu (ID DESC)
        List<Order> orders = orderRepository.findByUser_Username(username, Sort.by(Sort.Direction.DESC, "id"));
        
        model.addAttribute("orders", orders);
        return "client/history";
    }

    // 2. KHÁCH HỦY ĐƠN (Chỉ hủy được khi trạng thái là PENDING)
    @GetMapping("/history/cancel/{id}")
    public String cancelOrder(@PathVariable Long id, Principal principal) {
        Order order = orderRepository.findById(id).orElse(null);
        
        // Kiểm tra bảo mật:
        // 1. Đơn hàng phải tồn tại
        // 2. Đơn hàng phải là của chính người đang đăng nhập (tránh ông A hủy đơn ông B)
        // 3. Trạng thái phải là PENDING (chưa nấu) mới được hủy
        if (order != null && order.getUser().getUsername().equals(principal.getName()) && order.getStatus().equals("PENDING")) {
            order.setStatus("CANCELLED");
            orderRepository.save(order);
        }
        
        return "redirect:/history";
    }
}