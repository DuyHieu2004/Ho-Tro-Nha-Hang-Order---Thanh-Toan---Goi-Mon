import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportsScreen(),
    ),
  );
}

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
                        width: 340, // chiều rộng khung
                        padding: const EdgeInsets.all(25),
                        color: Colors.grey.shade300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header ngày
                            Center(
                              child: Text(
                                _formatDate(_recentDates[_selectedDateIndex]),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Danh sách báo cáo
                            Expanded(
                              child: ListView.builder(
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text('Nguyễn Văn A'),
                                            SizedBox(height: 4),
                                            Text('Số hóa đơn: 10'),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: xử lý xem chi tiết
                                          },
                                          child: const Text('Xem chi tiết'),
                                        ),
                                      ],
                                    ),
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
                  _buildReportCard(),
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

Widget _buildReportCard() {
  return Container(
    width: 320,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Bản báo cáo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ngày', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('15/2/2025', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hóa đơn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('15', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Doanh thu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('15.000', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Người lập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Nguyen Van A', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    ),
  );
}
