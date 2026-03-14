package com.canteensystem.controller;

import com.canteensystem.entity.Category;
import com.canteensystem.entity.Product;
import com.canteensystem.entity.Role;
import com.canteensystem.entity.User;
import com.canteensystem.repository.CategoryRepository;
import com.canteensystem.repository.ProductRepository;
import com.canteensystem.repository.RoleRepository;
import com.canteensystem.repository.UserRepository;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private CategoryRepository categoryRepository;

    // 1. TRANG CHỦ 
    @GetMapping("/")
    public String home(Model model) { 
        model.addAttribute("categories", categoryRepository.findAll());
        // Lấy danh sách tất cả sản phẩm
        List<Product> allProducts = productRepository.findAll();
        
        // Cắt lấy 8 món đầu tiên (tạo thành 2 hàng, mỗi hàng 4 món) làm "Món bán chạy"
        List<Product> featuredProducts = allProducts.size() > 8 ? allProducts.subList(0, 8) : allProducts;
        model.addAttribute("featuredProducts", featuredProducts);
        return "home"; 
    }

    // 2. TRANG MENU 
    @GetMapping("/menu")
    public String menu(Model model, 
                       @RequestParam(name = "categoryId", required = false) Long categoryId) { 
        
        model.addAttribute("categories", categoryRepository.findAll());

        List<Product> products;
        if (categoryId != null) {
            products = productRepository.findByCategoryId(categoryId);
            model.addAttribute("activeCategoryId", categoryId); // Đánh dấu mục đang chọn
        } else {
            products = productRepository.findAll();
            model.addAttribute("activeCategoryId", categoryId );
        }
        model.addAttribute("products", products);
                
        return "menu"; // Hoặc return "menu";
    }
    
    // NẾU HỆ THỐNG ĐÁ VỀ /login, TA SẼ ĐẨY VỀ TRANG CHỦ ĐỂ BẬT MODAL
    @GetMapping("/login")
    public String loginPage() {
        return "redirect:/?login=true"; 
    }
    
    @GetMapping("/403") 
    public String accessDenied() { return "403"; }
    
    // Nếu trong Controller chưa có 3 thư viện này thì bạn khai báo thêm nhé:
     @Autowired private UserRepository userRepository;
     @Autowired private RoleRepository roleRepository;
     @Autowired private PasswordEncoder passwordEncoder;

     
    // 1. HIỂN THỊ TRANG ĐĂNG KÝ
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register"; // Nó sẽ gọi file register.jsp
    }

    // 2. XỬ LÝ DỮ LIỆU KHI BẤM "ĐĂNG KÝ NGAY"
    @PostMapping("/register")
    public String processRegister(@RequestParam("username") String username,
                                  @RequestParam("fullName") String fullName,
                                  @RequestParam("phone") String phone,
                                  @RequestParam(value = "email", required = false) String email,
                                  @RequestParam("password") String password,
                                  @RequestParam("confirmPassword") String confirmPassword,
                                  org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        // Kiểm tra xem Mật khẩu và Xác nhận mật khẩu có khớp không
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp!");
            return "redirect:/register";
        }

        // Kiểm tra xem Tên đăng nhập đã có ai dùng chưa
        if (userRepository.findByUsername(username).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Tên đăng nhập này đã tồn tại, vui lòng chọn tên khác!");
            return "redirect:/register";
        }

        // Tạo tài khoản mới
        com.canteensystem.entity.User newUser = new com.canteensystem.entity.User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setPhone(phone);
        newUser.setEmail(email);
        
        // Mã hóa mật khẩu
        newUser.setPassword(passwordEncoder.encode(password));

        // Cấp quyền mặc định cho khách ngoài (Role ID = 3 thường là quyền USER)
        com.canteensystem.entity.Role defaultRole = roleRepository.findById(3).orElse(null);
        if (defaultRole != null) {
            java.util.Set<com.canteensystem.entity.Role> roles = new java.util.HashSet<>();
            roles.add(defaultRole);
            newUser.setRoles(roles);
        }

        userRepository.save(newUser);

        // Chuyển hướng về trang chủ và báo thành công để Modal Đăng nhập tự bật lên
        redirectAttributes.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
        return "redirect:/?success=true"; 
    }
}