<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ Sơ Của Tôi - Admin</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,400&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    </head>

    <body>

        <div class="container-fluid p-0">
            <div class="row g-0">

                <div class="col-md-2 p-0 sidebar py-4">
                    <h4 class="text-center fw-bold mb-4 fst-italic">
                        <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                            CANTEEN<br><span style="font-size: 0.9rem; font-weight: normal; font-family: sans-serif; opacity: 0.9;">Admin Panel</span>
                        </c:if>
                        <c:if test="${!pageContext.request.isUserInRole('ADMIN')}">
                            KITCHEN<br><span style="font-size: 0.9rem; font-weight: normal; font-family: sans-serif; opacity: 0.9;">Staff Panel</span>
                        </c:if>
                    </h4>

                    <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                        <a href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Tổng Quan</a>
                        <a href="/admin/products"><i class="bi bi-box-seam me-2"></i> Quản Lý Món Ăn</a>
                    </c:if>

                    <a href="/admin/orders"><i class="bi bi-receipt me-2"></i> Quản Lý Đơn Hàng</a>
                    <a href="/admin/invoices"><i class="bi bi-printer me-2"></i> Quản Lý Hóa Đơn</a>
                    
                    <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                        <a href="/admin/users"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                    </c:if>
                    
                    <a href="/admin/ingredients"><i class="bi bi-layers me-2"></i> Quản Lý Nguyên Liệu</a>

                    <a href="/admin/profile" class="active"><i class="bi bi-person-gear me-2"></i> Hồ Sơ Của Tôi</a>
                    <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
                </div>
                
                <div class="col-md-10 offset-md-2 p-5 d-flex flex-column align-items-center justify-content-center" style="min-height: 100vh;">

                    <div class="w-100 text-start mb-4" style="max-width: 550px;">
                        <h4 class="fw-bold mb-1" style="color: var(--brand-color-dark); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                            <i class="bi bi-person-circle text-warning me-2"></i> Hồ Sơ Của Tôi
                        </h4>
                        <span class="text-muted small">Cập nhật bảo mật cho tài khoản của bạn</span>
                    </div>

                    <div class="profile-card w-100">
                        <div class="profile-header">
                            <div class="user-avatar"><i class="bi bi-person-fill"></i></div>
                            <h4 class="fw-bold mb-1">${user.fullName}</h4>
                            <span class="badge bg-white text-dark px-3 py-2 rounded-pill"><i class="bi bi-at text-muted"></i>${user.username}</span>
                        </div>

                        <div class="card-body p-4 p-md-5">
                            
                            <h5 class="fw-bold mb-4 text-center" style="color: var(--brand-color-dark);">ĐỔI MẬT KHẨU</h5>

                            <c:if test="${param.error == 'old_pass_wrong'}">
                                <div class="alert alert-danger rounded-3 border-danger border-opacity-25 d-flex align-items-center">
                                    <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i> Mật khẩu cũ bạn nhập không chính xác!
                                </div>
                            </c:if>

                            <c:if test="${param.error == 'confirm_pass_wrong'}">
                                <div class="alert alert-danger rounded-3 border-danger border-opacity-25 d-flex align-items-center">
                                    <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i> Mật khẩu xác nhận không khớp với mật khẩu mới!
                                </div>
                            </c:if>

                            <c:if test="${param.success != null}">
                                <div class="alert alert-success rounded-3 border-success border-opacity-25 d-flex align-items-center">
                                    <i class="bi bi-check-circle-fill fs-5 me-2"></i> Đổi mật khẩu thành công! Hãy ghi nhớ mật khẩu mới nhé.
                                </div>
                            </c:if>

                            <form action="/admin/profile/change-password" method="post">

                                <div class="mb-3">
                                    <label class="form-label"><i class="bi bi-key"></i> Mật khẩu hiện tại</label>
                                    <input type="password" name="oldPassword" class="form-control" placeholder="Nhập mật khẩu đang dùng..." required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label"><i class="bi bi-lock"></i> Mật khẩu mới</label>
                                    <input type="password" name="newPassword" class="form-control" placeholder="Tạo mật khẩu an toàn..." required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label"><i class="bi bi-shield-check"></i> Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới..." required>
                                </div>

                                <button type="submit" class="btn w-100 text-white fw-bold py-3 rounded-pill shadow-sm" style="background-color: var(--brand-color-dark); font-size: 1.1rem; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='translateY(0)'">
                                    <i class="bi bi-floppy"></i> LƯU MẬT KHẨU
                                </button>

                            </form>

                        </div>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>