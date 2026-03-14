package com.canteensystem.controller;


import com.canteensystem.entity.Ingredient;
import com.canteensystem.entity.Product;
import com.canteensystem.entity.Order;
import com.canteensystem.entity.Role;
import com.canteensystem.entity.User;
import com.canteensystem.repository.ProductRepository;
import com.canteensystem.repository.CategoryRepository;
import com.canteensystem.repository.IngredientRepository;
import com.canteensystem.repository.OrderRepository;
import com.canteensystem.repository.RoleRepository;
import com.canteensystem.repository.UserRepository;
import com.canteensystem.service.EmailService; 

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.InputStream;
import java.util.Iterator;
import java.util.HashSet;
import java.util.Set;
import java.util.Base64;
import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private ProductRepository productRepository;
    @Autowired private CategoryRepository categoryRepository;
    @Autowired private OrderRepository orderRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private RoleRepository roleRepository;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private IngredientRepository ingredientRepository;
    @Autowired private EmailService emailService; 

    // 1. DASHBOARD (Thống kê Doanh thu - Chi phí - Lợi nhuận)
    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model, 
                            @RequestParam(value = "filterDate", required = false) java.time.LocalDate filterDate,
                            @RequestParam(value = "filterMonth", required = false) String filterMonth) {
        
        //  Lấy ngày tháng cần thống kê (Mặc định là hôm nay)
        java.time.LocalDate today = (filterDate != null) ? filterDate : java.time.LocalDate.now();
        
        int month = today.getMonthValue();
        int year = today.getYear();
        
        // Nếu admin chọn lọc theo tháng (định dạng từ HTML là YYYY-MM)
        if (filterMonth != null && !filterMonth.isEmpty()) {
            String[] parts = filterMonth.split("-");
            year = Integer.parseInt(parts[0]);
            month = Integer.parseInt(parts[1]);
        }

        //  THỐNG KÊ THEO NGÀY
        Double dailyRevenue = orderRepository.sumRevenueByDate(today);
        Double dailyExpense = ingredientRepository.sumExpenseByDate(today);
        Double dailyProfit = dailyRevenue - dailyExpense; // Lãi = Thu - Chi

        //  THỐNG KÊ THEO THÁNG
        Double monthlyRevenue = orderRepository.sumRevenueByMonth(month, year);
        Double monthlyExpense = ingredientRepository.sumExpenseByMonth(month, year);
        Double monthlyProfit = monthlyRevenue - monthlyExpense;

        // Gửi dữ liệu ra giao diện
        model.addAttribute("dailyRevenue", dailyRevenue);
        model.addAttribute("dailyExpense", dailyExpense);
        model.addAttribute("dailyProfit", dailyProfit);
        
        model.addAttribute("monthlyRevenue", monthlyRevenue);
        model.addAttribute("monthlyExpense", monthlyExpense);
        model.addAttribute("monthlyProfit", monthlyProfit);

        model.addAttribute("selectedDate", today);
        model.addAttribute("selectedMonth", String.format("%04d-%02d", year, month));

        // Các chỉ số phụ
        model.addAttribute("totalProducts", productRepository.count());
        model.addAttribute("pendingOrders", orderRepository.countByStatus("PENDING"));
        model.addAttribute("totalUsers", userRepository.count());

        return "admin/dashboard";
    }

    // 2. QUẢN LÝ MÓN ĂN (TÌM KIẾM + LỌC THEO DANH MỤC)
    @GetMapping("/products")
    public String productManager(Model model, 
                                 @RequestParam(value = "keyword", required = false) String keyword,
                                 @RequestParam(value = "categoryId", required = false) Long categoryId) {
        
        List<Product> products;
        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        boolean hasCategory = (categoryId != null && categoryId > 0);

        // Kiểm tra xem Admin đang muốn lọc theo kiểu nào
        if (hasKeyword && hasCategory) {
            products = productRepository.searchProductsByCategoryAndKeyword(categoryId, keyword.trim());
        } else if (hasKeyword) {
            products = productRepository.searchProducts(keyword.trim());
        } else if (hasCategory) {
            products = productRepository.findByCategoryId(categoryId);
        } else {
            products = productRepository.findAll(Sort.by(Sort.Direction.DESC, "id"));
        }
        
        model.addAttribute("products", products);
        model.addAttribute("categories", categoryRepository.findAll());
        
        // Giữ lại trạng thái trên thanh tìm kiếm để Admin biết đang lọc cái gì
        model.addAttribute("keyword", hasKeyword ? keyword.trim() : "");
        model.addAttribute("selectedCategoryId", categoryId); 
        
        return "admin/products";
    }

    // Thêm mới món ăn (Kết hợp tải ảnh và link ảnh)
    @PostMapping("/products/add")
    public String addProduct(@ModelAttribute Product product,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                             @RequestParam(value = "imageUrl", required = false) String imageUrl) {
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                byte[] bytes = imageFile.getBytes();
                String base64Image = Base64.getEncoder().encodeToString(bytes);
                product.setImage(base64Image);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            product.setImage(imageUrl.trim());
        }
        productRepository.save(product);
        return "redirect:/admin/products";
    }

    // Cập nhật (Sửa) món ăn (Kết hợp tải ảnh và link ảnh)
    @PostMapping("/products/update")
    public String updateProduct(@ModelAttribute Product product,
                                @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                @RequestParam(value = "imageUrl", required = false) String imageUrl) {
        Product existingProduct = productRepository.findById(product.getId()).orElse(null);
        if (existingProduct != null) {
            existingProduct.setName(product.getName());
            existingProduct.setPrice(product.getPrice());
            existingProduct.setCategory(product.getCategory());
            existingProduct.setDescription(product.getDescription());
            existingProduct.setIsAvailable(product.getIsAvailable());
            existingProduct.setDiscountPercentage(product.getDiscountPercentage() != null ? product.getDiscountPercentage() : 0);
            
            // Xử lý ảnh: Ưu tiên file upload, nếu không có thì lấy Link URL
            if (imageFile != null && !imageFile.isEmpty()) {
                try {
                    String base64Image = Base64.getEncoder().encodeToString(imageFile.getBytes());
                    existingProduct.setImage(base64Image);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                existingProduct.setImage(imageUrl.trim());
            }
            // Nếu cả file và link đều trống thì giữ nguyên ảnh cũ
            
            productRepository.save(existingProduct);
        }
        return "redirect:/admin/products";
    }

    // Xóa món ăn
    @GetMapping("/products/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        try {
            productRepository.deleteById(id);
        } catch (Exception e) {
            System.out.println("Lỗi xóa món: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }

    // 3. QUẢN LÝ ĐƠN HÀNG (Kitchen)
    
    @GetMapping("/orders")
    public String orderManager(Model model,
                               @RequestParam(value = "orderId", required = false) Long orderId,
                               @RequestParam(value = "username", required = false) String username,
                               @RequestParam(value = "orderDate", required = false) String orderDate,
                               @RequestParam(value = "status", required = false) String status) {
        
        
        String searchUsername = (username != null && !username.trim().isEmpty()) ? username.trim() : null;
        String searchDate = (orderDate != null && !orderDate.trim().isEmpty()) ? orderDate.trim() : null;
        String searchStatus = (status != null && !status.trim().isEmpty()) ? status.trim() : null;
        boolean hasFilter = (orderId != null || searchUsername != null || searchDate != null || searchStatus != null);

        if (hasFilter) {
            
            model.addAttribute("orders", orderRepository.searchOrders(orderId, searchUsername, searchStatus, searchDate));
        } else {
           
            model.addAttribute("orders", orderRepository.findAll(Sort.by(Sort.Direction.DESC, "id")));
        }  
        model.addAttribute("orderId", orderId);
        model.addAttribute("username", searchUsername);
        model.addAttribute("orderDate", searchDate);
        model.addAttribute("status", searchStatus);
        return "admin/orders";
    }


    // Cập nhật trạng thái đơn (VÀ TỰ ĐỘNG GỬI EMAIL)
    @PostMapping("/orders/update-status")
    public String updateOrderStatus(@RequestParam Long id,
                                    @RequestParam String status,
                                    @RequestParam(required = false) Integer waitTime) {
        Order order = orderRepository.findById(id).orElse(null);
        if (order != null) {
            order.setStatus(status);
            if ("COOKING".equals(status) && waitTime != null) {
                order.setWaitTime(waitTime);
            }
            orderRepository.save(order);

            // --- TÍNH NĂNG GỬI MAIL KHI NẤU XONG ---
            if ("COMPLETED".equals(status) && order.getUser() != null && order.getUser().getEmail() != null && !order.getUser().getEmail().isEmpty()) {
                try {
                    emailService.sendOrderReadyForPickup(order.getUser().getEmail(), order);
                } catch (Exception e) {
                    System.out.println("Lỗi khi gửi email nhận hàng: " + e.getMessage());
                }
            }
        }
        return "redirect:/admin/orders";
    }

    // 4. QUẢN LÝ TÀI KHOẢN 
    @GetMapping("/users")
    public String userManager(Model model, @RequestParam(value = "keyword", required = false) String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            model.addAttribute("users", userRepository.searchUsers(keyword.trim()));
            model.addAttribute("keyword", keyword.trim()); 
        } else {
            model.addAttribute("users", userRepository.findAll());
        }
        
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/users";
    }

    // Thêm tài khoản thủ công
    @PostMapping("/users/add")
    public String addUser(@ModelAttribute User user, @RequestParam("roleId") Integer roleId) {
        user.setPassword(passwordEncoder.encode("123456"));
        Role role = roleRepository.findById(roleId).orElse(null);
        if (role != null) {
            Set<Role> roles = new HashSet<>();
            roles.add(role);
            user.setRoles(roles);
        }
        userRepository.save(user);
        return "redirect:/admin/users";
    }

    // --- CHỨC NĂNG IMPORT EXCEL ---
    @PostMapping("/users/import")
    public String importUsers(@RequestParam("file") MultipartFile file) {
        try {
            InputStream inputStream = file.getInputStream();
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);

            Role defaultRole = roleRepository.findById(3).orElse(null);
            if (defaultRole == null) {
                if (!roleRepository.findAll().isEmpty()) {
                     defaultRole = roleRepository.findAll().get(0);
                }
            }

            Set<Role> roles = new HashSet<>();
            if (defaultRole != null) {
                roles.add(defaultRole);
            }

            Iterator<Row> iterator = sheet.iterator();
            while (iterator.hasNext()) {
                Row currentRow = iterator.next();
                if (currentRow.getRowNum() == 0) continue;

                String username = getCellValue(currentRow.getCell(0));
                String fullName = getCellValue(currentRow.getCell(1));
                String email = getCellValue(currentRow.getCell(2));
                String phone = getCellValue(currentRow.getCell(3));

                if (username != null && !username.isEmpty() && userRepository.findByUsername(username).isEmpty()) {
                    User user = new User();
                    user.setUsername(username);
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhone(phone);
                    user.setPassword(passwordEncoder.encode("123456"));
                    user.setRoles(roles); 
                    userRepository.save(user);
                }
            }
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi Import Excel: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        DataFormatter formatter = new DataFormatter();
        return formatter.formatCellValue(cell);
    }

    // Cập nhật user
    @PostMapping("/users/update")
    public String updateUser(@ModelAttribute User user, @RequestParam("roleId") Integer roleId) {
        User existingUser = userRepository.findById(user.getId()).orElse(null);
        if (existingUser != null) {
            existingUser.setFullName(user.getFullName());
            existingUser.setEmail(user.getEmail());
            existingUser.setPhone(user.getPhone());
            existingUser.setUsername(user.getUsername());

            Role role = roleRepository.findById(roleId).orElse(null);
            if (role != null) {
                Set<Role> roles = new HashSet<>();
                roles.add(role);
                existingUser.setRoles(roles);
            }
            userRepository.save(existingUser);
        }
        return "redirect:/admin/users";
    }

    // Đổi mật khẩu User (Reset)
    @PostMapping("/users/change-password")
    public String changeUserPassword(@RequestParam("id") Long userId,
                                     @RequestParam("newPassword") String newPassword) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
        }
        return "redirect:/admin/users";
    }

    // Xóa user
    @GetMapping("/users/delete/{id}")
    public String deleteUser(@PathVariable Long id) {
        try {
            userRepository.deleteById(id);
        } catch (Exception e) {
            System.out.println("Không thể xóa user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // 5. PROFILE (Đổi mật khẩu cho chính Admin)
    @GetMapping("/profile")
    public String adminProfile(Model model, Principal principal) {
        User user = userRepository.findByUsername(principal.getName()).orElse(null);
        model.addAttribute("user", user);
        return "admin/profile";
    }

    @PostMapping("/profile/change-password")
    public String adminChangePassword(@RequestParam String oldPassword,
                                      @RequestParam String newPassword,
                                      @RequestParam String confirmPassword,
                                      Principal principal) {
        User user = userRepository.findByUsername(principal.getName()).orElse(null);
        
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            return "redirect:/admin/profile?error=old_pass_wrong";
        }
        if (!newPassword.equals(confirmPassword)) {
            return "redirect:/admin/profile?error=confirm_pass_wrong";
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return "redirect:/admin/profile?success=true";
    }
   // 6. QUẢN LÝ NGUYÊN LIỆU (TÍNH THEO NGÀY)
    @GetMapping("/ingredients")
    public String ingredientManager(Model model, 
                                    @RequestParam(value = "keyword", required = false) String keyword,
                                    @RequestParam(value = "filterDate", required = false) LocalDate filterDate) {
        
        String searchKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        
        if (searchKeyword != null || filterDate != null) {
            model.addAttribute("ingredients", ingredientRepository.searchIngredients(searchKeyword, filterDate));
        } else {
            // Mặc định in ra theo ngày mới nhất
            model.addAttribute("ingredients", ingredientRepository.findAll(Sort.by(Sort.Direction.DESC, "importDate")));
        }
        
        model.addAttribute("keyword", searchKeyword);
        model.addAttribute("filterDate", filterDate);
        return "admin/ingredients";
    }

    @PostMapping("/ingredients/add")
    public String addIngredient(@ModelAttribute Ingredient ingredient) {
        if (ingredient.getImportDate() == null) {
            ingredient.setImportDate(LocalDate.now()); // Nếu quên chọn thì lấy ngày hiện tại
        }
        ingredientRepository.save(ingredient);
        return "redirect:/admin/ingredients";
    }

    @PostMapping("/ingredients/update")
    public String updateIngredient(@ModelAttribute Ingredient ingredient) {
        Ingredient existing = ingredientRepository.findById(ingredient.getId()).orElse(null);
        if (existing != null) {
            existing.setName(ingredient.getName());
            existing.setQuantity(ingredient.getQuantity());
            existing.setUnit(ingredient.getUnit());
            existing.setPrice(ingredient.getPrice());
            if (ingredient.getImportDate() != null) {
                existing.setImportDate(ingredient.getImportDate());
            }
            ingredientRepository.save(existing);
        }
        return "redirect:/admin/ingredients";
    }

    @GetMapping("/ingredients/delete/{id}")
    public String deleteIngredient(@PathVariable Long id) {
        try { ingredientRepository.deleteById(id); } catch (Exception e) {}
        return "redirect:/admin/ingredients";
    }
    
    // 7. QUẢN LÝ HÓA ĐƠN (Chỉ hiển thị đơn COMPLETED)
    @GetMapping("/invoices")
    public String invoiceManager(Model model,
                                 @RequestParam(value = "keyword", required = false) String keyword,
                                 @RequestParam(value = "date", required = false) String date) {
        
        String searchKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        String searchDate = (date != null && !date.trim().isEmpty()) ? date.trim() : null;

        if (searchKeyword != null || searchDate != null) {
            model.addAttribute("invoices", orderRepository.searchInvoices(searchKeyword, searchDate));
        } else {
            model.addAttribute("invoices", orderRepository.findAllCompletedOrders());
        }

        model.addAttribute("keyword", searchKeyword);
        model.addAttribute("date", searchDate);
        return "admin/invoices";
    }

    // Xem và In hóa đơn chi tiết
    @GetMapping("/invoices/print/{id}")
    public String printInvoice(@PathVariable Long id, Model model) {
        Order order = orderRepository.findById(id).orElse(null);
        if (order != null && "COMPLETED".equals(order.getStatus())) {
            model.addAttribute("order", order);
            return "admin/invoice-print"; // Gọi sang file giao diện in
        }
        return "redirect:/admin/invoices";
    }
}