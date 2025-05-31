import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'LogIn_Screen.dart';
import 'BaoCao_Screen.dart';
import 'BaoCao_NhanVien_Screen.dart';
import 'ThongKe_Screen.dart';

class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Khởi tạo instance của FirebaseAuth

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Hàm hiển thị dialog thông báo tùy chỉnh
  void _showCustomAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    bool isSuccess = true,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ).animate()
            .fade(duration: 300.ms)
            .scale(duration: 300.ms, alignment: Alignment.center);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: badges.Badge(
              badgeContent: const Text(
                '3',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100.withOpacity(0.7), // Màu nền nhạt
              ),
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ngày vào làm: --/--/----', // Placeholder cho ngày
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.redAccent),
              title: const Text('Thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline, color: Colors.blue),
              title: const Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined, color: Colors.green),
              title: const Text('Lịch làm việc', style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Hiển thị dialog xác nhận đăng xuất
                  bool? confirmLogout = await _showLogoutConfirmationDialog(context);
                  if (confirmLogout == true) {
                    // Thực hiện đăng xuất Firebase
                    try {
                      await _auth.signOut();
                      // Chuyển về màn hình đăng nhập và xóa lịch sử trang
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn_Screen()),
                      );
                    } catch (e) {
                      _showCustomAlertDialog(
                        context: context,
                        title: 'Lỗi đăng xuất',
                        content: 'Đã xảy ra lỗi khi đăng xuất: $e',
                        isSuccess: false,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Xin chào, Nguyễn Văn A',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày: $formattedDate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: <Widget>[
                _buildDashboardIconButton(
                  icon: Icons.restaurant_menu,
                  label: 'Gọi món',
                  backgroundColor: Colors.green.shade100,
                  iconColor: Colors.green.shade700,
                  onPressed: () {
                    // Xử lý khi nhấn Gọi món
                  },
                ),
                _buildDashboardIconButton(
                  icon: Icons.payment,
                  label: 'Thanh toán',
                  backgroundColor: Colors.blue.shade100,
                  iconColor: Colors.blue.shade700,
                  onPressed: () {
                    // Xử lý khi nhấn Thanh toán
                  },
                ),
                _buildDashboardIconButton(
                  icon: Icons.bar_chart,
                  label: 'Báo cáo',
                  backgroundColor: Colors.orange.shade100,
                  iconColor: Colors.orange.shade700,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportsScreen()),
                    );
                  },
                ),
                _buildDashboardIconButton(
                  icon: Icons.insert_chart,
                  label: 'Thống kê',
                  backgroundColor: Colors.yellow.shade100,
                  iconColor: Colors.orange.shade700,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatisticsScreen()),
                    );
                  },
                ),
                _buildDashboardIconButton(
                  icon: Icons.settings,
                  label: 'Cài đặt',
                  backgroundColor: Colors.grey.shade200,
                  iconColor: Colors.grey.shade700,
                  onPressed: () {
                    // Xử lý khi nhấn Cài đặt
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Thống Kê Hôm Nay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildStatisticItem(
                    label: 'Đơn',
                    value: '2',
                    icon: Icons.list_alt_outlined,
                    iconBackgroundColor: Colors.pink.shade100,
                    iconColor: Colors.pink.shade700,
                    onPressed: () {
                      // Xử lý khi nhấn Đơn
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatisticItem(
                    label: 'Chi tiêu',
                    value: '50',
                    icon: Icons.attach_money_outlined,
                    iconBackgroundColor: Colors.green.shade100,
                    iconColor: Colors.green.shade700,
                    onPressed: () {
                      // Xử lý khi nhấn Chi tiêu
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Đơn hàng gần đây',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý khi nhấn Xem tất cả
                  },
                  child: const Text('Xem tất cả', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200, // Đặt chiều cao cố định cho vùng chứa ListView
              child: ListView.separated(
                shrinkWrap: true, // Cần thiết khi ListView nằm trong một cột có kích thước vô hạn (SingleChildScrollView)
                physics: const ClampingScrollPhysics(), // Ngăn cuộn tràn viền
                itemCount: 10, // Tăng số lượng item để thấy hiệu ứng cuộn
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Bàn ăn # ${index + 1}'),
                    subtitle: Text('10:25 PM - ${index + 2} món'),
                    trailing: _buildOrderStatusBadge(index % 3), // Sử dụng lại hàm tạo badge ngẫu nhiên
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GNav(
            gap: 8,
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            color: Colors.grey,
            activeColor: Colors.blue,
            tabBackgroundColor: Colors.blue.shade100,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: 'Trang chủ',
              ),
              GButton(
                icon: Icons.restaurant_menu,
                text: 'Gọi món',
              ),
              GButton(
                icon: Icons.payment_outlined,
                text: 'Thanh toán',
              ),
            ],
            selectedIndex: 0,
            onTabChange: (index) {
              setState(() {
                // Cập nhật trạng thái
              });
              print('Đã chọn tab thứ $index');
            },
          ),
        ),
      ),
    );
  }

  // Hàm hiển thị dialog xác nhận đăng xuất
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Người dùng phải nhấn nút
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Trả về false khi nhấn Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Trả về true khi nhấn OK
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: iconBackgroundColor,
                  radius: 12,
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardIconButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 35, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticIconButton({
    required String label,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 4),
              Icon(icon, color: textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusBadge(int index) {
    switch (index) {
      case 0:
        return Chip(label: const Text('Đang phục vụ', style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange);
      case 1:
        return Chip(label: const Text('Hoàn thành', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green);
      case 2:
        return Chip(label: const Text('Chờ xử lý', style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent);
      default:
        return const SizedBox.shrink();
    }
  }
}