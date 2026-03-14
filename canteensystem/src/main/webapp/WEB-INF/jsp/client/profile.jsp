<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - The Canteen</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&family=Playfair+Display:ital,wght@0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="bi bi-shop-window me-2"></i> THE CANTEEN
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <i class="bi bi-list fs-1 text-dark"></i>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="/">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="/menu">Thực đơn</a></li>

                    <c:if test="${pageContext.request.userPrincipal.name != null}">
                        <li class="nav-item dropdown ms-lg-4 mt-3 mt-lg-0">
                            <a class="btn btn-warning rounded-pill px-4 py-2 fw-bold dropdown-toggle d-flex align-items-center text-dark shadow-sm" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-5 me-2 text-white"></i> ${pageContext.request.userPrincipal.name}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg" style="border-radius: 12px; margin-top: 10px;">
                                <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                                    <li><a class="dropdown-item fw-bold text-warning" href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Trang Quản Trị</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li><a class="dropdown-item py-2" href="/history"><i class="bi bi-clock-history me-2"></i> Lịch sử đơn hàng</a></li>
                                <li><a class="dropdown-item py-2" href="/cart"><i class="bi bi-cart3 me-2"></i> Giỏ hàng của tôi</a></li> 
                                <li><a class="dropdown-item py-2 fw-bold text-primary bg-light" href="/profile"><i class="bi bi-person-gear me-2"></i> Hồ sơ của tôi</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-danger fw-bold" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                
                <div class="profile-card">
                    <div class="profile-cover">
                        <div class="profile-avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>
                    </div>
                    
                    <div class="profile-body">
                        <div class="text-center mb-5">
                            <h2 class="fw-bold mb-1" style="color: var(--secondary-color);">${user.fullName != null ? user.fullName : 'Tên Khách Hàng'}</h2>
                            <span class="badge bg-light text-dark border px-3 py-2 rounded-pill"><i class="bi bi-at text-muted"></i>${user.username}</span>
                        </div>

                        <c:if test="${param.success == 'info'}">
                            <div class="alert alert-success d-flex align-items-center rounded-3 border-success border-opacity-25 mb-4">
                                <i class="bi bi-check-circle-fill fs-5 me-2"></i> Đã cập nhật thông tin cá nhân thành công!
                            </div>
                        </c:if>
                        <c:if test="${param.success == 'password'}">
                            <div class="alert alert-success d-flex align-items-center rounded-3 border-success border-opacity-25 mb-4">
                                <i class="bi bi-check-circle-fill fs-5 me-2"></i> Đổi mật khẩu thành công!
                            </div>
                        </c:if>
                        <c:if test="${param.error == 'old_pass_wrong'}">
                            <div class="alert alert-danger d-flex align-items-center rounded-3 border-danger border-opacity-25 mb-4">
                                <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i> Mật khẩu cũ không chính xác!
                            </div>
                        </c:if>
                        <c:if test="${param.error == 'confirm_pass_wrong'}">
                            <div class="alert alert-danger d-flex align-items-center rounded-3 border-danger border-opacity-25 mb-4">
                                <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i> Mật khẩu xác nhận không khớp!
                            </div>
                        </c:if>

                        <div class="row g-5">
                            <div class="col-md-6 border-end-md">
                                <h4 class="section-title">Thông Tin Cá Nhân</h4>
                                
                                <form action="/profile/update-info" method="post">
                                    <div class="form-floating mb-3">
                                        <input type="text" class="form-control" id="floatingUsername" value="${user.username}" readonly>
                                        <label for="floatingUsername"><i class="bi bi-person-lock"></i> Tên đăng nhập (Không đổi)</label>
                                    </div>
                                    
                                    <div class="form-floating mb-3">
                                        <input type="text" name="fullName" class="form-control" id="floatingName" value="${user.fullName}" required placeholder="Họ và tên">
                                        <label for="floatingName"><i class="bi bi-person-vcard"></i> Họ và Tên</label>
                                    </div>

                                    <div class="form-floating mb-4">
                                        <input type="text" name="phone" class="form-control" id="floatingPhone" value="${user.phone}" placeholder="Số điện thoại" required>
                                        <label for="floatingPhone"><i class="bi bi-telephone"></i> Số điện thoại</label>
                                    </div>

                                    <button type="submit" class="btn btn-update btn-custom w-100">
                                        <i class="bi bi-floppy"></i> Cập Nhật Thông Tin
                                    </button>
                                </form>
                            </div>

                            <div class="col-md-6">
                                <h4 class="section-title">Bảo Mật Tài Khoản</h4>

                                <form action="/profile/change-password" method="post">
                                    <div class="form-floating mb-3">
                                        <input type="password" name="oldPassword" class="form-control" id="floatingOldPass" placeholder="Mật khẩu cũ" required>
                                        <label for="floatingOldPass"><i class="bi bi-key"></i> Mật khẩu hiện tại</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="password" name="newPassword" class="form-control" id="floatingNewPass" placeholder="Mật khẩu mới" required>
                                        <label for="floatingNewPass"><i class="bi bi-lock"></i> Mật khẩu mới</label>
                                    </div>

                                    <div class="form-floating mb-4">
                                        <input type="password" name="confirmPassword" class="form-control" id="floatingConfirm" placeholder="Xác nhận mật khẩu" required>
                                        <label for="floatingConfirm"><i class="bi bi-shield-check"></i> Nhập lại mật khẩu mới</label>
                                    </div>

                                    <button type="submit" class="btn btn-outline-dark btn-custom w-100 border-2">
                                        <i class="bi bi-shield-lock"></i> Đổi Mật Khẩu
                                    </button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>