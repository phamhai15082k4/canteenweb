<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Tài Khoản - Admin</title>

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
                        CANTEEN<br><span style="font-size: 0.9rem; font-weight: normal; font-family: sans-serif; opacity: 0.9;">Management System</span>
                    </h4>
                    <a href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Tổng Quan</a>
                    <a href="/admin/products"><i class="bi bi-box-seam me-2"></i> Quản Lý Món Ăn</a>
                    <a href="/admin/orders"><i class="bi bi-receipt me-2"></i> Quản Lý Đơn Hàng</a>
                    <a href="/admin/invoices"><i class="bi bi-printer me-2"></i> Quản Lý Hóa Đơn</a>
                    <a href="/admin/users" class="active"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                    <a href="/admin/ingredients"><i class="bi bi-layers me-2"></i> Quản Lý Nguyên Liệu </a>
                    <a href="/admin/profile"><i class="bi bi-gear me-2"></i> Đổi Mật Khẩu</a>
                    <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
                </div>

                <div class="col-md-10 offset-md-2 p-4">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold mb-1" style="color: var(--brand-color-dark); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                <i class="bi bi-people-fill text-warning me-2"></i> Danh Sách Người Dùng
                            </h4>
                            <span class="text-muted small">Quản lý nhân viên, khách hàng và phân quyền hệ thống</span>
                        </div>
                        
                        <div class="d-flex align-items-center">
                            <form action="/admin/users" method="get" class="d-flex me-3">
                                <div class="input-group shadow-sm" style="border-radius: 20px;">
                                    <input type="text" name="keyword" class="form-control border-end-0" style="border-radius: 20px 0 0 20px;" placeholder="Tìm theo mã hoặc tên..." value="${keyword}">
                                    <button type="submit" class="btn bg-white border border-start-0 text-muted" style="border-radius: 0 20px 20px 0;" title="Tìm kiếm"><i class="bi bi-search"></i></button>
                                </div>
                                <c:if test="${not empty keyword}">
                                    <a href="/admin/users" class="btn btn-light rounded-circle ms-2 shadow-sm text-danger d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;" title="Hủy tìm kiếm"><i class="bi bi-x-lg"></i></a>
                                </c:if>
                            </form>

                            <button class="btn btn-success rounded-pill px-4 shadow-sm me-2 fw-bold" style="transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='translateY(0)'" data-bs-toggle="modal" data-bs-target="#importModal">
                                <i class="bi bi-file-earmark-spreadsheet me-1"></i> Excel
                            </button>

                            <button class="btn text-white rounded-pill px-4 shadow-sm fw-bold" style="background-color: var(--brand-color-dark); transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='translateY(0)'" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                <i class="bi bi-person-plus me-1"></i> Thêm User
                            </button>
                        </div>
                    </div>

                    <div class="custom-card p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Tên đăng nhập</th>
                                        <th>Họ và tên</th>
                                        <th>Email</th>
                                        <th>Quyền hạn</th>
                                        <th class="text-center pe-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="u">
                                        <tr>
                                            <td class="ps-4 fw-bold text-muted">#${u.id}</td>
                                            <td class="fw-bold" style="color: var(--brand-color-dark);">
                                                <i class="bi bi-person-circle me-1 text-warning"></i> @${u.username}
                                            </td>
                                            <td class="fw-bold text-secondary">${u.fullName}</td>
                                            <td class="text-muted">${u.email}</td>
                                            <td>
                                                <c:forEach items="${u.roles}" var="role">
                                                    <span class="badge bg-info bg-opacity-10 text-info border border-info px-2 py-1">
                                                        <i class="bi bi-shield-lock-fill me-1"></i>${role.name}
                                                    </span>
                                                </c:forEach>
                                            </td>
                                            <td class="text-center pe-4">
                                                <button class="btn btn-sm btn-light text-primary border shadow-sm me-1 rounded-circle" style="width: 35px; height: 35px;"
                                                        data-id="${u.id}" data-username="${u.username}"
                                                        onclick="openPassModal(this)" title="Cấp lại mật khẩu">
                                                    <i class="bi bi-key-fill"></i>
                                                </button>

                                                <button class="btn btn-sm btn-light text-warning border shadow-sm me-1 rounded-circle" style="width: 35px; height: 35px;"
                                                        data-id="${u.id}" data-username="${u.username}" data-fullname="${u.fullName}"
                                                        data-email="${u.email}" data-phone="${u.phone}"
                                                        data-role="${u.roles.isEmpty() ? 3 : u.roles.stream().findFirst().get().id}"
                                                        onclick="openEditUserModal(this)" title="Sửa thông tin">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>

                                                <c:if test="${u.username != pageContext.request.userPrincipal.name}">
                                                    <a href="/admin/users/delete/${u.id}" class="btn btn-sm btn-light text-danger border shadow-sm rounded-circle" style="width: 35px; height: 35px;"
                                                       onclick="return confirm('Xóa tài khoản này vĩnh viễn?');" title="Xóa tài khoản">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="bi bi-people fs-1 d-block mb-2 opacity-50"></i>
                                                Không tìm thấy người dùng nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="modal fade" id="addUserModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" style="color: var(--brand-color-dark);">
                            <i class="bi bi-person-plus-fill text-warning me-2"></i> Thêm Tài Khoản Mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/users/add" method="post">
                        <div class="modal-body px-4">
                            <div class="mb-3">
                                <label class="form-label"><i class="bi bi-person"></i> Tên đăng nhập (MSV) <span class="text-danger">*</span></label>
                                <input type="text" name="username" class="form-control" required placeholder="Nhập tên đăng nhập...">
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><i class="bi bi-person-badge"></i> Họ và tên</label>
                                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A">
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><i class="bi bi-envelope"></i> Email</label>
                                <input type="email" name="email" class="form-control" placeholder="abc@gmail.com">
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><i class="bi bi-shield-lock"></i> Phân quyền hệ thống</label>
                                <select name="roleId" class="form-select">
                                    <c:forEach items="${roles}" var="r">
                                        <option value="${r.id}">${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="alert alert-warning small border-warning bg-opacity-25 rounded-3">
                                <i class="bi bi-info-circle-fill me-1"></i> Mật khẩu đăng nhập mặc định sẽ là: <strong>123456</strong>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn text-white rounded-pill px-4 fw-bold shadow-sm" style="background-color: var(--brand-color-dark);">Lưu tài khoản</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="importModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-success">
                            <i class="bi bi-file-earmark-excel-fill me-2"></i> Nhập từ Excel
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/users/import" method="post" enctype="multipart/form-data">
                        <div class="modal-body px-4">
                            <div class="mb-4">
                                <label class="form-label fw-bold text-muted">Chọn file tải lên (.xlsx, .xls)</label>
                                <input type="file" name="file" class="form-control form-control-lg bg-light" accept=".xlsx, .xls" required>
                            </div>
                            <div class="p-3 bg-light rounded-3 border small">
                                <strong class="text-dark d-block mb-2"><i class="bi bi-exclamation-triangle text-warning me-1"></i> Cấu trúc file Excel yêu cầu:</strong>
                                <ul class="mb-0 text-muted" style="line-height: 1.8;">
                                    <li>Cột 1 (A): Tên đăng nhập (MSV)</li>
                                    <li>Cột 2 (B): Họ và tên</li>
                                    <li>Cột 3 (C): Email</li>
                                    <li>Cột 4 (D): Số điện thoại</li>
                                </ul>
                                <hr class="my-2">
                                <span class="text-danger fw-bold">Lưu ý:</span> Bỏ qua dòng tiêu đề. Mật khẩu mặc định là 123456.
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold shadow-sm">Bắt đầu nhập</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editUserModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" style="color: var(--brand-color-dark);">
                            <i class="bi bi-pencil-square text-warning me-2"></i> Cập Nhật Thông Tin
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/users/update" method="post">
                        <div class="modal-body px-4">
                            <input type="hidden" name="id" id="edit_id">

                            <div class="mb-3 bg-light p-3 rounded-3 border">
                                <label class="form-label"><i class="bi bi-person text-secondary"></i> Tên đăng nhập</label>
                                <input type="text" name="username" id="edit_username" class="form-control fw-bold text-secondary bg-white" readonly>
                                <small class="text-danger mt-1 d-block"><i class="bi bi-slash-circle"></i> Không thể thay đổi tên đăng nhập</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><i class="bi bi-person-badge"></i> Họ và tên</label>
                                <input type="text" name="fullName" id="edit_fullname" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label"><i class="bi bi-envelope"></i> Email</label>
                                <input type="email" name="email" id="edit_email" class="form-control">
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label"><i class="bi bi-telephone"></i> Số điện thoại</label>
                                    <input type="text" name="phone" id="edit_phone" class="form-control">
                                </div>
                                <div class="col-6">
                                    <label class="form-label"><i class="bi bi-shield-lock"></i> Quyền hạn</label>
                                    <select name="roleId" id="edit_role" class="form-select">
                                        <c:forEach items="${roles}" var="r">
                                            <option value="${r.id}">${r.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn text-white rounded-pill px-4 fw-bold shadow-sm" style="background-color: var(--brand-color-dark);">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="passModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary">
                            <i class="bi bi-key-fill me-2"></i> Đổi Mật Khẩu User
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/users/change-password" method="post">
                        <div class="modal-body px-4">
                            <input type="hidden" name="id" id="pass_user_id">
                            
                            <div class="alert alert-primary bg-opacity-10 border-primary border-opacity-25 rounded-3 mb-4">
                                Đang thao tác cấp lại mật khẩu cho tài khoản:<br>
                                <strong id="pass_username" class="text-danger fs-5 d-block mt-1"></strong>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold"><i class="bi bi-lock-fill text-primary"></i> Nhập Mật khẩu mới</label>
                                <input type="text" name="newPassword" class="form-control form-control-lg border-primary" placeholder="Nhập mật khẩu an toàn..." required>
                                <small class="text-muted mt-2 d-block">Admin có quyền đặt lại mật khẩu mà không cần mật khẩu cũ.</small>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm"><i class="bi bi-floppy me-1"></i> Lưu Mật Khẩu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Hàm mở Modal Sửa User
            function openEditUserModal(button) {
                document.getElementById('edit_id').value = button.getAttribute('data-id');
                document.getElementById('edit_username').value = button.getAttribute('data-username');
                document.getElementById('edit_fullname').value = button.getAttribute('data-fullname');
                document.getElementById('edit_email').value = button.getAttribute('data-email');
                document.getElementById('edit_phone').value = button.getAttribute('data-phone');
                document.getElementById('edit_role').value = button.getAttribute('data-role');

                var myModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editUserModal'));
                myModal.show();
            }

            // Hàm mở Modal Đổi Mật Khẩu
            function openPassModal(button) {
                document.getElementById('pass_user_id').value = button.getAttribute('data-id');
                document.getElementById('pass_username').innerText = "@" + button.getAttribute('data-username');

                var passModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('passModal'));
                passModal.show();
            }
        </script>

    </body>
</html>