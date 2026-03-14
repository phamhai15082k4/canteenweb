package com.canteensystem.controller; 

import com.canteensystem.entity.Product;
import com.canteensystem.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/product") // Tất cả các link bắt đầu bằng /product sẽ vào đây
public class ClientProductController {

    @Autowired
    private ProductRepository productRepository;

    // Link: /product/{id} (Ví dụ: /product/1, /product/5)
    @GetMapping("/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        // 1. Tìm món ăn theo ID
        Product product = productRepository.findById(id).orElse(null);
        
        // 2. Nếu không có món đó (ví dụ khách gõ ID linh tinh), đá về trang chủ
        if (product == null) {
            return "redirect:/";
        }
        
        // 3. Gửi thông tin món ăn sang file JSP
        model.addAttribute("p", product);
        
        // 4. Trả về giao diện chi tiết
        return "client/product-detail";
    }
}