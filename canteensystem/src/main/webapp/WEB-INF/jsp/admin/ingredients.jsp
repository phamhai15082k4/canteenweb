<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Nguyên Liệu Kho</title>
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
                    <a href="/admin/users"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                    <a href="/admin/ingredients" class="active"><i class="bi bi-layers me-2"></i> Quản Lý Nguyên Liệu</a>
                    <a href="/admin/profile"><i class="bi bi-gear me-2"></i> Đổi Mật Khẩu</a>
                    <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
                </div>

                <div class="col-md-10 offset-md-2 p-4">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold mb-1" style="color: var(--brand-color-dark); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                <i class="bi bi-layers text-warning me-2"></i> Quản Lý Kho (Nhập/Xuất)
                            </h4>
                            <span class="text-muted small">Kiểm soát nguyên liệu nhập vào mỗi ngày</span>
                        </div>

                        <div class="d-flex align-items-center">
                            <form action="/admin/ingredients" method="get" class="d-flex me-3">
                                <input type="date" name="filterDate" class="form-control filter-date me-2 shadow-sm" value="${filterDate}" title="Lọc theo ngày nhập">
                                <div class="input-group search-bar shadow-sm" style="border-radius: 20px;">
                                    <input type="text" name="keyword" class="form-control" placeholder="Tên nguyên liệu..." value="${keyword}">
                                    <button type="submit" class="btn btn-search"><i class="bi bi-search"></i></button>
                                </div>
                                <c:if test="${not empty keyword or not empty filterDate}">
                                    <a href="/admin/ingredients" class="btn btn-light rounded-circle ms-2 shadow-sm text-danger d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;" title="Xóa bộ lọc"><i class="bi bi-x-lg"></i></a>
                                </c:if>
                            </form>

                            <button class="btn fw-bold text-white rounded-pill px-4 shadow-sm" style="background-color: var(--brand-color-dark); transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='translateY(0)'" data-bs-toggle="modal" data-bs-target="#addModal">
                                <i class="bi bi-plus-circle me-1"></i> Thêm Phiếu Nhập
                            </button>
                        </div>
                    </div>

                    <div class="custom-card p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Ngày Nhập</th>
                                        <th>Tên Nguyên Liệu</th>
                                        <th>Số Lượng</th>
                                        <th>Đơn Vị</th>
                                        <th>Đơn Giá Nhập</th>
                                        <th>Tổng Tiền</th>
                                        <th class="text-center pe-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${ingredients}" var="i">
                                        <tr>
                                            <td class="ps-4">
                                                <span class="badge bg-light text-dark border border-secondary px-2 py-1"><i class="bi bi-calendar-event me-1 text-muted"></i>${i.importDate}</span>
                                            </td>
                                            <td class="fw-bold" style="color: var(--brand-color-dark);">${i.name}</td>
                                            <td>
                                                <span class="fs-6 fw-bold p-2 rounded" style="background-color: rgba(255, 152, 0, 0.1); color: var(--brand-color-dark);">${i.quantity}</span>
                                            </td>
                                            <td class="text-muted">${i.unit}</td>
                                            <td class="text-muted"><fmt:formatNumber value="${i.price}" type="currency" currencySymbol="đ"/></td>
                                            <td class="fw-bold text-danger"><fmt:formatNumber value="${i.price * i.quantity}" type="currency" currencySymbol="đ"/></td>
                                            <td class="text-center pe-4">
                                                <button class="btn btn-sm btn-light text-warning border shadow-sm me-1 rounded-circle" style="width: 35px; height: 35px;"
                                                        data-id="${i.id}" data-name="${i.name}" data-date="${i.importDate}"
                                                        data-quantity="${i.quantity}" data-unit="${i.unit}" data-price="${i.price}"
                                                        onclick="openEditModal(this)" title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>
                                                <a href="/admin/ingredients/delete/${i.id}" class="btn btn-sm btn-light text-danger border shadow-sm rounded-circle" style="width: 35px; height: 35px;" onclick="return confirm('Xóa phiếu nhập này?');" title="Xóa">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty ingredients}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                <i class="bi bi-box-seam fs-1 d-block mb-2 opacity-50"></i>
                                                Không có dữ liệu nguyên liệu phù hợp.
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

        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" style="color: var(--brand-color-dark);"><i class="bi bi-plus-circle-fill text-warning me-2"></i> Lưu Kho Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/ingredients/add" method="post">
                        <div class="modal-body px-4">
                            <div class="mb-3 bg-light p-3 rounded border">
                                <label class="form-label text-muted fw-bold small text-uppercase">Ngày nhập kho</label>
                                <input type="date" name="importDate" class="form-control bg-white" required>
                                <small class="text-muted mt-1 d-block"><i class="bi bi-info-circle"></i> Nếu không chọn, hệ thống sẽ lấy ngày hôm nay.</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên nguyên liệu</label>
                                <input type="text" name="name" class="form-control" required placeholder="VD: Gạo ST25, Thịt bò...">
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-bold">Số lượng</label>
                                    <input type="number" step="0.1" name="quantity" class="form-control" required placeholder="0.0">
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-bold">Đơn vị tính</label>
                                    <input type="text" name="unit" class="form-control" required placeholder="kg, lít, bó...">
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold">Đơn giá nhập / 1 đơn vị (VNĐ)</label>
                                <input type="number" name="price" class="form-control text-danger fw-bold" required placeholder="0">
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn text-white rounded-pill px-4 fw-bold shadow-sm" style="background-color: var(--brand-color-dark);">Lưu vào kho</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" style="color: var(--brand-color-dark);"><i class="bi bi-pencil-square text-warning me-2"></i> Cập Nhật Phiếu Nhập</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/ingredients/update" method="post">
                        <div class="modal-body px-4">
                            <input type="hidden" name="id" id="edit_id">
                            <div class="mb-3 bg-light p-3 rounded border">
                                <label class="form-label text-muted fw-bold small text-uppercase">Ngày nhập kho</label>
                                <input type="date" name="importDate" id="edit_date" class="form-control bg-white" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên nguyên liệu</label>
                                <input type="text" name="name" id="edit_name" class="form-control" required>
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-bold">Số lượng</label>
                                    <input type="number" step="0.1" name="quantity" id="edit_quantity" class="form-control" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-bold">Đơn vị tính</label>
                                    <input type="text" name="unit" id="edit_unit" class="form-control" required>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold">Đơn giá nhập (VNĐ)</label>
                                <input type="number" name="price" id="edit_price" class="form-control text-danger fw-bold" required>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function openEditModal(button) {
                document.getElementById('edit_id').value = button.getAttribute('data-id');
                document.getElementById('edit_date').value = button.getAttribute('data-date');
                document.getElementById('edit_name').value = button.getAttribute('data-name');
                document.getElementById('edit_quantity').value = button.getAttribute('data-quantity');
                document.getElementById('edit_unit').value = button.getAttribute('data-unit');
                document.getElementById('edit_price').value = button.getAttribute('data-price');
                var myModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editModal'));
                myModal.show();
            }
        </script>
    </body>
</html>