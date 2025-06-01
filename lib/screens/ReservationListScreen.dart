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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đặt chỗ'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              // Chọn ngày để lọc danh sách
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000), 
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('Lỗi StreamBuilder trong ReservationListScreen: ${snapshot.error}');
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có đơn đặt chỗ nào cho ngày này.'));
                }

                final reservations = snapshot.data!;
                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 3, // Tăng nhẹ elevation cho card
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
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), 
                        onTap: () { // 
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
            // Khi quay lại từ màn hình tạo mới, cập nhật lại danh sách nếu cần
            setState(() {
              // Có thể không cần setState nếu StreamBuilder tự động cập nhật
            });
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}