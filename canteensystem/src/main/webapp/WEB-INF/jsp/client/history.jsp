<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng - The Canteen</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&family=Playfair+Display:ital,wght@0,700;1,400&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #FF9800; 
            --primary-color-dark: #E65100;
            --secondary-color: #2c3e50;
            --light-bg: #f8f9fa;
        }
        body { font-family: 'Roboto', sans-serif; color: #333; background: var(--light-bg); }

        /* 1. NAVBAR SANG TRỌNG */
        .navbar { background: rgba(255, 255, 255, 0.98); box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 15px 0; backdrop-filter: blur(10px); }
        .navbar-brand { font-family: 'Playfair Display', serif; font-size: 2rem; color: var(--primary-color) !important; font-weight: 900; letter-spacing: 1px; }
        .nav-link { color: var(--secondary-color) !important; font-weight: 600; margin-left: 20px; text-transform: uppercase; font-size: 0.9rem; transition: color 0.3s; }
        .nav-link:hover { color: var(--primary-color) !important; }

        /* 2. PAGE HEADER */
        .page-header { padding: 40px 0 30px; text-align: center; }
        .page-title { font-family: 'Playfair Display', serif; font-size: 2.5rem; font-weight: 700; color: var(--secondary-color); }
        
        /* 3. LỊCH SỬ CARD */
        .history-card { 
            background: white; 
            border-radius: 16px; 
            border: none; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.03); 
            overflow: hidden; 
            transition: transform 0.3s;
        }
        .history-card:hover { transform: translateY(-3px); box-shadow: 0 10px 25px rgba(0,0,0,0.06); }
        .history-header { background-color: #fffaf0; border-bottom: 2px solid #fdf5e6; padding: 20px 25px; }
        
        .product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .list-group-item { border-color: #f0f0f0; padding: 15px 25px; }

        /* Nút Bấm */
        .btn-custom { border-radius: 50px; font-weight: bold; padding: 8px 20px; transition: all 0.3s; }
    </style>
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
                                <i class="bi bi-person-circle fs-5 me-2"></i> ${pageContext.request.userPrincipal.name}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg" style="border-radius: 12px; margin-top: 10px;">
                                <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                                    <li><a class="dropdown-item fw-bold text-warning" href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Trang Quản Trị</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li><a class="dropdown-item py-2 fw-bold text-primary bg-light" href="/history"><i class="bi bi-clock-history me-2"></i> Lịch sử đơn hàng</a></li>
                                <li><a class="dropdown-item py-2" href="/cart"><i class="bi bi-cart3 me-2"></i> Giỏ hàng của tôi</a></li> 
                                <li><a class="dropdown-item py-2" href="/profile"><i class="bi bi-person-gear me-2"></i> Đổi mật khẩu</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-danger fw-bold" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="page-header">
        <h2 class="page-title">
            <i class="bi bi-clock-history text-warning me-2"></i> LỊCH SỬ ĐẶT MÓN
        </h2>
    </div>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                
                <c:if test="${empty orders}">
                    <div class="text-center py-5 my-4 bg-white rounded-4 shadow-sm">
                        <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 150px; height: 150px;">
                            <i class="bi bi-receipt-cutoff text-muted" style="font-size: 5rem; opacity: 0.5;"></i>
                        </div>
                        <h4 class="fw-bold text-secondary mb-3">Bạn chưa đặt đơn hàng nào</h4>
                        <p class="text-muted mb-4">Hãy ghé qua thực đơn để chọn cho mình những món ngon nhé!</p>
                        <a href="/menu" class="btn btn-warning rounded-pill px-5 py-3 fw-bold shadow-sm" style="font-size: 1.1rem;">ĐI TỚI THỰC ĐƠN <i class="bi bi-arrow-right ms-2"></i></a>
                    </div>
                </c:if>

                <c:forEach items="${orders}" var="o">
                    <div class="history-card mb-4">
                        
                        <div class="history-header d-flex justify-content-between align-items-center">
                            <div>
                                <span class="fw-bold fs-5 text-dark">Đơn hàng #${o.id}</span>
                                <div class="text-muted small mt-1">
                                    <i class="bi bi-calendar2-check text-warning me-1"></i> 
                                    <fmt:formatDate value="${o.orderDate}" pattern="HH:mm - dd/MM/yyyy"/>
                                </div>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${o.status == 'PENDING'}">
                                        <span class="badge bg-warning bg-opacity-25 text-dark border border-warning px-3 py-2 rounded-pill"><i class="bi bi-hourglass-split me-1"></i> Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${o.status == 'COOKING'}">
                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-3 py-2 rounded-pill"><i class="bi bi-fire me-1"></i> Đang nấu</span>
                                    </c:when>
                                    <c:when test="${o.status == 'READY'}">
                                        <span class="badge bg-info bg-opacity-10 text-info border border-info px-3 py-2 rounded-pill"><i class="bi bi-bell-fill me-1"></i> Chờ nhận món</span>
                                    </c:when>
                                    <c:when test="${o.status == 'COMPLETED'}">
                                        <span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill"><i class="bi bi-check-circle-fill me-1"></i> Đã nhận hàng</span>
                                    </c:when>
                                    <c:when test="${o.status == 'CANCELLED'}">
                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-3 py-2 rounded-pill"><i class="bi bi-x-circle-fill me-1"></i> Đã hủy</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="px-4 pt-3">
                            <c:if test="${o.status == 'COOKING' && o.waitTime != null}">
                                <div class="alert alert-info d-flex align-items-center rounded-3 border-info border-opacity-25 mb-0">
                                    <i class="bi bi-stopwatch fs-3 me-3 text-info"></i>
                                    <div>
                                        <strong class="text-dark">Bếp đã nhận đơn và đang chế biến!</strong><br>
                                        <span class="text-muted">Thời gian chờ dự kiến:</span> <span class="text-danger fw-bold fs-6">${o.waitTime} phút</span>. Bạn vui lòng đợi nhé!
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${o.status == 'READY'}">
                                <div class="alert alert-success d-flex align-items-center rounded-3 border-success border-opacity-25 mb-0">
                                    <i class="bi bi-bell-fill fs-3 me-3 text-success"></i>
                                    <div>
                                        <strong class="text-dark">Món ăn đã sẵn sàng!</strong><br>
                                        <span class="text-muted">Mời bạn xuống quầy Canteen để nhận món ngay cho nóng nhé.</span>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <ul class="list-group list-group-flush mt-2">
                            <c:forEach items="${o.orderDetails}" var="d">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        
                                        <c:choose>
                                            <c:when test="${not empty d.product.image && d.product.image.startsWith('http')}">
                                                <img src="${d.product.image}" class="product-img me-3" alt="${d.product.name}">
                                            </c:when>
                                            <c:when test="${not empty d.product.image}">
                                                <img src="data:image/jpeg;base64,${d.product.image}" class="product-img me-3" alt="${d.product.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-img bg-light text-muted d-flex align-items-center justify-content-center me-3"><i class="bi bi-image fs-4"></i></div>
                                            </c:otherwise>
                                        </c:choose>

                                        <div>
                                            <span class="fw-bold" style="font-size: 1.05rem;">${d.product.name}</span>
                                            <div class="text-muted small mt-1">Số lượng: <span class="badge bg-secondary rounded-pill">x${d.quantity}</span></div>
                                        </div>
                                    </div>
                                    <span class="fw-bold text-dark"><fmt:formatNumber value="${d.price * d.quantity}" type="currency" currencySymbol="đ"/></span>
                                </li>
                            </c:forEach>
                        </ul>

                        <div class="card-footer bg-white d-flex flex-column flex-md-row justify-content-between align-items-md-center px-4 py-3 border-top">
                            <div class="mb-3 mb-md-0">
                                <span class="text-muted fw-bold text-uppercase small">Tổng thành tiền:</span>
                                <h4 class="mb-0 text-danger fw-bold"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/></h4>
                            </div>
                            
                            <div>
                                <c:if test="${o.status == 'PENDING'}">
                                    <a href="/history/cancel/${o.id}" class="btn btn-outline-danger btn-custom shadow-sm" onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này không?');">
                                        <i class="bi bi-trash"></i> Hủy đơn hàng
                                    </a>
                                </c:if>
                                
                                <c:if test="${o.status == 'COMPLETED' || o.status == 'CANCELLED'}">
                                    <a href="/menu" class="btn btn-warning btn-custom shadow-sm text-dark">
                                        <i class="bi bi-arrow-repeat"></i> Đặt lại món khác
                                    </a>
                                </c:if>
                            </div>
                        </div>

                    </div>
                </c:forEach>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>