package com.canteensystem.controller;

import com.canteensystem.entity.Product;
import com.canteensystem.repository.CategoryRepository;
import com.canteensystem.repository.ProductRepository;
import com.canteensystem.repository.RoleRepository;
import com.canteensystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class HomeController {

    @Autowired private ProductRepository productRepository;
    @Autowired private CategoryRepository categoryRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private RoleRepository roleRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    // 1. TRANG CHỦ 
    @GetMapping("/")
    public String home(Model model) { 
        model.addAttribute("categories", categoryRepository.findAll());
        List<Product> allProducts = productRepository.findAll();
        
        List<Product> featuredProducts = allProducts.size() > 8 ? allProducts.subList(0, 8) : allProducts;
        model.addAttribute("featuredProducts", featuredProducts);
        return "home"; 
    }

    // 2. TRANG MENU 
    @GetMapping("/menu")
    public String menu(Model model, @RequestParam(name = "categoryId", required = false) Long categoryId) { 
        model.addAttribute("categories", categoryRepository.findAll());

        List<Product> products;
        if (categoryId != null) {
            products = productRepository.findByCategoryId(categoryId);
            model.addAttribute("activeCategoryId", categoryId); 
        } else {
            products = productRepository.findAll();
            model.addAttribute("activeCategoryId", categoryId );
        }
        model.addAttribute("products", products);
                
        return "menu"; 
    }
    
  
    
    @GetMapping("/403") 
    public String accessDenied() { return "403"; }
     
    // 3. HIỂN THỊ TRANG ĐĂNG KÝ
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register"; 
    }

    // 4. XỬ LÝ DỮ LIỆU KHI BẤM "ĐĂNG KÝ NGAY"
    @PostMapping("/register")
    public String processRegister(@RequestParam("username") String username,
                                  @RequestParam("fullName") String fullName,
                                  @RequestParam("phone") String phone,
                                  @RequestParam(value = "email", required = false) String email,
                                  @RequestParam("password") String password,
                                  @RequestParam("confirmPassword") String confirmPassword,
                                  RedirectAttributes redirectAttributes) {
        
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp!");
            return "redirect:/register";
        }

        if (userRepository.findByUsername(username).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Tên đăng nhập này đã tồn tại, vui lòng chọn tên khác!");
            return "redirect:/register";
        }

        com.canteensystem.entity.User newUser = new com.canteensystem.entity.User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setPhone(phone);
        newUser.setEmail(email);
        newUser.setPassword(passwordEncoder.encode(password));

        com.canteensystem.entity.Role defaultRole = roleRepository.findById(3).orElse(null);
        if (defaultRole != null) {
            java.util.Set<com.canteensystem.entity.Role> roles = new java.util.HashSet<>();
            roles.add(defaultRole);
            newUser.setRoles(roles);
        }

        userRepository.save(newUser);

        redirectAttributes.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
        return "redirect:/?success=true"; 
    }
}
