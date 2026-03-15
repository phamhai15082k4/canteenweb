<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thực Đơn - Canteen</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        
        <style>
            /* ÉP NAVBAR NỔI LÊN TRÊN CÙNG */
            .navbar { z-index: 9999 !important; }
            .dropdown-menu { z-index: 10000 !important; position: absolute; }
            .category-card, .product-card { position: relative; z-index: 1; }
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
                        <li class="nav-item"><a class="nav-link" href="/menu" style="color: var(--primary-color) !important;">Thực đơn</a></li>

                        <c:if test="${pageContext.request.userPrincipal.name == null}">
                            <li class="nav-item ms-lg-4 mt-3 mt-lg-0">
                                <button class="btn btn-dark rounded-pill px-4 py-2 fw-bold text-white shadow-sm" style="transition: all 0.3s;" onmouseover="this.style.backgroundColor='#FF9800'" onmouseout="this.style.backgroundColor='#212529'" data-bs-toggle="modal" data-bs-target="#loginModal">
                                    <i class="bi bi-person-circle me-1"></i> ĐĂNG NHẬP
                                </button>
                            </li>
                        </c:if>

                        <c:if test="${pageContext.request.userPrincipal.name != null}">
                            <li class="nav-item dropdown ms-lg-4 mt-3 mt-lg-0">
                                <a class="btn btn-outline-dark rounded-pill px-4 py-2 fw-bold dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle fs-5 me-2 text-warning"></i> ${pageContext.request.userPrincipal.name}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg" style="border-radius: 12px; margin-top: 10px;">
                                    <c:if test="${pageContext.request.isUserInRole('ADMIN')}">
                                        <li><a class="dropdown-item fw-bold text-warning" href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Trang Quản Trị</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                    </c:if>
                                    <li><a class="dropdown-item py-2" href="/history"><i class="bi bi-clock-history me-2"></i> Lịch sử đơn hàng</a></li>
                                    <li><a class="dropdown-item py-2" href="/cart"><i class="bi bi-cart3 me-2"></i> Giỏ hàng</a></li> 
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

        <div class="category-nav">
            <div class="container">
                <ul class="category-nav-list">
                    <li class="category-nav-item">
                        <a href="/menu" class="${activeCategoryId == null ? 'active' : ''}">🌟 TẤT CẢ MÓN ĂN</a>
                    </li>
                    <c:forEach items="${categories}" var="c">
                        <li class="category-nav-item">
                            <a href="/menu?categoryId=${c.id}" class="${activeCategoryId == c.id ? 'active' : ''}">${c.name}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>

        

        <div class="container pb-5">
            <div class="row g-4">
                <c:forEach items="${products}" var="p">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="product-card h-100 d-flex flex-column position-relative">
                            
                            <c:if test="${p.discountPercentage != null && p.discountPercentage > 0}">
                                <div class="discount-badge">GIẢM ${p.discountPercentage}%</div>
                            </c:if>

                            <a href="/product/${p.id}">
                                <c:choose>
                                    <c:when test="${not empty p.image && fn:startsWith(p.image, 'http')}">
                                        <img src="${p.image}" class="card-img-top" alt="${p.name}">
                                    </c:when>
                                    <c:when test="${not empty p.image}">
                                        <img src="data:image/jpeg;base64,${p.image}" class="card-img-top" alt="${p.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-placeholder"><i class="bi bi-image fs-1"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </a>

                            <div class="card-body text-center d-flex flex-column">
                                <h6 class="card-title mb-2" style="height: 48px; overflow: hidden;">
                                    <a href="/product/${p.id}" class="text-decoration-none">${p.name}</a>
                                </h6>
                                
                                <div class="price-text mt-auto mb-3">
                                    <c:choose>
                                        <c:when test="${p.discountPercentage != null && p.discountPercentage > 0}">
                                            <div class="text-muted text-decoration-line-through small fw-normal">
                                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                                            </div>
                                            <div>
                                                <fmt:formatNumber value="${p.price - (p.price * p.discountPercentage / 100)}" type="currency" currencySymbol="đ"/>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div>
                                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <a href="/product/${p.id}" class="btn btn-outline-custom w-100 rounded-pill mb-2 py-2">
                                    <i class="bi bi-eye me-1"></i> XEM CHI TIẾT
                                </a>

                                <form action="/cart/add" method="post" class="mt-auto">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <c:choose>
                                        <c:when test="${pageContext.request.userPrincipal == null}">
                                            <button type="button" class="btn btn-add-cart w-100 rounded-pill fw-bold py-2" data-bs-toggle="modal" data-bs-target="#loginModal">
                                                <i class="bi bi-cart-plus me-1"></i> THÊM VÀO GIỎ
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn btn-add-cart w-100 rounded-pill fw-bold py-2">
                                                <i class="bi bi-cart-plus me-1"></i> THÊM VÀO GIỎ
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty products}">
                    <div class="col-12 text-center py-5 my-5 bg-white rounded-4 shadow-sm">
                        <i class="bi bi-emoji-frown fs-1 text-muted opacity-50"></i>
                        <h4 class="mt-3 text-muted fw-bold">Danh mục này hiện chưa có món nào!</h4>
                        <p class="text-muted">Vui lòng quay lại sau hoặc chọn danh mục khác nhé.</p>
                        <a href="/menu" class="btn btn-outline-warning rounded-pill px-4 mt-2 fw-bold text-dark">Quay lại Tất Cả Món</a>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header border-bottom">
                        <h4 class="modal-title fw-bold mx-auto" style="font-family: 'Playfair Display', serif;">CHÀO MỪNG TRỞ LẠI</h4>
                        <button type="button" class="btn-close position-absolute end-0 me-3" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4 p-md-5">
                        <form action="/perform_login" method="post">

                            <c:if test="${param.error != null}">
                                <div class="alert alert-danger d-flex align-items-center rounded-3 border-danger border-opacity-25 mb-4">
                                    <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> Sai tên đăng nhập hoặc mật khẩu!
                                </div>
                            </c:if>

                            <div class="form-floating mb-4">
                                <input type="text" name="username" class="form-control" id="floatingInput" placeholder="username" required>
                                <label for="floatingInput"><i class="bi bi-person text-muted me-1"></i> Tên đăng nhập (Mã SV)</label>
                            </div>
                            <div class="form-floating mb-4">
                                <input type="password" name="password" class="form-control" id="floatingPassword" placeholder="Password" required>
                                <label for="floatingPassword"><i class="bi bi-lock text-muted me-1"></i> Mật khẩu</label>
                            </div>
                            
                            <button type="submit" class="btn w-100 py-3 rounded-pill fw-bold text-white shadow-sm" style="background-color: var(--primary-color); font-size: 1.1rem; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='translateY(0)'">
                                ĐĂNG NHẬP NGAY
                            </button>

                            <div class="text-center mt-4 pt-3 border-top">
                                <p class="mb-0 text-muted">Chưa có tài khoản hệ thống? 
                                    <a href="/register" class="fw-bold text-danger text-decoration-none">
                                        Đăng ký tại đây
                                    </a>
                                </p>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.cart}">
            <c:set var="cartTotalQuantity" value="0" />
            <c:set var="cartTotalPrice" value="0" />
            <c:forEach items="${sessionScope.cart}" var="item">
                <c:set var="cartTotalQuantity" value="${cartTotalQuantity + item.quantity}" />
                <c:set var="cartTotalPrice" value="${cartTotalPrice + (item.price * item.quantity)}" />
            </c:forEach>

            <a href="/cart" class="position-fixed bottom-0 end-0 m-4 bg-white rounded-pill shadow-lg d-flex align-items-center text-decoration-none" 
               style="z-index: 1050; padding: 10px 25px; border: 2px solid var(--primary-color); transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);"
               onmouseover="this.style.transform = 'scale(1.08) translateY(-5px)'" 
               onmouseout="this.style.transform = 'scale(1) translateY(0)'">

                <div class="position-relative me-3">
                    <div class="bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                        <i class="bi bi-cart-fill fs-4"></i>
                    </div>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-2 border-white" style="font-size: 0.85rem;">
                        ${cartTotalQuantity}
                    </span>
                </div>

                <div class="text-start border-start ps-3">
                    <div class="fw-bold text-muted small text-uppercase" style="letter-spacing: 1px;">Giỏ hàng</div>
                    <div class="fw-black fs-5" style="color: var(--primary-color-dark);">
                        <fmt:formatNumber value="${cartTotalPrice}" type="currency" currencySymbol="đ"/>
                    </div>
                </div>
            </a>
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.has('error') || urlParams.has('login') || '${success}' !== '') {
                    var myModal = new bootstrap.Modal(document.getElementById('loginModal'));
                    myModal.show();
                }
            });
        </script>
    </body>
</html>
