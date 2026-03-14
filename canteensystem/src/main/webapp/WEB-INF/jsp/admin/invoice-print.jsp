
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn - ${order.id}</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --text-color: #2c2c2c;
            --border-color: #9e9e9e;
        }

        body { 
            font-family: 'Roboto', sans-serif; /* Phông chữ nội dung tối giản */
            background: #f4f4f4; 
            margin: 0; 
            padding: 20px; 
            color: var(--text-color);
        }

        /* KHUNG GIẤY IN (Chuẩn A4 dọc) */
        .invoice-paper { 
            width: 21cm; 
            min-height: 29.7cm; 
            margin: 0 auto; 
            background: #fcfcfc; /* Màu trắng hơi ngà nhẹ cho sang */
            padding: 2cm 2.5cm; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
            box-sizing: border-box;
            position: relative;
        }

        /* Nút in */
        .btn-print {
            display: block; width: 21cm; margin: 0 auto 15px auto; padding: 12px;
            background: #2c2c2c; color: white; text-align: center; font-weight: bold;
            text-transform: uppercase; text-decoration: none; border: none; cursor: pointer;
            border-radius: 4px; font-family: 'Roboto', sans-serif; letter-spacing: 1px;
        }

        /* HEADER */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .logo { font-family: 'Playfair Display', serif; font-size: 55px; line-height: 1; }
        .title { font-family: 'Playfair Display', serif; font-size: 32px; text-transform: uppercase; letter-spacing: 2px; }

        /* THÔNG TIN KHÁCH HÀNG & HÓA ĐƠN */
        .info-section { display: flex; justify-content: space-between; margin-bottom: 50px; font-size: 13px; line-height: 1.6; }
        .billed-to-title { text-transform: uppercase; font-size: 10px; font-weight: bold; letter-spacing: 1px; color: #555; margin-bottom: 10px; }
        .customer-name { font-weight: bold; font-size: 15px; margin-bottom: 3px; }
        .invoice-meta { text-align: right; }

        /* BẢNG SẢN PHẨM */
        .table-headers { display: flex; font-size: 13px; font-weight: bold; margin-bottom: 15px; padding: 0 15px; }
        .table-headers .col-1 { width: 45%; }
        .table-headers .col-2 { width: 15%; text-align: center; }
        .table-headers .col-3 { width: 20%; text-align: right; }
        .table-headers .col-4 { width: 20%; text-align: right; }

        .items-box { border: 1px solid var(--border-color); min-height: 200px; display: flex; flex-direction: column; }
        .item-row { display: flex; font-size: 13px; }
        .item-row div { padding: 15px; border-right: 1px solid var(--border-color); }
        .item-row div:last-child { border-right: none; }
        
        .item-row .col-1 { width: 45%; }
        .item-row .col-2 { width: 15%; text-align: center; }
        .item-row .col-3 { width: 20%; text-align: right; }
        .item-row .col-4 { width: 20%; text-align: right; }

        /* Dòng đệm để hộp table luôn có độ cao nhất định nếu ít món */
        .filler-row { flex-grow: 1; display: flex; }
        .filler-row div { border-right: 1px solid var(--border-color); }
        .filler-row div:last-child { border-right: none; }

        /* TỔNG TIỀN & THANH TOÁN */
        .summary-section { display: flex; justify-content: space-between; margin-top: 30px; font-size: 13px; }
        .payment-info { line-height: 1.8; }
        .payment-info-title { font-size: 11px; color: #555; margin-bottom: 5px; }
        .total-box { text-align: right; width: 40%; }
        .total-title { font-size: 14px; font-weight: bold; margin-bottom: 10px; }
        .total-amount { font-size: 26px; font-weight: bold; }

        /* FOOTER */
        .footer { margin-top: 80px; border-top: 1px solid var(--border-color); padding-top: 15px; display: flex; justify-content: space-between; font-size: 11px; color: #555; }
        .brand { font-family: 'Playfair Display', serif; font-size: 16px; font-weight: bold; color: var(--text-color); }

        /* CSS MÁY IN */
        @media print {
            @page { size: A4; margin: 0; }
            body { background: white; padding: 0; }
            .invoice-paper { width: 100%; height: auto; box-shadow: none; padding: 2cm; }
            .btn-print { display: none; }
        }
    </style>
</head>
<body>

    <button class="btn-print" onclick="window.print()">
        🖨️ Tiến hành in hóa đơn
    </button>

    <div class="invoice-paper">
        
        <div class="header">
            <div class="logo">&amp;</div>
            <div class="title">HÓA ĐƠN</div>
        </div>

        <div class="info-section">
            <div>
                <div class="billed-to-title">HÓA ĐƠN ĐƯỢC GỬI CHO:</div>
                <div class="customer-name">${order.user.fullName}</div>
                <div>Mã SV/KH: ${order.user.username}</div>
                <div>SĐT: ${order.user.phone != null ? order.user.phone : '(Trống)'}</div>
            </div>
            <div class="invoice-meta">
                <div>Hóa đơn số <span style="font-weight: 500;">${order.id}</span></div>
                <div><fmt:formatDate value="${order.orderDate}" pattern="dd 'Tháng' MM, yyyy"/></div>
            </div>
        </div>

        <div class="table-headers">
            <div class="col-1">Mô tả</div>
            <div class="col-2">SL</div>
            <div class="col-3">Đơn giá</div>
            <div class="col-4">Chi phí phải trả</div>
        </div>

        <div class="items-box">
            <c:forEach items="${order.orderDetails}" var="item">
                <div class="item-row">
                    <div class="col-1">${item.product.name}</div>
                    <div class="col-2">${item.quantity}</div>
                    <div class="col-3"><fmt:formatNumber value="${item.price}" pattern="#,##0"/></div>
                    <div class="col-4"><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0"/></div>
                </div>
            </c:forEach>
            <div class="filler-row">
                <div class="col-1"></div><div class="col-2"></div><div class="col-3"></div><div class="col-4"></div>
            </div>
        </div>

        <div class="summary-section">
            <div class="payment-info">
                <div class="payment-info-title">Vui lòng thanh toán cho:</div>
                <div style="font-weight: 500;">Canteen ĐH SPKT Nam Định</div>
                <div>Số tài khoản: 9876 5432 1011</div>
                <div>Ngân hàng: MB Bank</div>
            </div>
            <div class="total-box">
                <div class="total-title">Tổng cộng</div>
                <div class="total-amount">
                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> đ
                </div>
            </div>
        </div>

        <div class="footer">
            <div class="brand">Canteen SPKT</div>
            <div>Đại học Sư phạm Kỹ thuật Nam Định, TP. Nam Định</div>
        </div>

    </div>

</body>
</html>