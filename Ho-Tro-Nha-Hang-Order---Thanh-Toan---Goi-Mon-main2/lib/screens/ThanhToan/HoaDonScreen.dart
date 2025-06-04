import 'dart:io';
import 'dart:typed_data';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/HoaDon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';
import 'package:doan_nhom_cuoiky/providers/ChiTietDonGoiMonProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class HoaDonScreen extends StatefulWidget {
  final HoaDon hoaDon;

  const HoaDonScreen({super.key, required this.hoaDon});

  @override
  State<HoaDonScreen> createState() => _HoaDonScreenState();
}

class _HoaDonScreenState extends State<HoaDonScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ChiTietDonGoiMonProvider>(
        builder: (context, chiTietProvider, child) {
          final orderDetails = chiTietProvider.getChiTietById(widget.hoaDon.donGoiMon!.ma!);
          final DonGoiMon order = widget.hoaDon.donGoiMon!;

          final double subtotal = orderDetails.fold(
              0, (sum, detail) => sum + (detail.tinhTien ?? 0));
          const double serviceFee = 25000;
          const double vat = 25000;
          const double discount = 50;
          final double total = subtotal + serviceFee + vat - discount;

          final numberFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'HÓA ĐƠN THANH TOÁN',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Mã hóa đơn: ${widget.hoaDon.ma}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ngày: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.hoaDon.ngayThanhToan!)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            Text(
                              'Nhân viên: ${widget.hoaDon.nhanVien?.ten ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            
                            Text(
                              'Bàn: ${order.maBan?.viTri ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            
                            const SizedBox(height: 16),
                            const Divider(),
                            
                            const Text(
                              "DANH SÁCH MÓN ĂN",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            
                            Row(
                              children: const [
                                Expanded(
                                    flex: 3,
                                    child: Text('Tên món',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 1,
                                    child: Text('Số lượng',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text('Đơn giá',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Text('Thành tiền',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            ),
                            const Divider(),
                            
                            orderDetails.isEmpty
                                ? const Center(child: Text('Không có món nào'))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: orderDetails.length,
                                    itemBuilder: (context, index) {
                                      final detail = orderDetails[index];
                                      MonAn monAn = detail.getMonAn;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: Text(monAn.getTen ??
                                                    'Unknown')),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    detail.getSoLuong?.toString() ?? '0')),
                                            Expanded(
                                                flex: 2,
                                                child: Text(numberFormat.format(
                                                    monAn.getGiaBan ?? 0))),
                                            Expanded(
                                                flex: 2,
                                                child: Text(numberFormat
                                                    .format(detail.tinhTien ?? 0))),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            const Divider(),
                            
                            const Text(
                              "THANH TOÁN",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tổng tiền món:'),
                                Text('${numberFormat.format(subtotal)} đ'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Phí dịch vụ:'),
                                Text('${numberFormat.format(serviceFee)} đ'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Thuế VAT:'),
                                Text('${numberFormat.format(vat)} đ'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tổng tiền:',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  '${numberFormat.format(total)} đ',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            const Center(
                              child: Text(
                                'Cảm ơn quý khách đã sử dụng dịch vụ!',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _createInvoice,
                      icon: const Icon(Icons.receipt_long),
                      label: const Text('Tạo hóa đơn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveInvoiceAsImage,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 20, 
                              height: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Icon(Icons.image),
                      label: Text(_isLoading ? 'Đang lưu...' : 'In hóa đơn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Phương thức tạo hóa đơn
  void _createInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hóa đơn đã được tạo thành công')),
    );
  }

  // Phương thức lưu hóa đơn dưới dạng hình ảnh
  Future<void> _saveInvoiceAsImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Kiểm tra và yêu cầu quyền truy cập bộ nhớ
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      // Chụp ảnh widget
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('Không thể tạo ảnh từ hóa đơn');
      }

      // Lưu ảnh vào thư viện
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: 'HoaDon_${widget.hoaDon.ma}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hóa đơn đã được lưu vào thư viện ảnh')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}