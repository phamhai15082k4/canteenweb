package com.canteensystem;

import com.canteensystem.entity.Role;
import com.canteensystem.entity.User;
//import com.canteensystem.repository.RoleRepository; // Bạn cần tạo repo này nếu chưa có, xem bước 2
import com.canteensystem.repository.UserRepository;
import com.canteensystem.entity.User;
import com.canteensystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import java.util.HashSet;
import java.util.Set;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        String username = "admin";
        String rawPassword = "123456";

        // 1. Kiểm tra xem admin đã có chưa
        User user = userRepository.findByUsername(username).orElse(null);

        // 2. Nếu chưa có thì tạo mới, nếu có rồi thì reset mật khẩu
        if (user == null) {
            user = new User();
            user.setUsername(username);
            user.setFullName("Quản Trị Viên");
        }

      
        user.setPassword(passwordEncoder.encode(rawPassword));
        
        // Đảm bảo admin có quyền
       
        userRepository.save(user);
        
        System.out.println("---------------------------------------------");
        System.out.println("DA RESET MAT KHAU ADMIN THANH CONG!");
        System.out.println("User: " + username);
        System.out.println("Pass: " + rawPassword);
        System.out.println("---------------------------------------------");
    }
}