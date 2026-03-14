<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - The Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
</head>
<body>

    <div class="register-card">
        
        <a href="/" class="btn-back" title="Quay lại Trang chủ"><i class="bi bi-arrow-left-circle-fill"></i></a>

        <div class="register-header">
            <h3 class="mb-2">GIA NHẬP CANTEEN</h3>
            <p class="mb-0 text-white-50" style="font-size: 0.95rem;">Đăng ký tài khoản để dễ dàng đặt món mỗi ngày</p>
        </div>
        
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center rounded-3 border-danger border-opacity-25 p-3 mb-4">
                    <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i> 
                    <div>${error}</div>
                </div>
            </c:if>

            <form action="/register" method="post">
                
                <div class="form-floating mb-3">
                    <input type="text" name="username" class="form-control" id="floatingUsername" placeholder="Tên đăng nhập" required>
                    <label for="floatingUsername"><i class="bi bi-person-circle"></i>Tên đăng nhập (Viết liền, không dấu)</label>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="text" name="fullName" class="form-control" id="floatingName" placeholder="Họ và tên" required>
                    <label for="floatingName"><i class="bi bi-person-vcard"></i>Họ và Tên đầy đủ</label>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="text" name="phone" class="form-control" id="floatingPhone" placeholder="Số điện thoại" required>
                            <label for="floatingPhone"><i class="bi bi-telephone-fill"></i>Số điện thoại</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="email" name="email" class="form-control" id="floatingEmail" placeholder="Email">
                            <label for="floatingEmail"><i class="bi bi-envelope-fill"></i>Email (Tùy chọn)</label>
                        </div>
                    </div>
                </div>

                <div class="form-floating mb-3">
                    <input type="password" name="password" class="form-control" id="floatingPassword" placeholder="Mật khẩu" required>
                    <label for="floatingPassword"><i class="bi bi-lock-fill"></i>Mật khẩu</label>
                </div>

                <div class="form-floating mb-4">
                    <input type="password" name="confirmPassword" class="form-control" id="floatingConfirmPass" placeholder="Xác nhận mật khẩu" required>
                    <label for="floatingConfirmPass"><i class="bi bi-shield-lock-fill"></i>Xác nhận lại Mật khẩu</label>
                </div>

                <button type="submit" class="btn btn-register btn-warning text-white w-100">
                    <i class="bi bi-person-plus-fill me-2"></i> TẠO TÀI KHOẢN NGAY
                </button>

            </form>

            <div class="text-center mt-4 pt-3 border-top">
                <p class="mb-0 text-muted">Đã có tài khoản? 
                    <a href="/login" class="text-decoration-none fw-bold" style="color: var(--primary-color-dark);">
                        Đăng nhập tại đây
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>