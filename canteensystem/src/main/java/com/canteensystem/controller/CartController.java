package com.canteensystem.controller;

import com.canteensystem.dto.CartItem;
import com.canteensystem.entity.Order;
import com.canteensystem.entity.OrderDetail;
import com.canteensystem.entity.Product;
import com.canteensystem.entity.User;
import com.canteensystem.repository.OrderRepository;
import com.canteensystem.repository.ProductRepository;
import com.canteensystem.repository.UserRepository;
import com.canteensystem.service.EmailService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired private ProductRepository productRepository;
    @Autowired private OrderRepository orderRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private EmailService emailService;

    // 1. XEM GIỎ HÀNG
    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();
        
        // Tính tổng tiền
        double totalAmount = cart.stream().mapToDouble(CartItem::getTotalPrice).sum();
        
        model.addAttribute("cart", cart);
        model.addAttribute("totalAmount", totalAmount);
        return "client/cart"; // Trả về giao diện giỏ hàng
    }

    // 2. THÊM VÀO GIỎ (ĐÃ SỬA NHẬN SỐ LƯỢNG)
    @PostMapping("/add")
    public String addToCart(@RequestParam("productId") Long productId, 
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity, // Lấy số lượng từ Form, mặc định là 1
                            HttpSession session, 
                            HttpServletRequest request) { 
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        // Kiểm tra xem món này đã có trong giỏ chưa
        boolean exists = false;
        for (CartItem item : cart) {
            if (item.getProductId().equals(productId)) {
                // Đã có trong giỏ -> Cộng dồn số lượng mới vào
                item.setQuantity(item.getQuantity() + quantity); 
                exists = true;
                break;
            }
        }

        // Nếu chưa có thì thêm mới
        if (!exists) {
            Product product = productRepository.findById(productId).orElse(null);
            if (product != null) {
                // 1. Tính toán giá sau khi giảm
                double finalPrice = product.getPrice();
                if (product.getDiscountPercentage() != null && product.getDiscountPercentage() > 0) {
                    finalPrice = product.getPrice() * (100 - product.getDiscountPercentage()) / 100.0;
                }
                
                // 2. Thêm giá đã giảm và số lượng vào Giỏ
                cart.add(new CartItem(product.getId(), product.getName(), finalPrice, quantity, product.getImage()));
            }
        }

        session.setAttribute("cart", cart); 
        
        // Trở lại đúng trang người dùng vừa bấm "Thêm vào giỏ"
        String referer = request.getHeader("Referer");
        if (referer != null) {
            return "redirect:" + referer;
        }
        
        return "redirect:/menu"; 
    }

    // 3. XÓA KHỎI GIỎ
    @GetMapping("/remove/{productId}")
    public String removeFromCart(@PathVariable Long productId, HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cart.removeIf(item -> item.getProductId().equals(productId));
            session.setAttribute("cart", cart);
        }
        return "redirect:/cart";
    }

    // 4. ĐẶT HÀNG (CHECKOUT)
    @PostMapping("/checkout")
    public String checkout(HttpSession session, Principal principal) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) return "redirect:/cart";

        // Tìm người dùng đang đăng nhập
        String username = principal.getName();
        User user = userRepository.findByUsername(username).orElse(null);

        // Tạo đơn hàng mới (Order)
        Order order = new Order();
        order.setUser(user);
        order.setOrderDate(new Date());
        order.setStatus("PENDING"); // Mới đặt thì là Chờ xác nhận
        order.setPaymentMethod("CASH");
        
        // Tính tổng tiền & Tạo chi tiết đơn hàng (OrderDetails)
        double totalAmount = 0;
        List<OrderDetail> details = new ArrayList<>();
        
        for (CartItem item : cart) {
            OrderDetail detail = new OrderDetail();
            detail.setOrder(order);
            detail.setProduct(productRepository.findById(item.getProductId()).get());
            detail.setQuantity(item.getQuantity());
            detail.setPrice(item.getPrice());
            
            details.add(detail);
            totalAmount += item.getTotalPrice();
        }
        
        order.setTotalAmount(totalAmount);
        order.setOrderDetails(details); 

        orderRepository.save(order);
        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            emailService.sendOrderConfirmation(user.getEmail(), order);
        }
        session.removeAttribute("cart");

        return "redirect:/cart?success=true";
    }
}