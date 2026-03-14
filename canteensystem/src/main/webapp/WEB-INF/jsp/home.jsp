<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>The Canteen - Bữa Ăn Học Đường</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
                        <li class="nav-item"><a class="nav-link" href="/" style="color: var(--primary-color) !important;">Trang chủ</a></li>
                        <li class="nav-item"><a class="nav-link" href="/menu">Thực đơn</a></li>
                        <li class="nav-item"><a class="nav-link" href="#about">Giới thiệu</a></li>

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
                                    <li><a class="dropdown-item py-2" href="/cart"><i class="bi bi-cart3 me-2"></i> Giỏ hàng của tôi</a></li> 
                                    <li><a class="dropdown-item py-2" href="/profile"><i class="bi bi-person-gear me-2"></i> Hồ sơ & Đổi mật khẩu</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item py-2 text-danger fw-bold" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                                </ul>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </nav>

        <div id="heroCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1470&auto=format&fit=crop" class="d-block w-100" alt="Food 1">
                    <div class="carousel-caption d-none d-md-block">
                        <h2>Hương Vị Tươi Ngon</h2>
                        <p class="fs-5 fw-light">Cung cấp suất ăn dinh dưỡng, an toàn vệ sinh thực phẩm mỗi ngày.</p>
                        <a href="/menu" class="btn btn-warning btn-lg rounded-pill px-5 py-3 mt-4 fw-bold shadow">ĐẶT MÓN NGAY</a>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://images.unsplash.com/photo-1555244162-803834f70033?q=80&w=1470&auto=format&fit=crop" class="d-block w-100" alt="Food 2">
                    <div class="carousel-caption d-none d-md-block">
                        <h2>Thực Đơn Đa Dạng</h2>
                        <p class="fs-5 fw-light">Hàng chục món ăn từ Á đến Âu, thay đổi liên tục giúp bạn không bị ngán.</p>
                        <a href="/menu" class="btn btn-warning btn-lg rounded-pill px-5 py-3 mt-4 fw-bold shadow">XEM THỰC ĐƠN</a>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>

        <div class="container py-5 mt-4" id="about">
            <div class="row text-center mb-5 g-4">
                <div class="col-md-4">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-shield-check text-warning fs-1"></i></div>
                        <h4 class="fw-bold mb-3">An Toàn Tuyệt Đối</h4>
                        <p class="text-muted">Nguyên liệu có nguồn gốc rõ ràng, đạt chuẩn VietGAP, đảm bảo sức khỏe.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-heart-pulse text-danger fs-1"></i></div>
                        <h4 class="fw-bold mb-3">Dinh Dưỡng Cân Bằng</h4>
                        <p class="text-muted">Thực đơn được tính toán calo và tư vấn bởi chuyên gia dinh dưỡng.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="bi bi-clock-history text-info fs-1"></i></div>
                        <h4 class="fw-bold mb-3">Phục Vụ Nhanh Chóng</h4>
                        <p class="text-muted">Tính năng đặt hàng online giúp bạn nhận món ngay không cần xếp hàng.</p>
                    </div>
                </div>
            </div>

            <div class="row align-items-center mt-5 pt-4">
                <div class="col-md-6 pe-md-5 mb-4 mb-md-0">
                    <h2 class="fw-bold mb-4" style="font-family: 'Playfair Display', serif; font-size: 2.5rem; color: var(--secondary-color);">🍽️ Câu Chuyện Của Chúng Tôi</h2>
                    <div class="about-text">
                        <p>The Canteen được xây dựng với sứ mệnh mang đến những bữa ăn an toàn, chất lượng và đầy đủ dinh dưỡng cho cộng đồng học sinh, sinh viên và giảng viên.</p>
                        <p>Với hệ thống bếp hiện đại, quy trình kiểm soát chất lượng khép kín, chúng tôi tự hào phục vụ hàng ngàn suất ăn mỗi ngày. Hệ thống đặt món trực tuyến được ra mắt nhằm tối ưu hóa trải nghiệm, giúp bạn tiết kiệm thời gian nghỉ ngơi quý giá.</p>
                        <p class="fw-bold fs-5 mt-4 text-dark" style="border-left: 4px solid var(--primary-color); padding-left: 15px;">
                            "An toàn – Chất lượng – Minh bạch – Chuyên nghiệp"
                        </p>
                    </div>
                </div>
                <div class="col-md-6 text-center">
                    <img src="${pageContext.request.contextPath}/img/Cangtin.jpg" class="img-fluid rounded-4 shadow-lg" alt="Hình ảnh Căng tin" style="border: 10px solid white;">
                </div>
            </div>
        </div>

        <div class="py-5" id="categories" style="background-color: #f0f2f5;">
            <div class="container pb-4">
                <div class="section-title">
                    <h3>KHÁM PHÁ THỰC ĐƠN</h3>
                    <div class="line"></div>
                </div>

                <div class="row g-4">
                    <div class="col-6 col-md-3">
                        <a href="/menu" class="text-decoration-none">
                            <div class="category-card">
                                <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?w=500&q=80" class="category-img" alt="Tất cả món">
                                <div class="category-title">
                                    TẤT CẢ <i class="bi bi-arrow-right-circle-fill text-warning"></i>
                                </div>
                            </div>
                        </a>
                    </div>

                    <c:forEach items="${categories}" var="c">
                        <div class="col-6 col-md-3">
                            <a href="/menu?categoryId=${c.id}" class="text-decoration-none">
                                <div class="category-card">
                                    <c:choose>
                                        <%-- CƠM & ĐỒ MẶN / MÓN CHÍNH --%>
                                        <c:when test="${fn:containsIgnoreCase(c.name, 'Cơm') || fn:containsIgnoreCase(c.name, 'Mặn') || fn:containsIgnoreCase(c.name, 'Món chính')}">
                                            <img src="https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&q=80" class="category-img" alt="${c.name}">
                                        </c:when>
                                        
                                        <%-- ĐỒ ĂN VẶT / ĐỒ ĂN NHẸ --%>
                                        <c:when test="${fn:containsIgnoreCase(c.name, 'Vặt') || fn:containsIgnoreCase(c.name, 'Nhẹ')}">
                                            <img src="https://images.unsplash.com/photo-1623653387945-2fd25214f8fc?w=500&q=80" class="category-img" alt="${c.name}">
                                        </c:when>
                                        
                                        <%-- ĐỒ UỐNG & GIẢI KHÁT --%>
                                        <c:when test="${fn:containsIgnoreCase(c.name, 'Uống') || fn:containsIgnoreCase(c.name, 'Khát')}">
                                            <img src="https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500&q=80" class="category-img" alt="${c.name}">
                                        </c:when>
                                        
                                        <%-- CANH & RAU --%>
                                        <c:when test="${fn:containsIgnoreCase(c.name, 'Canh') || fn:containsIgnoreCase(c.name, 'Rau')}">
                                            <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80" class="category-img" alt="${c.name}">
                                        </c:when>
                                        
                                        <%-- COMBO BỮA TRƯA/TỐI --%>
                                        <c:when test="${fn:containsIgnoreCase(c.name, 'Combo')}">
                                            <img src="https://images.unsplash.com/photo-1543362906-acfc16c67564?w=500&q=80" class="category-img" alt="${c.name}">
                                        </c:when>
                                        
                                        <%-- MẶC ĐỊNH CHO CÁC MỤC KHÁC --%>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?w=500&q=80" class="category-img" alt="Khác">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div class="category-title">
                                        ${c.name} <i class="bi bi-arrow-right-circle-fill text-warning"></i>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="container py-5" id="featured-products">
            <div class="section-title">
                <h3>MÓN ĂN ĐƯỢC YÊU THÍCH</h3>
                <div class="line"></div>
            </div>

            <div class="row g-4">
                <c:forEach items="${featuredProducts}" var="p">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="product-card h-100 d-flex flex-column position-relative">
                            
                            <c:if test="${p.discountPercentage != null && p.discountPercentage > 0}">
                                <div class="discount-badge">GIẢM ${p.discountPercentage}%</div>
                            </c:if>

                            <a href="/product/${p.id}">
                                <c:choose>
                                    <c:when test="${not empty p.image && p.image.startsWith('http')}">
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
            </div>

            <div class="text-center mt-5 pt-3">
                <a href="/menu" class="btn btn-outline-dark rounded-pill px-5 py-3 fw-bold" style="border-width: 2px;">
                    XEM TOÀN BỘ THỰC ĐƠN <i class="bi bi-arrow-right ms-2"></i>
                </a>
            </div>
        </div>

        <footer>
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-4 pe-md-5">
                        <h5 class="text-warning">THE CANTEEN</h5>
                        <p style="line-height: 1.8;">Hệ thống quản lý và phục vụ suất ăn trường học hiện đại. Cam kết mang đến những bữa ăn ngon miệng, dinh dưỡng và an toàn tuyệt đối cho sức khỏe.</p>
                    </div>
                    <div class="col-md-4">
                        <h5 class="text-warning">LIÊN HỆ</h5>
                        <ul class="list-unstyled" style="line-height: 2;">
                            <li><i class="bi bi-geo-alt-fill text-warning me-2"></i> Đại học Sư phạm Kỹ thuật Nam Định</li>
                            <li><i class="bi bi-telephone-fill text-warning me-2"></i> 0987 654 321</li>
                            <li><i class="bi bi-envelope-fill text-warning me-2"></i> support@canteen.edu.vn</li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h5 class="text-warning">GIỜ PHỤC VỤ</h5>
                        <ul class="list-unstyled" style="line-height: 2;">
                            <li><strong class="text-white">Thứ 2 - Thứ 6:</strong> 06:00 - 18:00</li>
                            <li><strong class="text-white">Thứ 7:</strong> 06:00 - 12:00</li>
                            <li><strong class="text-danger">Chủ Nhật:</strong> Đóng cửa</li>
                        </ul>
                    </div>
                </div>
                <hr class="border-secondary mt-5 mb-4">
                <div class="text-center">
                    <p class="mb-0 small text-muted">&copy; 2026 The Canteen Management System. All rights reserved.</p>
                </div>
            </div>
        </footer>

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

                            <c:if test="${not empty success}">
                                <div class="alert alert-success d-flex align-items-center rounded-3 border-success border-opacity-25 mb-4">
                                    <i class="bi bi-check-circle-fill me-2 fs-5"></i> ${success}
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