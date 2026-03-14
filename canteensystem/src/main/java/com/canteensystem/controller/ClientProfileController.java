package com.canteensystem.controller;

import com.canteensystem.entity.User;
import com.canteensystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
public class ClientProfileController {

    @Autowired private UserRepository userRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    // 1. Xem trang hồ sơ
    @GetMapping("/profile")
    public String viewProfile(Model model, Principal principal) {
        if (principal == null) return "redirect:/";
        
        User user = userRepository.findByUsername(principal.getName()).orElse(null);
        model.addAttribute("user", user);
        return "client/profile";
    }

    // 2. Xử lý đổi mật khẩu
    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 Principal principal) {
        
        User user = userRepository.findByUsername(principal.getName()).orElse(null);
        
        // 1. Kiểm tra mật khẩu cũ có đúng không
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            return "redirect:/profile?error=old_pass_wrong";
        }
        
        // 2. Kiểm tra mật khẩu mới và xác nhận có khớp không
        if (!newPassword.equals(confirmPassword)) {
            return "redirect:/profile?error=confirm_pass_wrong";
        }
        
        // 3. Lưu mật khẩu mới (Đã mã hóa)
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        
        return "redirect:/profile?success=true";
    }
}