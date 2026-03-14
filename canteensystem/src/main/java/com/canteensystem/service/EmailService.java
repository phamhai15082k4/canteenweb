package com.canteensystem.service;

import com.canteensystem.entity.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    // 1. Gửi mail khi ĐẶT HÀNG THÀNH CÔNG
    public void sendOrderConfirmation(String toEmail, Order order) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("🍕 ĐẶT HÀNG THÀNH CÔNG - The Canteen");
        message.setText("Xin chào,\n\n"
                + "Bạn đã đặt hàng thành công tại The Canteen!\n"
                + "Mã đơn hàng của bạn là: #" + order.getId() + "\n"
                + "Tổng tiền: " + String.format("%,.0f", order.getTotalAmount()) + " VNĐ\n"
                + "Trạng thái: Chờ nhà bếp xác nhận và chế biến.\n\n"
                + "Chúng tôi sẽ gửi email thông báo cho bạn ngay khi món ăn hoàn thành. Vui lòng chú ý theo dõi!\n\n"
                + "Cảm ơn bạn đã sử dụng dịch vụ,\n"
                + "Ban Quản Lý Canteen.");
        
        mailSender.send(message);
    }

    // 2. Gửi mail khi NẤU XONG, GỌI XUỐNG NHẬN HÀNG
    public void sendOrderReadyForPickup(String toEmail, Order order) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("📢 ĐỒ ĂN ĐÃ SẴN SÀNG - Xuống nhận ngay nhé!");
        message.setText("Xin chào,\n\n"
                + "Tuyệt vời! Đơn hàng #" + order.getId() + " của bạn đã được nhà bếp chuẩn bị xong nóng hổi.\n\n"
                + "Bạn vui lòng mang theo thẻ sinh viên/mã đơn hàng xuống quầy Canteen để nhận đồ ăn nhé.\n\n"
                + "Chúc bạn có một bữa ăn thật ngon miệng!\n"
                + "The Canteen.");
        
        mailSender.send(message);
    }
}