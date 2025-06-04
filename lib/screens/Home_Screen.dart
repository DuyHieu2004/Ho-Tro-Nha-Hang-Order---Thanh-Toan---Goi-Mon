import 'package:doan_nhom_cuoiky/screens/ChangePassword_Screen.dart';
import 'package:doan_nhom_cuoiky/screens/GoiMonScreen.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/NhanSuScreen.dart';
import 'package:doan_nhom_cuoiky/screens/SettingScreen.dart';
import 'package:doan_nhom_cuoiky/screens/ThongKeScreen.dart';
import 'package:doan_nhom_cuoiky/services/HoaDonSerivice.dart';
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
import 'ReservationListScreen.dart';

class Home_Screen1 extends StatefulWidget {
  final NhanVien? nhanVien;

  Home_Screen1({this.nhanVien});

  @override
  _Home_Screen1State createState() => _Home_Screen1State();
}

class _Home_Screen1State extends State<Home_Screen1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HoaDonService _hoaDonService = HoaDonService();
  List<bool> _childrenVisibility = List.filled(8, false);

  late Future<int> _todayOrderCount;
  late Future<double> _todayRevenue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todayOrderCount = _hoaDonService.getTodayHoaDonCount();
    _todayRevenue =_hoaDonService.getTodayRevenue();
    print(_todayRevenue);
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

  int soDon =0;
  @override
  Widget build(BuildContext context) {
    _childrenVisibility = List.filled(8, false);
    bool showStatsSection = false;
    bool showManagementSection = false;

    switch (widget.nhanVien?.vaiTro?.ten) {
      case "Quản lý":
        _childrenVisibility = List.filled(8, true);
        showStatsSection = true;
        showManagementSection = true;
        break;
      case "Phục vụ":
        _childrenVisibility[0] = true;
        _childrenVisibility[2] = true;
        _childrenVisibility[3] = true;
        _childrenVisibility[7] = true;
        showManagementSection = true;
        break;
      case "Thu ngân":
        _childrenVisibility[0] = true;
        _childrenVisibility[1] = true;
        _childrenVisibility[4] = true;
        _childrenVisibility[7] = true;
        showStatsSection = true;
        break;
      default:
        _childrenVisibility = List.filled(8, false);
        showStatsSection = false;
        showManagementSection = false;
    }

    HoaDonService hoaDonService = HoaDonService();


    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
    final String _tenNhanVien = widget.nhanVien?.ten ?? '';
    final String? anh = widget.nhanVien?.anh;
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
                color: Colors.blue.shade100.withOpacity(0.7),
              ),
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: anh != null && anh.isNotEmpty
                            ? NetworkImage(anh)
                            : const NetworkImage('https://via.placeholder.com/150'),
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
                  Text(
                    _tenNhanVien,
                    style: TextStyle(
                      color: Colors.blueAccent,
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
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            RoleBasedWidget(
                child: ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.redAccent),
                  title: const Text('Thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)
                    => Info_Screen(nhanVien: widget.nhanVien,),));
                  },
                ),
                isVisible: true
            ),

            RoleBasedWidget(
                child: ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.blue),
                  title: const Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder:
                            (context) => ChangePassword_Screen(
                              nhanVien: widget.nhanVien,),));
                  },
                ),
                isVisible: true
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
             Text(
              'Xin chào, ${_tenNhanVien}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                final itemWidth = (availableWidth / 2.2)+22;
                final aspectRatio = 1.0;
                final itemHeight = itemWidth * aspectRatio;

                final children = [
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.restaurant_menu,
                        label: 'Gọi món',
                        backgroundColor: Colors.green.shade100,
                        iconColor: Colors.green.shade700,
                        onPressed: () {
                         // print('Gọi món được nhấn!');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoiMonScreen(),));
                        },
                      ),
                      isVisible: _childrenVisibility[0],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.payment,
                        label: 'Thanh toán',
                        backgroundColor: Colors.blue.shade100,
                        iconColor: Colors.blue.shade700,
                        onPressed: () {
                          print('Thanh toán được nhấn!');
                        },
                      ),
                      isVisible: _childrenVisibility[1],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.calendar_today,
                        label: 'Đặt chỗ',
                        backgroundColor: Colors.green,
                        iconColor: Colors.orangeAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReservationListScreen()),
                          );
                        },
                      ),
                      isVisible: _childrenVisibility[2],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.cancel,
                        label: 'Hủy đặt chỗ',
                        backgroundColor: Colors.red.shade100,
                        iconColor: Colors.red.shade700,
                        onPressed: () {
                          print('Hủy đặt chỗ được nhấn!');
                        },
                      ),
                      isVisible: _childrenVisibility[3],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.bar_chart,
                        label: 'Báo cáo',
                        backgroundColor: Colors.orange.shade100,
                        iconColor: Colors.orange.shade700,
                        onPressed: () {
                          print('Báo cáo được nhấn!');
                        },
                      ),
                      isVisible: _childrenVisibility[4],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.analytics,
                        label: 'Thống kê',
                        backgroundColor: Colors.yellow.shade100,
                        iconColor: Colors.yellow.shade700,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ThongKeScreen(),
                            ),
                          );
                        },
                      ),
                      isVisible: _childrenVisibility[5],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.people,
                        label: 'Nhân sự',
                        backgroundColor: Colors.brown.shade50,
                        iconColor: Colors.brown.shade200,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => NhanSuScreen(),),
                          );
                        },
                      ),
                      isVisible: _childrenVisibility[6],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: RoleBasedWidget(
                      child: _buildDashboardIconButton(
                        icon: Icons.settings,
                        label: 'Cài đặt',
                        backgroundColor: Colors.grey.shade200,
                        iconColor: Colors.grey.shade700,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingScreen(),));
                        },
                      ),
                      isVisible: _childrenVisibility[7],
                    ),
                  ),
                ];

                return Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: children.where((widget) => (widget as SizedBox).child != null && (widget.child as RoleBasedWidget).isVisible).toList(),
                );
              },
            ),


            const SizedBox(height: 20),
            if (showStatsSection) ...[
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
                        child: FutureBuilder<int>(
                          future: _todayOrderCount, // Sử dụng Future đã khởi tạo
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _buildStatisticItem(
                                label: 'Đơn',
                                value: 'Đang tải...', // Hiển thị trạng thái tải
                                icon: Icons.list_alt_outlined,
                                iconBackgroundColor: Colors.pink.shade100,
                                iconColor: Colors.pink.shade700,
                                onPressed: () {},
                              );
                            } else if (snapshot.hasError) {
                              return _buildStatisticItem(
                                label: 'Đơn',
                                value: 'Lỗi!', // Hiển thị lỗi nếu có
                                icon: Icons.error_outline,
                                iconBackgroundColor: Colors.red.shade100,
                                iconColor: Colors.red.shade700,
                                onPressed: () {},
                              );
                            } else {
                              // Khi Future hoàn thành, hiển thị giá trị
                              return _buildStatisticItem(
                                label: 'Đơn',
                                value: snapshot.data?.toString() ?? '0', // Chuyển int sang String
                                icon: Icons.list_alt_outlined,
                                iconBackgroundColor: Colors.pink.shade100,
                                iconColor: Colors.pink.shade700,
                                onPressed: () {
                                  // Xử lý khi nhấn Đơn
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        // child: _buildStatisticItem(
                        //   label: 'Doanh thu',
                        //   value: '50',
                        //   icon: Icons.attach_money_outlined,
                        //   iconBackgroundColor: Colors.green.shade100,
                        //   iconColor: Colors.green.shade700,
                        //   onPressed: () {
                        //     // Xử lý khi nhấn Chi tiêu
                        //   },
                        // ),
                        child: FutureBuilder<double>(
                          future: _todayRevenue, // Sử dụng Future đã khởi tạo
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _buildStatisticItem(
                                label: 'Doanh thu',
                                value: 'Đang tải...', // Hiển thị trạng thái tải
                                icon: Icons.list_alt_outlined,
                                iconBackgroundColor: Colors.pink.shade100,
                                iconColor: Colors.pink.shade700,
                                onPressed: () {},
                              );
                            } else if (snapshot.hasError) {
                              return _buildStatisticItem(
                                label: 'Doanh thu',
                                value: 'Lỗi!', // Hiển thị lỗi nếu có
                                icon: Icons.error_outline,
                                iconBackgroundColor: Colors.red.shade100,
                                iconColor: Colors.red.shade700,
                                onPressed: () {},
                              );
                            } else {
                              // Khi Future hoàn thành, hiển thị giá trị
                              return _buildStatisticItem(
                                label: 'Doanh thu',
                                value: snapshot.data?.toString() ?? '0', // Chuyển int sang String
                                  icon: Icons.attach_money_outlined,
                                  iconBackgroundColor: Colors.green.shade100,
                                  iconColor: Colors.green.shade700,
                                onPressed: () {
                                  // Xử lý khi nhấn Đơn
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // RoleBasedWidget(
                  //     child: Row(
                  //       children: <Widget>[
                  //         Expanded(
                  //           child: _buildStatisticItem(
                  //             label: 'Khách hàng',
                  //             value: '21',
                  //             icon: Icons.person_outline,
                  //             iconBackgroundColor: Colors.purple.shade100,
                  //             iconColor: Colors.purple.shade700,
                  //             onPressed: () {
                  //               // Xử lý khi nhấn Khách hàng
                  //             },
                  //           ),
                  //         ),
                  //         const SizedBox(width: 16),
                  //         Expanded(
                  //           child: _buildStatisticItem(
                  //             label: 'Đặt chỗ',
                  //             value: '21',
                  //             icon: Icons.calendar_today_outlined,
                  //             iconBackgroundColor: Colors.yellow.shade100,
                  //             iconColor: Colors.yellow.shade700,
                  //             onPressed: () {
                  //               // Xử lý khi nhấn Đặt chỗ
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     isVisible: showStatsSection
                  // )
                ],
              ),
            ],


            SizedBox(height: 12,),
            if (showManagementSection)
              RoleBasedWidget(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2.0,
                                offset: Offset(0, 1),
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
                                onPressed: () {
                                  // Xử lý khi nhấn Xem tất cả
                                },
                                child: const Text('Xem tất cả', style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
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
                                        style: TextStyle(color: Colors.grey.shade600),
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
                  isVisible: showManagementSection
              )
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
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 70, color: iconColor),
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