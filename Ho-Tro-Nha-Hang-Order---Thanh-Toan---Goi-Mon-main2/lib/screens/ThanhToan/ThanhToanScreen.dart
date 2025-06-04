import 'package:doan_nhom_cuoiky/providers/DonGoiMonProvider.dart';
import 'package:doan_nhom_cuoiky/screens/ThanhToan/ChiTietThanhToanScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThanhToanScreen extends StatefulWidget {
  const ThanhToanScreen({super.key});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  String searchQuery = '';
  String selectedFilter = 'Tất cả';
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DonGoiMonProvider>(context, listen: false);
      provider.layDonDangPhucVu();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });

    await Provider.of<DonGoiMonProvider>(context, listen: false).layDonDangPhucVu();
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Thanh Toán',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Consumer<DonGoiMonProvider>(
        builder: (context, donGoiMonProvider, child) {
          final orders = donGoiMonProvider.layDonDangPhucVu();
          final filteredTables =
              orders
                  .where(
                    (order) =>
                        (searchQuery.isEmpty ||
                            (order.maBan?.viTri ?? '').contains(searchQuery)) &&
                        (selectedFilter == 'Tất cả' ||
                            (selectedFilter == 'Đang phục vụ' &&
                                order.trangThai == 'Đang phục vụ') ||
                            (selectedFilter == 'Chờ' &&
                                order.trangThai == 'Chờ')),
                  )
                  .toList()
                ..sort(
                  (a, b) =>
                      (a.maBan?.viTri ?? '').compareTo(b.maBan?.viTri ?? ''),
                );

          return Column(
            children: [
              // Header với màu nền và đổ bóng
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Thanh tìm kiếm cải tiến
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm bàn ...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),

                    // Bộ lọc trạng thái
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Tất cả'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Đang phục vụ'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Chờ'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Danh sách bàn
              Expanded(
                child:
                    isRefreshing
                        ? const Center(child: CircularProgressIndicator())
                        : filteredTables.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredTables.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.1,
                              ),
                          itemBuilder: (_, index) {
                            final order = filteredTables[index];
                            final tableName =
                                order.maBan?.viTri ?? 'Bàn ${index + 1}';
                            final status = order.trangThai ?? 'Chờ';
                            final people =
                                order.ghiChu?.contains('khách') ?? false
                                    ? order.ghiChu!.split(' ').first
                                    : '0';

                            return _buildTableCard(
                              context,
                              order,
                              tableName,
                              status,
                              people,
                            );
                          },
                        ),
              ),

              // Thanh điều hướng cải tiến
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),               
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      onSelected: (selected) {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }

  Widget _buildTableCard(
    BuildContext context,
    dynamic order,
    String tableName,
    String status,
    String people,
  ) {
    final isServing = status == 'Đang phục vụ';
    final statusColor = isServing ? Colors.red : Colors.blue;
    final bgColor = isServing ? Colors.red[50] : Colors.blue[50];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChiTietThanhToanScreen(order: order),
            ),
          ).then((_) => _refreshData());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tableName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isServing ? 'Đang phục vụ' : 'Chờ',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.people, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$people khách',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.table_bar, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Không có bàn nào',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Không tìm thấy bàn phù hợp với bộ lọc',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Làm mới'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
