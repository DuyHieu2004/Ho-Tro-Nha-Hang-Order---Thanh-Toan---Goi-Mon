import 'package:flutter/material.dart';

import '../models/Ban.dart';
import '../services/BanService.dart';
// Đảm bảo đường dẫn này đúng

class GoiMonScreen extends StatefulWidget {
  const GoiMonScreen({super.key});

  @override
  State<GoiMonScreen> createState() => _GoiMonScreenState();
}

class _GoiMonScreenState extends State<GoiMonScreen> {
  late Future<List<Ban>> _banListFuture;
  final BanService _banService = BanService();
  final TextEditingController _searchController = TextEditingController();

  // Danh sách bàn đầy đủ từ Firestore
  List<Ban> _allBans = [];
  // Danh sách bàn được hiển thị sau khi lọc
  List<Ban> _filteredBans = [];

  // Biến để lưu trữ số lượng bàn theo trạng thái
  int _dangPhucVuCount = 0;
  int _daDatCount = 0;
  int _trongCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAndCalculateTableStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchAndCalculateTableStatus() {
    _banListFuture = _banService.getBanList();
    _banListFuture.then((list) {
      _allBans = list;
      _filteredBans = list; // Ban đầu, danh sách lọc giống danh sách đầy đủ
      _updateTableStatistics(); // Cập nhật thống kê ban đầu
      setState(() {}); // Cập nhật UI
    }).catchError((error) {
      print("Lỗi khi tải danh sách bàn: $error");
      // Hiển thị SnackBar lỗi nếu cần
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu bàn: $error')),
      );
    });
  }

  // Cập nhật thống kê dựa trên _allBans
  void _updateTableStatistics() {
    _dangPhucVuCount = _allBans.where((ban) => ban.trangThai == "Đang phục vụ").length;
    _daDatCount = _allBans.where((ban) => ban.trangThai == "Đã đặt").length;
    _trongCount = _allBans.where((ban) => ban.trangThai == "Trống").length;
  }

  // Hàm lọc bàn khi gõ vào thanh tìm kiếm hoặc nhấn nút
  void _filterTables(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBans = _allBans; // Nếu trống, hiển thị tất cả
      } else {
        _filteredBans = _allBans.where((ban) {
          // Tìm kiếm không phân biệt hoa thường và không phân biệt dấu (ví dụ)
          // Hiện tại chỉ tìm kiếm theo 'ma' bàn
          return ban.ma != null &&
              ban.ma!.toLowerCase().contains(query.toLowerCase());
          // Bạn có thể mở rộng để tìm kiếm theo 'viTri' hoặc 'trangThai'
          // || (ban.viTri != null && ban.viTri!.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  // Hàm trợ giúp để lấy màu nền dựa trên trạng thái bàn
  Color _getTableColor(String? trangThai) {
    switch (trangThai) {
      case "Đã đặt":
        return Colors.blue.shade200; // Màu xanh nhạt
      case "Đang phục vụ":
        return Colors.red.shade200; // Màu đỏ nhạt
      case "Trống":
        return Colors.green.shade200; // Màu xanh lá nhạt
      default:
        return Colors.grey.shade200; // Màu xám mặc định
    }
  }

  // Hàm trợ giúp để lấy màu chữ dựa trên trạng thái bàn
  Color _getTextColor(String? trangThai) {
    switch (trangThai) {
      case "Đã đặt":
      case "Đang phục vụ":
      case "Trống":
        return Colors.black87; // Màu chữ tối cho nền nhạt
      default:
        return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Bàn', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Xử lý thông báo
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh tìm kiếm với nút
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bàn...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton( // Nút tìm kiếm
                    icon: const Icon(Icons.search, color: Colors.blueAccent),
                    onPressed: () {
                      _filterTables(_searchController.text);
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (query) {
                  // Tùy chọn: Lọc ngay khi gõ (real-time search)
                  // _filterTables(query);
                },
                onSubmitted: (query) {
                  // Lọc khi người dùng nhấn Enter trên bàn phím
                  _filterTables(query);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Chú thích trạng thái bàn
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusLegend('Trống', Colors.green),
                _buildStatusLegend('Đang phục vụ', Colors.red),
                _buildStatusLegend('Đã đặt', Colors.blue),
              ],
            ),
            const SizedBox(height: 20),

            // Hiển thị danh sách bàn
            Expanded(
              child: FutureBuilder<List<Ban>>(
                future: _banListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else {
                    // Sau khi dữ liệu tải xong, chúng ta dùng _filteredBans
                    if (_filteredBans.isEmpty) {
                      return const Center(child: Text('Không tìm thấy bàn nào phù hợp.'));
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 cột
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8, // Tỷ lệ chiều rộng/chiều cao của mỗi ô
                      ),
                      itemCount: _filteredBans.length,
                      itemBuilder: (context, index) {
                        Ban ban = _filteredBans[index];
                        return _buildTableCard(ban);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            // Thống kê bàn
            const Text(
              'Thống kê bàn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(color: Colors.grey),
            _buildStatisticRow('Đang phục vụ', _dangPhucVuCount, Colors.red),
            _buildStatisticRow('Đã đặt', _daDatCount, Colors.blue),
            _buildStatisticRow('Trống', _trongCount, Colors.green),
          ],
        ),
      ),
    );
  }

  // Widget để hiển thị chú thích trạng thái
  Widget _buildStatusLegend(String text, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // Widget để hiển thị thông tin từng bàn dưới dạng thẻ
  Widget _buildTableCard(Ban ban) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi nhấn vào bàn (ví dụ: mở chi tiết bàn, đặt bàn, v.v.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn đã chọn Bàn ${ban.ma}')),
        );
      },
      child: Card(
        color: _getTableColor(ban.trangThai),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bàn ${ban.ma ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(ban.trangThai),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${ban.sucChua ?? 'N/A'} khách',
                style: TextStyle(
                  fontSize: 14,
                  color: _getTextColor(ban.trangThai),
                ),
              ),
              // Text(
              //   // Ví dụ hiển thị thời gian đặt cho bàn đã đặt
              //   // Bạn cần thay thế '15:30' bằng dữ liệu thực tế từ model nếu có
              //   ban.trangThai == 'Đã đặt' ? '2 khách - 15:30' : ban.trangThai ?? 'N/A',
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: _getTextColor(ban.trangThai),
              //   ),
              // ),
              // Bạn có thể thêm các thông tin khác như giá, thời gian phục vụ nếu có
              // Text(
              //   ban.trangThai == 'Đang phục vụ' ? '8.000.000 Đ' : '-', // Ví dụ
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: _getTextColor(ban.trangThai),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget để hiển thị một hàng thống kê
  Widget _buildStatisticRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Row(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              // Có thể thêm icon bàn ở đây
              Icon(Icons.table_bar, color: color, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}