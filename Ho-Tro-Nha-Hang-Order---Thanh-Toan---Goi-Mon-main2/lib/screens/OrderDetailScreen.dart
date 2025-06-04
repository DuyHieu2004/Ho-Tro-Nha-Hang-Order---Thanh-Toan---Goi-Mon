// File: lib/screens/OrderDetailScreen.dart
import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/services/ReservationService.dart'; 

class OrderDetailScreen extends StatefulWidget {
  final DonGoiMon donGoiMon;

  const OrderDetailScreen({Key? key, required this.donGoiMon}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ReservationService _reservationService = ReservationService();
  late Stream<List<ChiTietGoiMon>> _chiTietGoiMonStream; 

  @override
  void initState() {
    super.initState();
    if (widget.donGoiMon.ma != null) {
      _chiTietGoiMonStream = _reservationService.getChiTietGoiMonForDonGoiMon(widget.donGoiMon.ma!);
    } else {
      _chiTietGoiMonStream = Stream.value([]); // 
    }
  }

  Future<void> _cancelReservation() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận hủy?'),
          content: Text('Bạn có chắc chắn muốn hủy đơn đặt này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Có'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _reservationService.cancelReservation(widget.donGoiMon.ma!, widget.donGoiMon.maBan?.ma);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hủy đặt bàn thành công!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hủy đặt bàn thất bại: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String customerName = "N/A";
    String phoneNumber = "N/A";
    String customerContact = "N/A";
    String advancePayment = "0"; // Thêm để hiển thị tiền tạm ứng

    if (widget.donGoiMon.ghiChu != null) {
      final parts = widget.donGoiMon.ghiChu!.split(', ');
      for (var part in parts) {
        if (part.startsWith('Tên khách:')) customerName = part.substring('Tên khách:'.length).trim();
        if (part.startsWith('SĐT:')) phoneNumber = part.substring('SĐT:'.length).trim();
        if (part.startsWith('LH:')) customerContact = part.substring('LH:'.length).trim();
        if (part.startsWith('Tạm ứng:')) advancePayment = part.substring('Tạm ứng:'.length).trim();
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết đơn đặt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Thêm SingleChildScrollView để tránh overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thông tin khách hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Tên khách hàng: $customerName'),
              Text('Số điện thoại: $phoneNumber'),
              Text('Liên hệ khách: $customerContact'),
              SizedBox(height: 20),
              Text('Thông tin đơn đặt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Mã đơn: ${widget.donGoiMon.ma ?? 'N/A'}'),
              Text('Bàn: ${widget.donGoiMon.maBan?.ma ?? 'N/A'} - ${widget.donGoiMon.maBan?.viTri ?? 'N/A'}'),
              Text('Ngày lập: ${widget.donGoiMon.ngayLap?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
              Text('Thời gian: ${widget.donGoiMon.ngayLap?.toLocal().toString().split(' ')[1].substring(0, 5) ?? 'N/A'}'),
              Text('Trạng thái: ${widget.donGoiMon.trangThai ?? 'N/A'}'),
              SizedBox(height: 10),
              Text('Món ăn:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              StreamBuilder<List<ChiTietGoiMon>>(
                stream: _chiTietGoiMonStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Lỗi tải món ăn: ${snapshot.error}');
                  }
                  final dishes = snapshot.data ?? [];
                  if (dishes.isEmpty) {
                    return Text('Chưa có món ăn nào trong đơn này.');
                  }
                  double totalAmount = 0.0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishes.map((item) {
                      double itemTotal = (item.getMonAn?.getGiaBan ?? 0) * (item.getSoLuong ?? 0);
                      totalAmount += itemTotal;
                      return Text('- ${item.getMonAn?.getTen ?? 'N/A'} x ${item.getSoLuong ?? 0} = ${itemTotal.toStringAsFixed(0)} VND');
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 10),
              Text('Tiền tạm ứng: $advancePayment VND', style: TextStyle(fontWeight: FontWeight.bold)),
              StreamBuilder<List<ChiTietGoiMon>>(
                stream: _chiTietGoiMonStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  }
                  if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }
                  final dishes = snapshot.data ?? [];
                  double totalAmount = 0.0;
                  for (var item in dishes) {
                    totalAmount += (item.getMonAn?.getGiaBan ?? 0) * (item.getSoLuong ?? 0);
                  }
                  return Text('Tổng cộng: ${totalAmount.toStringAsFixed(0)} VND', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange));
                },
              ),
              SizedBox(height: 20),
              if (widget.donGoiMon.trangThai != "Hủy") // Chỉ hiển thị nút hủy nếu đơn chưa bị hủy
                ElevatedButton(
                  onPressed: _cancelReservation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Hủy', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}