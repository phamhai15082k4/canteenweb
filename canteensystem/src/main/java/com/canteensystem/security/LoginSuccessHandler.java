package com.canteensystem.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Set;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        // 1. Lấy danh sách quyền của user vừa đăng nhập
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        // 2. Kiểm tra quyền và điều hướng
        if (roles.contains("ROLE_ADMIN")) {
            response.sendRedirect("/admin/dashboard"); // Admin -> Vào Dashboard
        } else if (roles.contains("ROLE_STAFF")) {
            response.sendRedirect("/admin/orders");    // Nhân viên -> Vào trang Đơn hàng
        } else {
            response.sendRedirect("/");                // Sinh viên/Khách -> Về trang chủ
        }
    }
}