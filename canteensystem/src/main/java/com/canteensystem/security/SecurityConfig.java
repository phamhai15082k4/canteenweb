package com.canteensystem.security; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private LoginSuccessHandler loginSuccessHandler;
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                
                // ĐÃ THÊM "/menu", "/menu/**" VÀ "/img/**" VÀO ĐÂY ĐỂ MỞ KHÓA
                .requestMatchers("/", "/home", "/menu", "/menu/**", "/login", "/register", "/product/**", "/css/**", "/js/**", "/img/**", "/images/**", "/WEB-INF/jsp/**").permitAll()
                
                .requestMatchers("/admin/orders/**", "/admin/profile/**").hasAnyRole("ADMIN", "STAFF")
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/perform_login")
                .defaultSuccessUrl("/", true)
                .successHandler(loginSuccessHandler)
                .failureUrl("/?error=true") // Nếu sai pass thì báo lỗi
                .permitAll()
            )   
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .permitAll()
            )
            .csrf(csrf -> csrf.disable()); // Tắt CSRF để test cho dễ

        return http.build();
    }
}