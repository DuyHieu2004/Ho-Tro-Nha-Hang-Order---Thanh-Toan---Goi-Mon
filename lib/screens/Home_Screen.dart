import 'package:doan_nhom_cuoiky/screens/ChangePassword_Screen.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/NhanSuScreen.dart';
import 'package:doan_nhom_cuoiky/screens/SettingScreen.dart';
import 'package:doan_nhom_cuoiky/screens/ThongKeScreen.dart';
import 'package:doan_nhom_cuoiky/widgets/RoleBaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/NhanVien.dart';
import 'Info_Screen.dart';
import 'LogIn_Screen.dart';

class HomeScreen extends StatefulWidget {
  final NhanVien? nhanVien;

  const HomeScreen({super.key, this.nhanVien});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late List<bool> childrenVisibility;
  late bool showStatsSection;
  late bool showManagementSection;

  @override
  void initState() {
    super.initState();
    _initializeRoleBasedVisibility();
  }

  void _initializeRoleBasedVisibility() {
    childrenVisibility = List.filled(8, false);
    showStatsSection = false;
    showManagementSection = false;

    switch (widget.nhanVien?.vaiTro!.trim()) {
      case "Quản lý":
        childrenVisibility = List.filled(8, true);
        showStatsSection = true;
        showManagementSection = true;
        break;
      case "Phục vụ":
        childrenVisibility[0] = true; // Gọi món
        childrenVisibility[2] = true; // Đặt chỗ
        childrenVisibility[3] = true; // Hủy đặt chỗ
        childrenVisibility[7] = true; // Cài đặt
        break;
      case "Thu ngân":
        childrenVisibility[0] = true; // Gọi món
        childrenVisibility[1] = true; // Thanh toán
        childrenVisibility[4] = true; // Báo cáo
        childrenVisibility[7] = true; // Cài đặt
        break;
      default:
        childrenVisibility = List.filled(8, false);
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ).animate().fade(duration: 300.ms).scale(duration: 300.ms, alignment: Alignment.center);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
    final String tenNhanVien = widget.nhanVien?.ten ?? 'Người dùng';

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 25),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tenNhanVien,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.nhanVien?.ngayVL != null
                        ? 'Ngày vào làm: ${DateFormat('dd/MM/yyyy').format(widget.nhanVien!.ngayVL!.toDate())}'
                        : 'Ngày vào làm: Chưa cập nhật',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            RoleBasedWidget(
              isVisible: true,
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.redAccent),
                title: const Text('Thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Info_Screen(nhanVien: widget.nhanVien)),
                  );
                },
              ),
            ),
            RoleBasedWidget(
              isVisible: true,
              child: ListTile(
                leading: const Icon(Icons.lock_outline, color: Colors.blue),
                title: const Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword_Screen()),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  bool? confirmLogout = await _showLogoutConfirmationDialog(context);
                  if (confirmLogout == true) {
                    try {
                      await _auth.signOut();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn_Screen()),
                        (Route<dynamic> route) => false,
                      );
                    } catch (e) {
                      if (!mounted) return;
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
            Text(
              'Xin chào, $tenNhanVien',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày: $formattedDate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth - 32;
                final itemWidth = (availableWidth / 2.2) + 22;
                final itemHeight = itemWidth;

                final children = [
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[0],
                      child: _buildDashboardIconButton(
                        icon: Icons.restaurant_menu,
                        label: 'Gọi món',
                        backgroundColor: isDarkMode ? Colors.green.shade900 : Colors.green.shade100,
                        iconColor: isDarkMode ? Colors.green.shade200 : Colors.green.shade700,
                        onPressed: () => print('Gọi món được nhấn!'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[1],
                      child: _buildDashboardIconButton(
                        icon: Icons.payment,
                        label: 'Thanh toán',
                        backgroundColor: isDarkMode ? Colors.blue.shade900 : Colors.blue.shade100,
                        iconColor: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
                        onPressed: () => print('Thanh toán được nhấn!'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[2],
                      child: _buildDashboardIconButton(
                        icon: Icons.calendar_today,
                        label: 'Đặt chỗ',
                        backgroundColor: isDarkMode ? Colors.orange.shade900 : Colors.orange.shade100,
                        iconColor: isDarkMode ? Colors.orange.shade200 : Colors.orange.shade700,
                        onPressed: () => print('Đặt chỗ được nhấn!'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[3],
                      child: _buildDashboardIconButton(
                        icon: Icons.cancel,
                        label: 'Hủy đặt chỗ',
                        backgroundColor: isDarkMode ? Colors.red.shade900 : Colors.red.shade100,
                        iconColor: isDarkMode ? Colors.red.shade200 : Colors.red.shade700,
                        onPressed: () => print('Hủy đặt chỗ được nhấn!'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[4],
                      child: _buildDashboardIconButton(
                        icon: Icons.bar_chart,
                        label: 'Báo cáo',
                        backgroundColor: isDarkMode ? Colors.yellow.shade900 : Colors.yellow.shade100,
                        iconColor: isDarkMode ? Colors.yellow.shade200 : Colors.yellow.shade700,
                        onPressed: () => print('Báo cáo được nhấn!'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[5],
                      child: _buildDashboardIconButton(
                        icon: Icons.analytics,
                        label: 'Thống kê',
                        backgroundColor: isDarkMode ? Colors.yellow.shade900 : Colors.yellow.shade100,
                        iconColor: isDarkMode ? Colors.yellow.shade200 : Colors.yellow.shade700,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ThongKeScreen()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[6],
                      child: _buildDashboardIconButton(
                        icon: Icons.people,
                        label: 'Nhân sự',
                        backgroundColor: isDarkMode ? Colors.brown.shade900 : Colors.brown.shade50,
                        iconColor: isDarkMode ? Colors.brown.shade200 : Colors.brown.shade700,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NhanSuScreen()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      isVisible: childrenVisibility[7],
                      child: _buildDashboardIconButton(
                        icon: Icons.settings,
                        label: 'Cài đặt',
                        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
                        iconColor: isDarkMode ? Colors.grey.shade200 : Colors.grey.shade700,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingScreen()),
                        ),
                      ),
                    ),
                  ),
                ];

                return Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: children
                      .where((widget) => (widget as SizedBox).child != null && (widget.child as RoleBasedWidget).isVisible)
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Thống Kê Hôm Nay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildStatisticItem(
                        label: 'Đơn',
                        value: '2',
                        icon: Icons.list_alt_outlined,
                        iconBackgroundColor: isDarkMode ? Colors.pink.shade900 : Colors.pink.shade100,
                        iconColor: isDarkMode ? Colors.pink.shade200 : Colors.pink.shade700,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatisticItem(
                        label: 'Chi tiêu',
                        value: '50',
                        icon: Icons.attach_money_outlined,
                        iconBackgroundColor: isDarkMode ? Colors.green.shade900 : Colors.green.shade100,
                        iconColor: isDarkMode ? Colors.green.shade200 : Colors.green.shade700,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RoleBasedWidget(
                  isVisible: true,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _buildStatisticItem(
                          label: 'Khách hàng',
                          value: '21',
                          icon: Icons.person_outline,
                          iconBackgroundColor: isDarkMode ? Colors.purple.shade900 : Colors.purple.shade100,
                          iconColor: isDarkMode ? Colors.purple.shade200 : Colors.purple.shade700,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatisticItem(
                          label: 'Đặt chỗ',
                          value: '21',
                          icon: Icons.calendar_today_outlined,
                          iconBackgroundColor: isDarkMode ? Colors.yellow.shade900 : Colors.yellow.shade100,
                          iconColor: isDarkMode ? Colors.yellow.shade200 : Colors.yellow.shade700,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RoleBasedWidget(
              isVisible: true,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                            blurRadius: 2.0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đơn hàng gần đây',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Xem tất cả', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: SizedBox(
                        height: 200,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: 10,
                          separatorBuilder: (BuildContext context, int index) => const Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Bàn ăn # ${index + 1}'),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '10:25 PM - ${index + 2} món',
                                    style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                                  ),
                                ),
                                trailing: _buildOrderStatusBadge(index % 3),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GNav(
            gap: 8,
            padding: const EdgeInsets.all(16),
            backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
            activeColor: isDarkMode ? Colors.blue.shade200 : Colors.blue,
            tabBackgroundColor: isDarkMode ? Colors.blue.shade900 : Colors.blue.shade100,
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
              setState(() {});
              print('Đã chọn tab thứ $index');
            },
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
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
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusBadge(int status) {
    String label;
    Color color;
    switch (status) {
      case 0:
        label = 'Chờ xử lý';
        color = Colors.orange;
        break;
      case 1:
        label = 'Đã hoàn thành';
        color = Colors.green;
        break;
      case 2:
        label = 'Đã hủy';
        color = Colors.red;
        break;
      default:
        label = 'Không xác định';
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}