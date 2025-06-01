import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart'; // Đảm bảo import MonAn
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart'; // Đảm bảo import ChiTietGoiMon
import 'package:doan_nhom_cuoiky/services/ReservationService.dart';
import 'package:doan_nhom_cuoiky/screens/SelectDishesScreen.dart';

class CreateReservationScreen extends StatefulWidget {
  @override
  _CreateReservationScreenState createState() => _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _customerContactController = TextEditingController();
  final TextEditingController _advancePaymentController = TextEditingController();

  Ban? _selectedTable;
  List<ChiTietGoiMon> _selectedDishes = [];

  final ReservationService _reservationService = ReservationService();

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _customerContactController.dispose();
    _advancePaymentController.dispose();
    super.dispose();
  }

  Future<void> _selectDishes() async {
    final List<ChiTietGoiMon>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDishesScreen(
          initialSelectedDishes: _selectedDishes,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDishes = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã chọn ${result.length} món ăn.'), duration: const Duration(seconds: 2)), // Thêm duration
      );
    }
  }

  Future<void> _createReservation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTable == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn bàn cho đơn đặt chỗ.'), duration: Duration(seconds: 2)),
        );
        return;
      }
      if (_selectedDishes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một món ăn.'), duration: Duration(seconds: 2)),
        );
        return;
      }

      double advancePayment = double.tryParse(_advancePaymentController.text) ?? 0.0;

      DonGoiMon newReservation = DonGoiMon(
        // Ma sẽ được tạo bởi Firestore
        ngayLap: DateTime.now(),
        trangThai: "Đã đặt", // Trạng thái ban đầu khi tạo đơn đặt chỗ
        ghiChu: "Tên khách: ${_customerNameController.text}, SĐT: ${_phoneNumberController.text}, LH: ${_customerContactController.text}, Tạm ứng: $advancePayment",
        maBan: _selectedTable,
      );

      try {
        await _reservationService.addReservation(newReservation, _selectedDishes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt bàn thành công!'), duration: Duration(seconds: 2)),
        );
        Navigator.pop(context); // Quay lại màn hình trước đó
      } catch (e) {
        // print lỗi cụ thể để debug
        print("Lỗi khi tạo đơn đặt chỗ: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt bàn thất bại: $e'), duration: const Duration(seconds: 4)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo phiếu đặt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Thông tin khách hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Tên khách hàng'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên khách hàng' : null,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
              ),
              TextFormField(
                controller: _customerContactController,
                decoration: const InputDecoration(labelText: 'Liên hệ khách'),
              ),
              const SizedBox(height: 20),
              const Text('Đơn đặt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              StreamBuilder<List<Ban>>(
                stream: _reservationService.getAvailableTables(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Đảm bảo có Center
                  }
                  if (snapshot.hasError) {
                    print('Lỗi StreamBuilder khi tải bàn: ${snapshot.error}');
                    return Center(child: Text('Lỗi: ${snapshot.error}')); // Đảm bảo có Center
                  }
                  final tables = snapshot.data ?? [];
                  // print('Tổng số bàn nhận được từ snapshot: ${tables.length}'); // Có thể bỏ

                  // Lọc bàn: chỉ lấy bàn "Trống" và "Đã đặt"
                  final availableTables = tables.where((ban) {
                    return ban.trangThai == "Trống" || ban.trangThai == "Đã đặt";
                  }).toList();
                  // print('Số lượng bàn hợp lệ sau lọc: ${availableTables.length}'); // Có thể bỏ

                  // Nếu _selectedTable không còn trong danh sách khả dụng (ví dụ, trạng thái đã thay đổi)
                  if (_selectedTable != null && !availableTables.any((ban) => ban.ma == _selectedTable!.ma)) {
                    _selectedTable = null;
                    // print('Đã reset _selectedTable vì không còn hợp lệ.'); // Có thể bỏ
                  }

                  if (availableTables.isEmpty) {
                    return const Text('Không có bàn nào có sẵn hoặc đã đặt để chọn.');
                  }

                  return DropdownButtonFormField<Ban>(
                    decoration: const InputDecoration(labelText: 'Bàn'),
                    value: _selectedTable,
                    items: availableTables.map((ban) {
                      // print('Đang tạo DropdownMenuItem cho bàn: ${ban.ma}'); // Có thể bỏ
                      return DropdownMenuItem<Ban>(
                        value: ban,
                        child: Text('${ban.ma ?? 'N/A'} - ${ban.viTri ?? 'N/A'} (${ban.trangThai ?? 'N/A'})'),
                      );
                    }).toList(),
                    onChanged: (Ban? newValue) {
                      setState(() {
                        _selectedTable = newValue;
                        // print('Bàn đã chọn: ${newValue?.ma}'); // Có thể bỏ
                      });
                    },
                    validator: (value) => value == null ? 'Vui lòng chọn bàn' : null,
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectDishes,
                child: const Text('Gọi món'),
              ),
              if (_selectedDishes.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Món đã chọn:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._selectedDishes.map((ctgm) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text('${ctgm.getMonAn?.getTen ?? 'Món không tên'} x ${ctgm.getSoLuong ?? 0}'),
                        )),
                  ],
                ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _advancePaymentController,
                decoration: const InputDecoration(labelText: 'Tiền tạm ứng'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Vui lòng nhập số tiền hợp lệ';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createReservation,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}