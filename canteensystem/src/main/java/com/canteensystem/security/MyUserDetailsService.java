package com.canteensystem.security;

import com.canteensystem.entity.Role;
import com.canteensystem.entity.User;
import com.canteensystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class MyUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. Tìm user
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy user: " + username));
        
        // 2. Kiểm tra log ra màn hình (Xem tab Output bên dưới NetBeans khi chạy)
        System.out.println("Tim thay User: " + user.getUsername());
        System.out.println("Mat khau DB: " + user.getPassword());

        // 3. Xử lý quyền hạn (Fix lỗi NullPointerException)
        Set<Role> roles = user.getRoles();
        if (roles == null) {
            roles = new HashSet<>(); // Nếu null thì coi như rỗng, không để crash
            System.out.println("CANH BAO: User nay chua duoc cap Quyen (Role)!");
        }

        Collection<GrantedAuthority> authorities = roles.stream()
                .map(role -> new SimpleGrantedAuthority(role.getName()))
                .collect(Collectors.toList());

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                authorities
        );
    }
}