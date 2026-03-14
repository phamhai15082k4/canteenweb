<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Đơn Hàng</title>

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

                    <a href="/admin/orders" class="active"><i class="bi bi-receipt me-2"></i> Quản Lý Đơn Hàng</a>
                    <a href="/admin/invoices"><i class="bi bi-printer me-2"></i> Quản Lý Hóa Đơn</a>

                    <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                        <a href="/admin/users"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                    </c:if>
                    
                    <a href="/admin/ingredients"><i class="bi bi-layers me-2"></i> Quản Lý Nguyên Liệu</a>
                    <a href="/admin/profile"><i class="bi bi-person-gear me-2"></i> Đổi Mật Khẩu</a>
                    <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
                </div>

                <div class="col-md-10 offset-md-2 p-4">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold mb-1" style="color: var(--brand-color-dark); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                <i class="bi bi-receipt text-warning me-2"></i> Danh Sách Đơn Hàng
                            </h4>
                            <span class="text-muted small">Cập nhật và xử lý trạng thái món ăn theo thời gian thực</span>
                        </div>
                    </div>

                    <div class="card filter-card mb-4">
                        <div class="card-body p-4 bg-white rounded-4">
                            <form action="/admin/orders" method="get" class="row g-3 align-items-end">
                                <div class="col-md-2">
                                    <label class="form-label small fw-bold text-muted text-uppercase mb-2">Mã Đơn</label>
                                    <input type="number" name="orderId" class="form-control" placeholder="VD: 1" value="${orderId}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-muted text-uppercase mb-2">Khách hàng</label>
                                    <input type="text" name="username" class="form-control" placeholder="Tên hoặc mã SV..." value="${username}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-muted text-uppercase mb-2">Ngày đặt</label>
                                    <input type="date" name="orderDate" class="form-control" value="${orderDate}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label small fw-bold text-muted text-uppercase mb-2">Trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="">-- Tất cả --</option>
                                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                        <option value="COOKING" ${status == 'COOKING' ? 'selected' : ''}>Đang nấu</option>
                                        <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Đã xong</option>
                                        <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex">
                                    <button type="submit" class="btn btn-filter w-100 py-2"><i class="bi bi-funnel me-1"></i> Lọc</button>
                                    <c:if test="${not empty orderId or not empty username or not empty orderDate or not empty status}">
                                        <a href="/admin/orders" class="btn btn-clear py-2 px-3 ms-2" title="Xóa bộ lọc"><i class="bi bi-arrow-counterclockwise"></i></a>
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
                                        <th class="ps-4">Mã Đơn</th>
                                        <th>Người đặt</th>
                                        <th>Thời gian</th>
                                        <th style="width: 25%">Chi tiết món ăn</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center pe-4" style="width: 22%">Hành động</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach items="${orders}" var="o">
                                        <tr>
                                            <td class="ps-4">
                                                <span class="badge bg-light text-dark border px-2 py-1 fs-6">#${o.id}</span>
                                            </td>
                                            <td>
                                                <div class="fw-bold" style="color: var(--brand-color-dark);">${o.user.fullName}</div>
                                                <small class="text-muted">${o.user.username}</small>
                                            </td>
                                            <td>
                                                <span class="text-muted"><i class="bi bi-clock me-1"></i><fmt:formatDate value="${o.orderDate}" pattern="HH:mm"/></span><br>
                                                <small class="text-muted"><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy"/></small>
                                            </td>
                                            <td>
                                                <div class="bg-light p-2 rounded" style="font-size: 0.85rem;">
                                                    <c:forEach items="${o.orderDetails}" var="d" varStatus="loop">
                                                        <div class="${!loop.last ? 'border-bottom pb-1 mb-1' : ''} d-flex justify-content-between">
                                                            <span class="fw-bold text-secondary">${d.product.name}</span>
                                                            <span class="text-danger fw-bold">x${d.quantity}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td class="text-danger fw-bold fs-6">
                                                <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            
                                            <td>
                                                <c:choose>
                                                    <c:when test="${o.status == 'PENDING'}">
                                                        <span class="badge bg-warning bg-opacity-25 text-dark border border-warning px-2 py-1"><i class="bi bi-hourglass-split me-1"></i> Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'COOKING'}">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-2 py-1"><i class="bi bi-fire me-1"></i> Đang nấu</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'READY'}">
                                                        <span class="badge bg-info bg-opacity-10 text-info border border-info px-2 py-1"><i class="bi bi-bell-fill me-1"></i> Chờ nhận món</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'COMPLETED'}">
                                                        <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1"><i class="bi bi-check-circle-fill me-1"></i> Đã xong</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1"><i class="bi bi-x-circle-fill me-1"></i> Đã hủy</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="pe-4">
                                                <form action="/admin/orders/update-status" method="post" class="order-action-box">
                                                    <input type="hidden" name="id" value="${o.id}">

                                                    <c:if test="${o.status == 'PENDING'}">
                                                        <div class="input-group input-group-sm mb-2 shadow-sm">
                                                            <span class="input-group-text text-muted"><i class="bi bi-clock-history"></i></span>
                                                            <input type="number" name="waitTime" class="form-control" placeholder="T/g nấu" value="15" min="5" max="60">
                                                            <span class="input-group-text bg-white text-muted" style="font-size: 0.75rem;">Phút</span>
                                                        </div>
                                                        <div class="d-flex gap-2">
                                                            <button type="submit" name="status" value="COOKING" class="btn text-white w-100 shadow-sm" style="background-color: var(--brand-color-dark);">
                                                                <i class="bi bi-fire"></i> Nấu
                                                            </button>
                                                            <button type="submit" name="status" value="CANCELLED" class="btn btn-outline-danger w-100" onclick="return confirm('Xác nhận hủy đơn hàng này?');">
                                                                <i class="bi bi-x-lg"></i> Hủy
                                                            </button>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${o.status == 'COOKING'}">
                                                        <button type="submit" name="status" value="READY" class="btn btn-success w-100 mb-2 shadow-sm">
                                                            <i class="bi bi-check2-all"></i> Đã nấu xong
                                                        </button>
                                                        <div class="alert alert-info py-1 px-2 text-center small mb-0 rounded-3">
                                                            <i class="bi bi-info-circle me-1"></i> Bếp báo đợi <strong>${o.waitTime} phút</strong>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${o.status == 'READY'}">
                                                        <button type="submit" name="status" value="COMPLETED" class="btn btn-secondary w-100 shadow-sm">
                                                            <i class="bi bi-box-arrow-right"></i> Giao cho khách
                                                        </button>
                                                    </c:if>
                                                    
                                                    <c:if test="${o.status == 'COMPLETED' or o.status == 'CANCELLED'}">
                                                        <div class="text-center text-muted small py-2">
                                                            <i class="bi bi-shield-lock me-1"></i> Đơn đã đóng
                                                        </div>
                                                    </c:if>

                                                </form>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-2 opacity-50"></i>
                                                Chưa có đơn hàng nào.
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>