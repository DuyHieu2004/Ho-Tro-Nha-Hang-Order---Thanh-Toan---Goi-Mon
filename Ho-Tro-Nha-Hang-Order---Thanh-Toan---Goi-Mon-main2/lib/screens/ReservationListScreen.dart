// File: lib/screens/ReservationListScreen.dart
import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/services/ReservationService.dart';
import 'package:doan_nhom_cuoiky/screens/CreateReservationScreen.dart';
import 'package:doan_nhom_cuoiky/screens/OrderDetailScreen.dart';
import 'package:intl/intl.dart';

class ReservationListScreen extends StatefulWidget {
  @override
  _ReservationListScreenState createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  final ReservationService _reservationService = ReservationService();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print("ReservationListScreen rebuild started for date: ${_selectedDate.toIso8601String()}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đặt chỗ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                  print("Ngày đã chọn: ${_selectedDate.toIso8601String()}");
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Danh sách đặt chỗ ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DonGoiMon>>(
              stream: _reservationService.getReservationsForDate(_selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("StreamBuilder: ConnectionState.waiting");
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('StreamBuilder: Lỗi: ${snapshot.error}');
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print("StreamBuilder: Không có dữ liệu hoặc dữ liệu rỗng.");
                  return const Center(child: Text('Không có đơn đặt chỗ nào cho ngày này.'));
                }

                final reservations = snapshot.data!;
                print("StreamBuilder: Đã nhận ${reservations.length} đơn đặt chỗ.");
                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    print("  Hiển thị đơn: ${reservation.ma} - ${reservation.ngayLap?.toLocal()} - ${reservation.trangThai}");

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(
                          reservation.trangThai == 'Hủy' ? Icons.cancel_outlined : Icons.table_bar,
                          color: reservation.trangThai == 'Hủy' ? Colors.red : Colors.blue,
                        ),
                        title: Text('Mã Đơn: ${reservation.ma ?? 'N/A'} - Bàn: ${reservation.maBan?.ma ?? 'N/A'}'),
                        subtitle: Text(
                          'Vị trí: ${reservation.maBan?.viTri ?? 'N/A'} - Thời gian: ${
                              reservation.ngayLap != null ? DateFormat('HH:mm').format(reservation.ngayLap!.toLocal()) : 'N/A'
                          }\nTrạng thái: ${reservation.trangThai ?? 'N/A'}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(donGoiMon: reservation),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateReservationScreen()),
          ).then((_) {
            // StreamBuilder sẽ tự động cập nhật, nhưng thêm setState() nếu cần.
            // setState(() {});
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}