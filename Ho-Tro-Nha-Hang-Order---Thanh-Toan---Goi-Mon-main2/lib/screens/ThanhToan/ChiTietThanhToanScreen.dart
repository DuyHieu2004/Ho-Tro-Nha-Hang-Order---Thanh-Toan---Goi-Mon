import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/HoaDon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/BanProvider.dart';
import 'package:doan_nhom_cuoiky/providers/ChiTietDonGoiMonProvider.dart';
import 'package:doan_nhom_cuoiky/providers/DonGoiMonProvider.dart';
import 'package:doan_nhom_cuoiky/providers/HoaDonProvider.dart';
import 'package:doan_nhom_cuoiky/screens/ThanhToan/HoaDonScreen.dart';
import 'package:doan_nhom_cuoiky/services/Auth_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ChiTietThanhToanScreen extends StatefulWidget {
  final DonGoiMon order;

  const ChiTietThanhToanScreen({super.key, required this.order});

  @override
  State<ChiTietThanhToanScreen> createState() => _ChiTietThanhToanScreenState();
}

class _ChiTietThanhToanScreenState extends State<ChiTietThanhToanScreen> {
  final Auth_Service _authService = Auth_Service();
  NhanVien? currentUser;
  bool isSaving = false;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      currentUser = await _authService.getNhanVienByUid(firebaseUser.uid);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ChiTietDonGoiMonProvider>(
        builder: (context, chiTietProvider, child) {
          final orderDetails = chiTietProvider.getChiTietById(widget.order.ma!);

          final double subtotal = orderDetails.fold(
            0,
            (sum, detail) => sum + (detail.tinhTien ?? 0),
          );
          double serviceFee = subtotal * 2.5 / 100;
          double vat = subtotal * 5 / 100;
          final double total = subtotal + serviceFee + vat;

          final numberFormat = NumberFormat.currency(
            locale: 'vi_VN',
            symbol: '',
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color:
                                  (orderDetails.first.getMaDonGoiMon
                                                  as DonGoiMon)
                                              .trangThai ==
                                          'Đang phục vụ'
                                      ? const Color.fromRGBO(231, 76, 60, 1)
                                      : const Color.fromRGBO(88, 214, 141, 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.maBan?.viTri ?? 'Unknown',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.order.ngayLap != null
                                          ? 'Bắt đầu ${DateFormat('HH:mm').format(widget.order.ngayLap!)}'
                                          : 'Unknown',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.order.trangThai!,
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Danh sách món ăn",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Tên món',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'SL',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Đơn giá',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Thành tiền',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            monAn.getTen ?? 'Unknown',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            detail.getSoLuong?.toString() ??
                                                '0',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            numberFormat.format(
                                              monAn.getGiaBan ?? 0,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            numberFormat.format(
                                              detail.tinhTien ?? 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          const Divider(),
                          const Text(
                            "Thanh toán",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng tiền:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${numberFormat.format(total)} đ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        isSaving
                            ? null
                            : () async {
                              setState(() {
                                isSaving = true;
                              });

                              try {
                                final donGoiMonProvider =
                                    Provider.of<DonGoiMonProvider>(
                                      context,
                                      listen: false,
                                    );
                                final banProvider = Provider.of<BanProvider>(
                                  context,
                                  listen: false,
                                );
                                final hoaDonProvider =
                                    Provider.of<HoaDonProvider>(
                                      context,
                                      listen: false,
                                    );

                                final hoaDon = HoaDon(
                                  ma:
                                      'HD${DateTime.now().millisecondsSinceEpoch}',
                                  nhanVien: currentUser,
                                  ngayThanhToan: DateTime.now(),
                                  tongTien: total,
                                  maDGM: widget.order,
                                );

                                await hoaDonProvider.addHoaDon(hoaDon);

                                Ban ban = banProvider.getBanById(
                                  widget.order.maBan!.ma!,
                                );
                                ban.trangThai = 'Trống';
                                await banProvider.updateBan(
                                  widget.order.maBan!,
                                );

                                widget.order.trangThai = 'Đã thanh toán';
                                await donGoiMonProvider.updateDonGoiMon(
                                  widget.order,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Thanh toán thành công!'),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            HoaDonScreen(hoaDon: hoaDon),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Lỗi: $e')),
                                );
                              } finally {
                                setState(() {
                                  isSaving = false;
                                });
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child:
                        isSaving
                            ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Đang xử lý...",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                            : const Text(
                              "Thanh toán",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
