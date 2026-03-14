<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hóa Đơn</title>
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
                <a href="/admin/invoices" class="active"><i class="bi bi-printer me-2"></i> Quản Lý Hóa Đơn</a>
                <a href="/admin/users"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                <a href="/admin/ingredients"><i class="bi bi-layers me-2"></i> Quản Lý Nguyên Liệu</a>
                <a href="/admin/profile"><i class="bi bi-gear me-2"></i> Đổi Mật Khẩu</a>
                <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
            </div>

            <div class="col-md-10 offset-md-2 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold mb-1" style="color: var(--brand-color-dark); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                            <i class="bi bi-printer-fill text-warning me-2"></i> Lưu Trữ Hóa Đơn
                        </h4>
                        <span class="text-muted small">Danh sách các đơn hàng đã thanh toán thành công</span>
                    </div>
                </div>

                <div class="card filter-card mb-4">
                    <div class="card-body p-4 bg-white rounded-4">
                        <form action="/admin/invoices" method="get" class="row g-3 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted text-uppercase mb-2">Khách hàng (Mã SV / Tên)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px;"><i class="bi bi-person"></i></span>
                                    <input type="text" name="keyword" class="form-control border-start-0 ps-0" style="border-radius: 0 10px 10px 0;" placeholder="Nhập từ khóa tìm kiếm..." value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted text-uppercase mb-2">Ngày xuất hóa đơn</label>
                                <input type="date" name="date" class="form-control shadow-sm" value="${date}">
                            </div>
                            <div class="col-md-4 d-flex">
                                <button type="submit" class="btn btn-filter w-100 me-2 py-2"><i class="bi bi-funnel me-1"></i> Lọc Dữ Liệu</button>
                                <c:if test="${not empty keyword or not empty date}">
                                    <a href="/admin/invoices" class="btn btn-clear py-2 px-3" title="Xóa bộ lọc"><i class="bi bi-arrow-counterclockwise"></i></a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="custom-card p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4">Mã Hóa Đơn</th>
                                    <th>Ngày Giờ</th>
                                    <th>Khách Hàng</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-center pe-4">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${invoices}" var="inv">
                                    <tr>
                                        <td class="ps-4">
                                            <span class="invoice-badge">INV-${inv.id}</span>
                                        </td>
                                        <td class="text-muted"><i class="bi bi-calendar2-check me-1"></i> ${inv.orderDate}</td>
                                        <td>
                                            <div class="fw-bold" style="color: var(--brand-color-dark);">${inv.user.fullName}</div>
                                            <small class="text-muted"><i class="bi bi-person-badge"></i> ${inv.user.username}</small>
                                        </td>
                                        <td class="fw-bold text-danger fs-5">
                                            <fmt:formatNumber value="${inv.totalAmount}" type="currency" currencySymbol="đ"/>
                                        </td>
                                        <td>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                                <i class="bi bi-check-circle-fill me-1"></i> Đã thanh toán
                                            </span>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href="/admin/invoices/print/${inv.id}" target="_blank" class="btn btn-sm btn-light border text-dark fw-bold shadow-sm rounded-pill px-3" style="transition: all 0.2s;" onmouseover="this.style.backgroundColor='#1b4d3e'; this.style.color='white';" onmouseout="this.style.backgroundColor='white'; this.style.color='#212529';">
                                                <i class="bi bi-printer me-1"></i> In Bill
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty invoices}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-receipt fs-1 d-block mb-2 opacity-50"></i>
                                            Không tìm thấy hóa đơn nào.
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
</body>
</html>