<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - Canteen Admin</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    </head>

    <body>
        <div class="container-fluid p-0">
            <div class="row g-0">

                <div class="col-md-2 sidebar py-4">
                    <h4 class="text-center fw-bold mb-4 fst-italic">
                        CANTEEN<br><span style="font-size: 0.9rem; font-weight: normal; font-family: sans-serif; opacity: 0.9;">Management System</span>
                    </h4>
                    <a href="/admin/dashboard" class="active"><i class="bi bi-speedometer2 me-2"></i> Tổng Quan</a>
                    <a href="/admin/products"><i class="bi bi-box-seam me-2"></i> Quản Lý Món Ăn</a>
                    <a href="/admin/orders"><i class="bi bi-receipt me-2"></i> Quản Lý Đơn Hàng</a>
                    <a href="/admin/invoices"><i class="bi bi-printer me-2"></i> Quản Lý Hóa Đơn</a>
                    <a href="/admin/users"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                    <a href="/admin/ingredients"><i class="bi bi-layers me-2"></i> Quản Lý Nguyên Liệu</a>
                    <a href="/admin/profile"><i class="bi bi-gear me-2"></i> Đổi Mật Khẩu</a>
                    <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
                </div>

                <div class="col-md-10 offset-md-2 p-4">

                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <div>
                            <h4 class="fw-bold mb-1">Awesome! Hệ thống đang hoạt động trơn tru.</h4>
                            <span class="text-muted small">Cập nhật dữ liệu tài chính theo thời gian thực</span>
                        </div>
                        <div class="text-end">
                            <span class="text-muted fw-bold d-block">Hi, Administration</span>
                            <span class="text-muted small"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMMM yyyy"/></span>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-3">
                            <div class="stat-box" style="background: linear-gradient(135deg, #FF9800, #F44336);">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="opacity-75" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Tổng Doanh Thu</span>
                                    <div class="icon-box"><i class="bi bi-cash-stack"></i></div>
                                </div>
                                <h4 class="fw-bold mb-0"><fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="đ"/></h4>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-box bg-warning text-dark">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="opacity-75" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Đơn Chờ Xử Lý</span>
                                    <div class="icon-box bg-white text-warning"><i class="bi bi-hourglass-split"></i></div>
                                </div>
                                <h4 class="fw-bold mb-0">${pendingOrders} <span style="font-size: 0.85rem; font-weight: normal; opacity: 0.7;">đơn</span></h4>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-box bg-success">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="opacity-75" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Tổng Món Ăn</span>
                                    <div class="icon-box"><i class="bi bi-box-seam"></i></div>
                                </div>
                                <h4 class="fw-bold mb-0">${totalProducts} <span style="font-size: 0.85rem; font-weight: normal; opacity: 0.7;">món</span></h4>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-box bg-info text-white">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="opacity-75" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Thành Viên</span>
                                    <div class="icon-box"><i class="bi bi-people"></i></div>
                                </div>
                                <h4 class="fw-bold mb-0">${totalUsers} <span style="font-size: 0.85rem; font-weight: normal; opacity: 0.7;">users</span></h4>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 align-items-stretch">
                        
                        <div class="col-lg-4 d-flex flex-column">
                            <h5 class="fw-bold mb-3" style="color: #E65100;"><i class="bi bi-graph-up-arrow me-2"></i> Báo Cáo Tài Chính</h5>
                            
                            <div class="d-flex flex-column gap-3 flex-grow-1">
                                <div class="dash-card flex-grow-1 d-flex flex-column justify-content-center">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="fw-bold text-success mb-0"><i class="bi bi-calendar-day me-1"></i> Theo Ngày</h6>
                                        <form action="/admin/dashboard" method="get">
                                            <input type="date" name="filterDate" class="form-control form-control-sm bg-light border-0" value="${selectedDate}" onchange="this.form.submit()">
                                        </form>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted small">Doanh thu:</span>
                                        <span class="fw-bold text-primary"><fmt:formatNumber value="${dailyRevenue}" type="currency" currencySymbol="đ"/></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted small">Chi phí:</span>
                                        <span class="fw-bold text-danger">- <fmt:formatNumber value="${dailyExpense}" type="currency" currencySymbol="đ"/></span>
                                    </div>
                                    <div class="border-top pt-2 mt-auto d-flex justify-content-between align-items-center">
                                        <span class="fw-bold small text-uppercase">Lợi nhuận:</span>
                                        <h5 class="fw-bold mb-0 ${dailyProfit >= 0 ? 'text-success' : 'text-secondary'}">
                                            <fmt:formatNumber value="${dailyProfit}" type="currency" currencySymbol="đ"/>
                                        </h5>
                                    </div>
                                </div>

                                <div class="dash-card flex-grow-1 d-flex flex-column justify-content-center mb-0">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="fw-bold text-primary mb-0"><i class="bi bi-calendar-month me-1"></i> Theo Tháng</h6>
                                        <form action="/admin/dashboard" method="get">
                                            <input type="month" name="filterMonth" class="form-control form-control-sm bg-light border-0" value="${selectedMonth}" onchange="this.form.submit()">
                                        </form>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted small">Tổng thu:</span>
                                        <span class="fw-bold text-primary"><fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="đ"/></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted small">Tổng chi:</span>
                                        <span class="fw-bold text-danger">- <fmt:formatNumber value="${monthlyExpense}" type="currency" currencySymbol="đ"/></span>
                                    </div>
                                    <div class="border-top pt-2 mt-auto d-flex justify-content-between align-items-center">
                                        <span class="fw-bold small text-uppercase">Lợi nhuận:</span>
                                        <h5 class="fw-bold mb-0 ${monthlyProfit >= 0 ? 'text-success' : 'text-secondary'}">
                                            <fmt:formatNumber value="${monthlyProfit}" type="currency" currencySymbol="đ"/>
                                        </h5>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-8 d-flex flex-column">
                            <h5 class="fw-bold mb-3" style="color: #E65100;"><i class="bi bi-grid-fill me-2"></i> Lối Tắt Hệ Thống</h5>
                            <div class="dash-card p-4 flex-grow-1 d-flex flex-column justify-content-center mb-0">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <a href="/admin/orders" class="action-tile">
                                            <i class="bi bi-receipt text-warning"></i><span>Quản lý Đơn Hàng</span>
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="/admin/products" class="action-tile">
                                            <i class="bi bi-box-seam text-success"></i><span>Sửa Thực Đơn</span>
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="/admin/users" class="action-tile">
                                            <i class="bi bi-people text-info"></i><span>Phân quyền User</span>
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a href="/" class="action-tile">
                                            <i class="bi bi-house-door text-secondary"></i><span>Về Trang Khách</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="fab-logs" data-bs-toggle="offcanvas" data-bs-target="#offcanvasLogs">
            <i class="bi bi-bell-fill"></i>
            <c:if test="${pendingOrders > 0}">
                <span class="fab-badge">${pendingOrders}</span>
            </c:if>
        </div>

        <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasLogs" aria-labelledby="offcanvasLogsLabel">
            <div class="offcanvas-header bg-light border-bottom p-4">
                <h5 class="offcanvas-title fw-bold text-secondary" id="offcanvasLogsLabel">
                    <i class="bi bi-info-circle-fill me-2"></i> System Logs
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body p-4 bg-white">
                <div class="list-item pt-0">
                    <i class="bi bi-check-circle-fill text-success fs-3 me-3"></i>
                    <div>
                        <div class="fw-bold" style="font-size: 1rem;">Hệ thống ổn định</div>
                        <div class="text-muted" style="font-size: 0.85rem;">Máy chủ chạy bình thường. Không ghi nhận lỗi.</div>
                    </div>
                </div>
                
                <c:if test="${pendingOrders > 0}">
                    <div class="list-item border-0 mt-2">
                        <i class="bi bi-exclamation-triangle-fill text-warning fs-3 me-3"></i>
                        <div>
                            <div class="fw-bold text-dark" style="font-size: 1rem;">Cảnh báo bếp!</div>
                            <div class="text-muted" style="font-size: 0.85rem;">Bạn đang có <strong class="text-danger">${pendingOrders}</strong> đơn hàng chờ được nấu.</div>
                            <a href="/admin/orders" class="btn btn-sm btn-warning mt-2 fw-bold rounded-pill px-3">Xử lý ngay</a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>