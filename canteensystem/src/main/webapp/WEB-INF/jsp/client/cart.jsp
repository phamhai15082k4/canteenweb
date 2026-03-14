<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng của bạn - The Canteen</title>
    
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
                                <i class="bi bi-person-circle fs-5 me-2"></i> ${pageContext.request.userPrincipal.name}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg" style="border-radius: 12px; margin-top: 10px;">
                                <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                                    <li><a class="dropdown-item fw-bold text-warning" href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Trang Quản Trị</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li><a class="dropdown-item py-2" href="/history"><i class="bi bi-clock-history me-2"></i> Lịch sử đơn hàng</a></li>
                                <li><a class="dropdown-item py-2 fw-bold text-primary bg-light" href="/cart"><i class="bi bi-cart3 me-2"></i> Giỏ hàng của tôi</a></li> 
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
            <i class="bi bi-bag-check text-warning me-2"></i> GIỎ HÀNG CỦA BẠN
        </h2>
    </div>

    <div class="container pb-5">
        
        <c:if test="${param.success != null}">
            <div class="alert alert-success border-0 shadow-sm rounded-4 text-center p-5 mb-5 mx-auto" style="max-width: 600px;">
                <i class="bi bi-check-circle-fill text-success display-1 mb-3"></i>
                <h3 class="fw-bold text-success mb-3">Đặt món thành công!</h3>
                <p class="text-muted fs-5 mb-4">Nhà bếp đã nhận được đơn của bạn và đang tiến hành chuẩn bị. Vui lòng theo dõi tại mục lịch sử đơn hàng.</p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="/history" class="btn btn-outline-success rounded-pill px-4 fw-bold">Xem đơn hàng</a>
                    <a href="/menu" class="btn btn-success rounded-pill px-4 fw-bold shadow-sm">Tiếp tục chọn món</a>
                </div>
            </div>
        </c:if>

        <c:if test="${empty cart && param.success == null}">
            <div class="text-center py-5 my-4">
                <div class="bg-white rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-4" style="width: 150px; height: 150px;">
                    <i class="bi bi-cart-x text-muted" style="font-size: 5rem; opacity: 0.5;"></i>
                </div>
                <h4 class="fw-bold text-secondary mb-3">Chưa có món nào trong giỏ</h4>
                <p class="text-muted mb-4">Hãy khám phá thực đơn đa dạng của chúng tôi nhé!</p>
                <a href="/menu" class="btn btn-warning rounded-pill px-5 py-3 fw-bold shadow-sm" style="font-size: 1.1rem;">ĐI TỚI THỰC ĐƠN <i class="bi bi-arrow-right ms-2"></i></a>
            </div>
        </c:if>

        <c:if test="${not empty cart}">
            <div class="row g-4">
                
                <div class="col-lg-8">
                    <div class="cart-card p-0">
                        <div class="table-responsive">
                            <table class="table table-cart mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Món Ăn</th>
                                        <th>Đơn Giá</th>
                                        <th class="text-center">Số Lượng</th>
                                        <th class="text-end">Tạm Tính</th>
                                        <th class="text-center pe-4">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cart}" var="item">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center">
                                                    <c:choose>
                                                        <c:when test="${not empty item.image && item.image.startsWith('http')}">
                                                            <img src="${item.image}" class="cart-img me-3" alt="${item.name}">
                                                        </c:when>
                                                        <c:when test="${not empty item.image}">
                                                            <img src="data:image/jpeg;base64,${item.image}" class="cart-img me-3" alt="${item.name}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="cart-img bg-light text-muted d-flex align-items-center justify-content-center me-3"><i class="bi bi-image fs-3"></i></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <h6 class="fw-bold mb-1" style="font-size: 1.05rem;">${item.name}</h6>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-muted fw-500">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border px-3 py-2 fs-6 shadow-sm rounded-pill">${item.quantity}</span>
                                            </td>
                                            <td class="text-end fw-bold text-danger fs-6">
                                                <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="text-center pe-4">
                                                <a href="/cart/remove/${item.productId}" class="btn-delete" title="Xóa khỏi giỏ">
                                                    <i class="bi bi-trash-fill"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="checkout-box">
                        <h5>TỔNG ĐƠN HÀNG</h5>
                        
                        <div class="d-flex justify-content-between align-items-center mb-4 mt-4">
                            <span class="text-muted fw-bold">Tổng Thanh Toán:</span>
                            <span class="total-price">
                                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="đ"/>
                            </span>
                        </div>
                        
                        <div class="bg-light p-3 rounded-3 mb-4 border">
                            <div class="d-flex text-muted small mb-2">
                                <i class="bi bi-shield-check text-success me-2"></i>
                                Món ăn sẽ được nhà bếp chuẩn bị ngay sau khi bạn xác nhận.
                            </div>
                            <div class="d-flex text-muted small">
                                <i class="bi bi-clock-history text-primary me-2"></i>
                                Thời gian chờ dự kiến: 10 - 15 phút.
                            </div>
                        </div>

                        <form action="/cart/checkout" method="post">
                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary small text-uppercase">Phương Thức Thanh Toán</label>
                                <select class="form-select border-0 bg-light shadow-sm py-3" style="border-radius: 12px; font-weight: 500;">
                                    <option>💵 Tiền mặt khi nhận món tại quầy</option>
                                    <option disabled>💳 Quẹt thẻ POS (Bảo trì)</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-checkout w-100 mt-2">
                                <i class="bi bi-send-check-fill me-2"></i> GỬI ĐƠN XUỐNG BẾP
                            </button>
                        </form>
                    </div>
                </div>

            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>