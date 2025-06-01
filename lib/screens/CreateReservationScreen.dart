// File: lib/screens/CreateReservationScreen.dart
import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/services/ReservationService.dart';
import 'package:doan_nhom_cuoiky/screens/SelectDishesScreen.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Ban? _selectedTable;
  List<ChiTietGoiMon> _selectedDishes = [];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final ReservationService _reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timeController.text.isEmpty && _selectedTime != null) {
      _timeController.text = _selectedTime!.format(context);
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _customerContactController.dispose();
    _advancePaymentController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _updateDateTimeControllers() {
    if (_selectedDate != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    } else {
      _dateController.text = '';
    }

    if (_selectedTime != null) {
      _timeController.text = _selectedTime!.format(context);
    } else {
      _timeController.text = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateTimeControllers();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _updateDateTimeControllers();
      });
    }
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
        SnackBar(content: Text('Đã chọn ${result.length} món ăn.'), duration: const Duration(seconds: 2)),
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
      if (_selectedTable!.trangThai != "Trống") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bàn ${_selectedTable!.ma} đang ở trạng thái "${_selectedTable!.trangThai}", không thể đặt.'),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      if (_selectedDishes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một món ăn.'), duration: Duration(seconds: 2)),
        );
        return;
      }
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ngày và giờ khách sẽ đến.'), duration: Duration(seconds: 2)),
        );
        return;
      }

      final DateTime reservationDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      double advancePayment = double.tryParse(_advancePaymentController.text) ?? 0.0;

      DonGoiMon newReservation = DonGoiMon(
        ngayLap: DateTime.now(),
        ngayGioDenDuKien: reservationDateTime,
        trangThai: "Đã đặt",
        ghiChu: "Tên khách: ${_customerNameController.text}, SĐT: ${_phoneNumberController.text}, LH: ${_customerContactController.text}, Tạm ứng: $advancePayment",
        maBan: _selectedTable,
      );

      try {
        await _reservationService.addReservation(newReservation, _selectedDishes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt bàn thành công!'), duration: Duration(seconds: 2)),
        );
        Navigator.pop(context);
      } catch (e) {
        print("Lỗi khi tạo đơn đặt chỗ trong CreateReservationScreen: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt bàn thất bại: $e'), duration: const Duration(seconds: 4)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConfirmButtonAlwaysEnabled = _selectedTable != null && _selectedDishes.isNotEmpty;

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
              const Text('Thông tin đặt chỗ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày đến',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) => value!.isEmpty ? 'Vui lòng chọn ngày đến' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Giờ đến',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    validator: (value) => value!.isEmpty ? 'Vui lòng chọn giờ đến' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<Ban>>(
                stream: _reservationService.getAvailableTables(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('Lỗi StreamBuilder khi tải bàn trong CreateReservationScreen: ${snapshot.error}');
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }
                  final tables = snapshot.data ?? [];

                  final allTables = tables;

                  // Lọc và debug các bàn có vấn đề về mã hoặc trạng thái
                  final validTables = allTables.where((ban) {
                    if (ban.ma == null) {
                      print("Debug: Bàn không có mã (null) bị bỏ qua: ${ban.viTri}");
                      return false;
                    }
                    if (ban.trangThai == null) {
                      print("Debug: Bàn có mã ${ban.ma} nhưng trạng thái null bị bỏ qua.");
                      return false;
                    }
                    return true; // Chỉ bao gồm bàn có mã và trạng thái hợp lệ
                  }).toList();

                  // RẤT QUAN TRỌNG: Đảm bảo _selectedTable hiện tại vẫn nằm trong danh sách validTables.
                  // Nếu không, đặt lại _selectedTable thành null để tránh lỗi.
                  if (_selectedTable != null) {
                     final matchingTable = validTables.firstWhere(
                         (ban) => ban.ma == _selectedTable!.ma,
                         orElse: () => Ban(ma: null), // Trả về Ban với ma null nếu không tìm thấy
                     );
                     if (matchingTable.ma == null) { // Nếu không tìm thấy bàn khớp
                         print('Debug: _selectedTable (Mã: ${_selectedTable!.ma}) không còn hợp lệ trong danh sách bàn hiện tại. Đặt lại _selectedTable = null.');
                         _selectedTable = null;
                     } else {
                         // Cập nhật _selectedTable với đối tượng Ban mới từ stream
                         // Điều này giúp đảm bảo _selectedTable luôn là đối tượng mới nhất từ Firestore
                         // và có thể tránh các vấn đề so sánh đối tượng cũ/mới.
                         _selectedTable = matchingTable;
                         print('Debug: Cập nhật _selectedTable với đối tượng mới từ stream: ${_selectedTable?.ma}');
                     }
                  }


                  if (validTables.isEmpty) {
                    return const Text('Không có bàn nào trong hệ thống hoặc tất cả đều không hợp lệ.');
                  }

                  return DropdownButtonFormField<Ban>(
                    decoration: const InputDecoration(labelText: 'Bàn'),
                    value: _selectedTable,
                    items: validTables.map((ban) { // Sử dụng validTables thay vì allTables
                      Color textColor = Colors.black;
                      if (ban.trangThai == "Đã đặt") {
                        textColor = Colors.red;
                      } else if (ban.trangThai == "Đang phục vụ") {
                        textColor = Colors.orange;
                      } else { // Trống
                        textColor = Colors.green;
                      }

                      return DropdownMenuItem<Ban>(
                        value: ban,
                        child: Text(
                          '${ban.ma ?? 'N/A'} - ${ban.viTri ?? 'N/A'} (${ban.trangThai ?? 'N/A'})',
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (Ban? newValue) {
                      setState(() {
                        _selectedTable = newValue;
                        print('Debug: Bàn đã chọn: ${newValue?.ma} - ${newValue?.trangThai}');
                      });
                    },
                    validator: (value) => value == null ? 'Vui lòng chọn bàn' : null,
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectDishes,
                child: const Text('Chọn món ăn'),
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
                onPressed: isConfirmButtonAlwaysEnabled ? _createReservation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConfirmButtonAlwaysEnabled ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}