<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Món Ăn - Admin</title>
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
                    <a href="/admin/products" class="active"><i class="bi bi-box-seam me-2"></i> Quản Lý Món Ăn</a>
                    <a href="/admin/orders"><i class="bi bi-receipt me-2"></i> Quản Lý Đơn Hàng</a>
                    <a href="/admin/invoices"><i class="bi bi-printer me-2"></i> Quản Lý Hóa Đơn</a>
                    <a href="/admin/users"><i class="bi bi-people me-2"></i> Quản Lý Tài Khoản</a>
                    <a href="/admin/ingredients"><i class="bi bi-layers me-2"></i>Quản Lý Nguyên Liệu</a>
                    <a href="/admin/profile"><i class="bi bi-gear me-2"></i> Đổi Mật Khẩu</a>
                    <a href="/logout" class="mt-5"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a>
                </div>

                <div class="col-md-10 offset-md-2 p-4">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold mb-1" style="color: var(--brand-color-dark); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
                                <i class="bi bi-box-seam text-warning me-2"></i> Danh Sách Món Ăn
                            </h4>
                            <span class="text-muted small">Quản lý thực đơn và giá bán</span>
                        </div>
                        
                        <div class="d-flex align-items-center">
                            <form action="/admin/products" method="get" class="d-flex me-3">
                                <select name="categoryId" class="form-select me-2 shadow-sm" style="width: auto; min-width: 160px; border-radius: 20px;" onchange="this.form.submit()">
                                    <option value="">-- Tất cả danh mục --</option>
                                    <c:forEach items="${categories}" var="c">
                                        <option value="${c.id}" ${c.id == selectedCategoryId ? 'selected' : ''}>${c.name}</option>
                                    </c:forEach>
                                </select>

                                <div class="input-group shadow-sm" style="border-radius: 20px;">
                                    <input type="text" name="keyword" class="form-control border-end-0" style="border-radius: 20px 0 0 20px;" placeholder="Tìm tên món ăn..." value="${keyword}">
                                    <button type="submit" class="btn bg-white border border-start-0 text-muted" style="border-radius: 0 20px 20px 0;"><i class="bi bi-search"></i></button>
                                </div>
                                
                                <c:if test="${not empty keyword or not empty selectedCategoryId}">
                                    <a href="/admin/products" class="btn btn-light rounded-circle ms-2 shadow-sm text-danger d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;" title="Hủy bộ lọc"><i class="bi bi-x-lg"></i></a>
                                </c:if>
                            </form> 
                            
                            <button class="btn fw-bold text-white rounded-pill px-4 shadow-sm" style="background-color: var(--brand-color-dark);" data-bs-toggle="modal" data-bs-target="#addModal">
                                <i class="bi bi-plus-circle me-1"></i> Thêm Món Mới
                            </button>
                        </div>
                    </div>

                    <div class="custom-card p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">#ID</th>
                                        <th>Hình ảnh</th>
                                        <th>Tên món</th>
                                        <th>Danh mục</th>
                                        <th>Giá tiền</th>
                                        <th>Giảm giá</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center pe-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${products}" var="p">
                                        <tr>
                                            <td class="ps-4 fw-bold text-muted">#${p.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.image != null && p.image.startsWith('http')}">
                                                        <img src="${p.image}" class="product-img">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="data:image/jpeg;base64,${p.image}" class="product-img">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="fw-bold" style="color: var(--brand-color-dark); font-size: 1.05rem;">${p.name}</td>
                                            <td><span class="badge bg-light text-dark border px-2 py-1"><i class="bi bi-tag text-warning me-1"></i> ${p.category.name}</span></td>
                                            <td class="text-danger fw-bold fs-6"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.discountPercentage != null && p.discountPercentage > 0}">
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1">-${p.discountPercentage}%</span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">Không</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${p.isAvailable}">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1"><i class="bi bi-check-circle-fill me-1"></i> Đang bán</span>
                                                </c:if>
                                                <c:if test="${!p.isAvailable}">
                                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary px-2 py-1"><i class="bi bi-pause-circle-fill me-1"></i> Tạm ngưng</span>
                                                </c:if>
                                            </td>
                                            <td class="text-center pe-4">
                                                <button class="btn btn-sm btn-light text-warning border shadow-sm me-1 rounded-circle" style="width: 35px; height: 35px;"
                                                        data-id="${p.id}" data-name="${p.name}" data-price="${p.price}" data-discount="${p.discountPercentage != null ? p.discountPercentage : 0}"
                                                        data-desc="${p.description}" data-cat="${p.category.id}" data-status="${p.isAvailable}"
                                                        data-imageurl="${p.image != null && p.image.startsWith('http') ? p.image : ''}"
                                                        onclick="openEditModal(this)" title="Chỉnh sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>
                                                <a href="/admin/products/delete/${p.id}" class="btn btn-sm btn-light text-danger border shadow-sm rounded-circle" style="width: 35px; height: 35px;" onclick="return confirm('Xóa món này khỏi thực đơn?');" title="Xóa">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty products}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5 text-muted">
                                                <i class="bi bi-cup-hot fs-1 d-block mb-2 opacity-50"></i>
                                                Không tìm thấy món ăn nào.
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
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" style="color: var(--brand-color-dark);"><i class="bi bi-plus-circle-fill text-warning me-2"></i> Thêm Món Ăn Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/products/add" method="post" enctype="multipart/form-data">
                        <div class="modal-body px-4">
                            <div class="row">
                                <div class="col-md-7">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Tên món</label>
                                        <input type="text" name="name" class="form-control" required placeholder="Nhập tên món ăn...">
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <label class="form-label fw-bold">Giá tiền (VNĐ)</label>
                                            <input type="number" name="price" class="form-control text-danger fw-bold" required placeholder="0">
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label fw-bold">Giảm giá (%)</label>
                                            <input type="number" name="discountPercentage" class="form-control" min="0" max="100" value="0">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Danh mục</label>
                                        <select name="category.id" class="form-select">
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.id}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Trạng thái</label>
                                        <select name="isAvailable" class="form-select">
                                            <option value="true">Đang bán</option>
                                            <option value="false">Tạm ngưng</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div class="mb-3 p-3 rounded-4 bg-light border h-100 d-flex flex-column justify-content-center">
                                        <label class="form-label fw-bold text-center w-100 mb-3"><i class="bi bi-image text-warning"></i> Hình ảnh món ăn</label>
                                        
                                        <div class="mb-3">
                                            <label class="form-label small text-muted fw-bold">Cách 1: Tải ảnh từ máy</label>
                                            <input type="file" name="imageFile" class="form-control form-control-sm" accept="image/*">
                                        </div>
                                        
                                        <div class="text-center fw-bold text-secondary mb-3" style="font-size: 0.8rem;">- HOẶC -</div>
                                        
                                        <div>
                                            <label class="form-label small text-muted fw-bold">Cách 2: Dán link (URL)</label>
                                            <input type="text" name="imageUrl" class="form-control form-control-sm" placeholder="https://...">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-2 mt-2">
                                <label class="form-label fw-bold">Mô tả món ăn</label>
                                <textarea name="description" class="form-control" rows="2" placeholder="Ghi chú thêm về nguyên liệu, hương vị..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn text-white rounded-pill px-4 fw-bold shadow-sm" style="background-color: var(--brand-color-dark);">Lưu món ăn</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" style="color: var(--brand-color-dark);"><i class="bi bi-pencil-square text-warning me-2"></i> Cập Nhật Món Ăn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/products/update" method="post" enctype="multipart/form-data">
                        <div class="modal-body px-4">
                            <input type="hidden" name="id" id="edit_id">
                            
                            <div class="row">
                                <div class="col-md-7">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Tên món</label>
                                        <input type="text" name="name" id="edit_name" class="form-control" required>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <label class="form-label fw-bold">Giá tiền (VNĐ)</label>
                                            <input type="number" name="price" id="edit_price" class="form-control text-danger fw-bold" required>
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label fw-bold">Giảm giá (%)</label>
                                            <input type="number" name="discountPercentage" id="edit_discount" class="form-control" min="0" max="100">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Danh mục</label>
                                        <select name="category.id" id="edit_category" class="form-select">
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.id}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Trạng thái</label>
                                        <select name="isAvailable" id="edit_status" class="form-select">
                                            <option value="true">Đang bán</option>
                                            <option value="false">Tạm ngưng</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-5">
                                    <div class="mb-3 p-3 rounded-4 bg-light border h-100 d-flex flex-column justify-content-center">
                                        <label class="form-label fw-bold text-center w-100 mb-3"><i class="bi bi-image text-warning"></i> Đổi ảnh mới</label>
                                        <div class="mb-3">
                                            <input type="file" name="imageFile" class="form-control form-control-sm" accept="image/*">
                                        </div>
                                        <div class="text-center fw-bold text-secondary mb-3" style="font-size: 0.8rem;">- HOẶC DÁN LINK -</div>
                                        <div>
                                            <input type="text" name="imageUrl" id="edit_imageUrl" class="form-control form-control-sm" placeholder="https://...">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-2 mt-2">
                                <label class="form-label fw-bold">Mô tả</label>
                                <textarea name="description" id="edit_description" class="form-control" rows="2"></textarea>
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
                document.getElementById('edit_name').value = button.getAttribute('data-name');
                document.getElementById('edit_price').value = button.getAttribute('data-price');
                document.getElementById('edit_discount').value = button.getAttribute('data-discount');
                document.getElementById('edit_description').value = button.getAttribute('data-desc');
                document.getElementById('edit_category').value = button.getAttribute('data-cat');
                document.getElementById('edit_status').value = button.getAttribute('data-status');
                document.getElementById('edit_imageUrl').value = button.getAttribute('data-imageurl');
                var myModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editModal'));
                myModal.show();
            }
        </script>
    </body>
</html>