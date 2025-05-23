import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Reports_NhanVien_Screen(),
    ),
  );
}

class Reports_NhanVien_Screen extends StatelessWidget {
  const Reports_NhanVien_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Báo cáo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin nhân viên',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 20),
            buildInfoRow('Mã', 'NV001'),

            const SizedBox(height: 20),
            buildInfoRow('Họ tên', 'Nguyễn Văn A'),

            const Divider(height: 32, thickness: 1, color: Colors.black),

            const Text(
              'Phiếu báo cáo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0DC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Ngày lập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 150, // Căn giữa nửa phải
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('5/7/2025', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tổng hóa đơn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('8', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Giờ bắt đầu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('8:00', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Giờ kết thúc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('14:00', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Xử lý nộp báo cáo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Nộp báo cáo',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Căn giữa cột bên phải: NV001,....
Widget buildInfoRow(String label, String value) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        flex: 1,
        child: Align(
          alignment: Alignment.center,
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ),
    ],
  );
}

