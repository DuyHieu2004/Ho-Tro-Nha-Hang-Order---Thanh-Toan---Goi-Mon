import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/report_data.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedDateIndex = 0;
  String _selectedTab = 'Xem báo cáo';
  String _selectedFilterType = 'Ngày'; // Mặc định là Ngày
  bool _showFilterOptions = false;

  List<String> get _filterItems {
    final now = DateTime.now();

    if (_selectedFilterType == 'Ngày') {
      return _recentDates.map((d) => _formatDate(d)).toList();
    } else if (_selectedFilterType == 'Tháng') {
      return List.generate(7, (i) {
        final date = DateTime(now.year, now.month - i, 1);
        return '${date.month.toString().padLeft(2, '0')}/${date.year}';
      });
    } else {
      return List.generate(7, (i) => (now.year - i).toString());
    }
  }

  final List<DateTime> _recentDates = List.generate(
    7,
        (index) => DateTime.now().subtract(Duration(days: index)),
  );

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, //Đổi nền toàn bộ màn hình
        appBar: AppBar(
        backgroundColor: Colors.white,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTab,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() {
                          _selectedTab = value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Xem báo cáo',
                          child: Text('Xem báo cáo'),
                        ),
                        const PopupMenuItem(
                          value: 'Lập báo cáo',
                          child: Text('Lập báo cáo'),
                        ),
                      ],
                      icon: const Icon(Icons.menu, size: 25),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

            // Nội dung theo từng tab
            Expanded(
              child: _selectedTab == 'Xem báo cáo'
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedFilterType, // Ngày / Tháng / Năm
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          decorationThickness: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        onPressed: () {
                          setState(() {
                            _showFilterOptions = !_showFilterOptions;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_showFilterOptions)
                    Row(
                      children: ['Ngày', 'Tháng', 'Năm'].map((type) {
                        final isSelected = _selectedFilterType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilterType = type;
                              _showFilterOptions = false;
                              _selectedDateIndex = 0; // reset index
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.green : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 6),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filterItems.length, // cập nhật biến động
                      itemBuilder: (context, index) {
                        final isSelected = _selectedDateIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDateIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.green.shade700 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _filterItems[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 340,
                        padding: const EdgeInsets.all(25),
                        color: Colors.grey.shade300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hiển thị tiêu đề Ngày / Tháng / Năm
                            Center(
                              child: Text(
                                _selectedFilterType == 'Năm'
                                    ? 'Năm ${_filterItems[_selectedDateIndex]}'
                                    : _selectedFilterType == 'Tháng'
                                    ? 'Tháng ${_filterItems[_selectedDateIndex]}'
                                    : _formatDate(_recentDates[_selectedDateIndex]),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Danh sách báo cáo
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final selectedDateStr = _filterItems[_selectedDateIndex];
                                  final entries = mockReportData[selectedDateStr] ?? [];

                                  if (entries.isEmpty) {
                                    return const Center(child: Text('Không có dữ liệu.'));
                                  }

                                  return ListView.builder(
                                    itemCount: entries.length,
                                    itemBuilder: (context, index) {
                                      final entry = entries[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(entry.name,
                                                    style: const TextStyle(
                                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 4),
                                                Text('Số hóa đơn: ${entry.invoiceCount}'),
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.white,
                                                      title: const Center(child: Text('Chi tiết báo cáo')),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const SizedBox(height: 16),
                                                          Text('👤 Tên nhân viên: ${entry.name}', style: const TextStyle(fontSize: 16)),
                                                          const SizedBox(height: 8),
                                                          Text('🧾 Số hóa đơn: ${entry.invoiceCount}', style: const TextStyle(fontSize: 16)),
                                                          const SizedBox(height: 8),
                                                          Text('💰 Doanh thu: ${NumberFormat('#,###', 'vi_VN').format(entry.revenue)} VND',
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          Align(
                                                            alignment: Alignment.center,
                                                            child: ElevatedButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.green[700], // nền xanh
                                                                foregroundColor: Colors.white, // chữ trắng
                                                              ),
                                                              child: const Text('Đóng'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Text('Xem chi tiết'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                  children: [
                    _buildReportCard(_filterItems[_selectedDateIndex]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Xử lý lưu báo cáo
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Lưu báo cáo',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildReportCard(String dateKey) {
  final entries = mockReportData[dateKey] ?? [];

  final totalInvoices = entries.fold<int>(0, (sum, e) => sum + e.invoiceCount);
  final totalRevenue = entries.fold<double>(0.0, (sum, e) => sum + e.revenue);
  final nguoiLap = entries.isNotEmpty ? entries.first.name : "Chưa rõ";

  return Container(
    width: 320,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Bản báo cáo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ngày', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(dateKey, style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Hóa đơn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('$totalInvoices', style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Doanh thu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${NumberFormat("#,##0", "vi_VN").format(totalRevenue)} đ',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Người lập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(nguoiLap, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    ),
  );
}




