import 'package:doan_nhom_cuoiky/providers/HoaDonProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ThongKeScreen extends StatefulWidget {
  const ThongKeScreen({Key? key}) : super(key: key);

  @override
  State<ThongKeScreen> createState() => _ThongKeScreenState();
}

class _ThongKeScreenState extends State<ThongKeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  DateTime selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hoaDonProvider = Provider.of<HoaDonProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thống kê",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tổng quan'),
            Tab(text: 'Theo ngày'),
            Tab(text: 'Theo tháng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTongQuanTab(hoaDonProvider),
          _buildTheoNgayTab(hoaDonProvider),
          _buildTheoThangTab(hoaDonProvider),
        ],
      ),
    );
  }

  Widget _buildTongQuanTab(HoaDonProvider hoaDonProvider) {
    final tongDoanhThu = hoaDonProvider.getTongDoanhThu();
    final soLuongHoaDon = hoaDonProvider.getSoLuongHoaDon();
    final giaTriTrungBinh = hoaDonProvider.getGiaTriTrungBinh();
    final hoaDonCaoNhat = hoaDonProvider.getHoaDonGiaTriCaoNhat();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan doanh thu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Thẻ thông tin tổng quan
          _buildInfoCard(
            'Tổng doanh thu',
            currencyFormat.format(tongDoanhThu),
            Icons.monetization_on,
            Colors.green,
          ),
          _buildInfoCard(
            'Số lượng hóa đơn',
            soLuongHoaDon.toString(),
            Icons.receipt_long,
            Colors.blue,
          ),
          _buildInfoCard(
            'Giá trị trung bình',
            currencyFormat.format(giaTriTrungBinh),
            Icons.trending_up,
            Colors.orange,
          ),
          if (hoaDonCaoNhat != null)
            _buildInfoCard(
              'Hóa đơn cao nhất',
              currencyFormat.format(hoaDonCaoNhat.tongTien ?? 0),
              Icons.star,
              Colors.purple,
            ),
          
          const SizedBox(height: 24),
          const Text(
            'Biểu đồ doanh thu theo tháng (năm hiện tại)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Biểu đồ doanh thu theo tháng
          SizedBox(
            height: 300,
            child: _buildMonthlyRevenueChart(hoaDonProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildTheoNgayTab(HoaDonProvider hoaDonProvider) {
    // Lấy danh sách các ngày có trong hóa đơn
    final List<DateTime> availableDates = hoaDonProvider.hoaDons
        .where((hoaDon) => hoaDon.ngayThanhToan != null)
        .map((hoaDon) => DateTime(
              hoaDon.ngayThanhToan!.year,
              hoaDon.ngayThanhToan!.month,
              hoaDon.ngayThanhToan!.day,
            ))
        .toSet()
        .toList();
    
    // Sắp xếp các ngày theo thứ tự giảm dần
    availableDates.sort((a, b) => b.compareTo(a));
    
    // Nếu không có ngày được chọn hoặc ngày được chọn không có trong danh sách
    if (!availableDates.contains(selectedDate) && availableDates.isNotEmpty) {
      selectedDate = availableDates.first;
    }

    final doanhThuNgay = hoaDonProvider.getDoanhThuTheoNgay(selectedDate);
    final soLuongHoaDonNgay = hoaDonProvider.getSoLuongHoaDonTheoNgay(selectedDate);
    final hoaDonsNgay = hoaDonProvider.getHoaDonTheoNgay(selectedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chọn ngày bằng ComboBox
          Row(
            children: [
              const Text('Chọn ngày:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<DateTime>(
                  value: selectedDate,
                  isExpanded: true,
                  items: availableDates.map((date) => DropdownMenuItem<DateTime>(
                    value: date,
                    child: Text(DateFormat('dd/MM/yyyy').format(date)),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDate = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Thẻ thông tin ngày
          _buildInfoCard(
            'Doanh thu ngày',
            currencyFormat.format(doanhThuNgay),
            Icons.monetization_on,
            Colors.green,
          ),
          _buildInfoCard(
            'Số lượng hóa đơn',
            soLuongHoaDonNgay.toString(),
            Icons.receipt_long,
            Colors.blue,
          ),
          
          const SizedBox(height: 24),
          const Text(
            'Danh sách hóa đơn trong ngày',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Danh sách hóa đơn
          hoaDonsNgay.isEmpty
              ? const Center(
                  child: Text(
                    'Không có hóa đơn nào trong ngày này',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hoaDonsNgay.length,
                  itemBuilder: (context, index) {
                    final hoaDon = hoaDonsNgay[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('Hóa đơn #${hoaDon.ma}'),
                        subtitle: Text(
                          'Thời gian: ${DateFormat('HH:mm').format(hoaDon.ngayThanhToan ?? DateTime.now())}',
                        ),
                        trailing: Text(
                          currencyFormat.format(hoaDon.tongTien ?? 0),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildTheoThangTab(HoaDonProvider hoaDonProvider) {
    final doanhThuThang = hoaDonProvider.getDoanhThuTheoThang(selectedMonth, selectedYear);
    final hoaDonsThang = hoaDonProvider.getHoaDonTheoThang(selectedMonth, selectedYear);
    final hoaDonCaoNhatThang = hoaDonProvider.getHoaDonGiaTriCaoNhatTheoThang(selectedMonth, selectedYear);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chọn tháng và năm
          Row(
            children: [
              const Text('Tháng:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(12, (index) => index + 1)
                    .map((month) => DropdownMenuItem<int>(
                          value: month,
                          child: Text(month.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMonth = value;
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              const Text('Năm:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(6, (index) => DateTime.now().year - 2 + index)
                    .map((year) => DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedYear = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Thẻ thông tin tháng
          _buildInfoCard(
            'Doanh thu tháng',
            currencyFormat.format(doanhThuThang),
            Icons.monetization_on,
            Colors.green,
          ),
          _buildInfoCard(
            'Số lượng hóa đơn',
            hoaDonsThang.length.toString(),
            Icons.receipt_long,
            Colors.blue,
          ),
          if (hoaDonCaoNhatThang != null)
            _buildInfoCard(
              'Hóa đơn cao nhất',
              currencyFormat.format(hoaDonCaoNhatThang.tongTien ?? 0),
              Icons.star,
              Colors.purple,
            ),
          
          const SizedBox(height: 24),
          const Text(
            'Biểu đồ doanh thu theo ngày trong tháng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Biểu đồ doanh thu theo ngày trong tháng
          SizedBox(
            height: 300,
            child: _buildDailyRevenueChart(hoaDonProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  Widget _buildMonthlyRevenueChart(HoaDonProvider hoaDonProvider) {
    final currentYear = DateTime.now().year;
    final monthlyData = List.generate(12, (index) {
      final month = index + 1;
      return FlSpot(
        month.toDouble(),
        hoaDonProvider.getDoanhThuTheoThang(month, currentYear) / 1000000, // Đơn vị: triệu đồng
      );
    });

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 8.0, top: 16.0, bottom: 12.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final month = value.toInt();
                  if (month >= 1 && month <= 12) {
                    return Text(
                      '$month',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}tr',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 1,
          maxX: 12,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: monthlyData,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRevenueChart(HoaDonProvider hoaDonProvider) {
    // Tính số ngày trong tháng
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    
    // Tạo dữ liệu cho biểu đồ
    final dailyData = List.generate(daysInMonth, (index) {
      final day = index + 1;
      final date = DateTime(selectedYear, selectedMonth, day);
      return FlSpot(
        day.toDouble(),
        hoaDonProvider.getDoanhThuTheoNgay(date) / 1000000, // Đơn vị: triệu đồng
      );
    });

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 8.0, top: 16.0, bottom: 12.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: dailyData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${group.x.toInt()}: ${currencyFormat.format(rod.toY * 1000000)}',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Chỉ hiển thị một số ngày để tránh quá đông
                  if (value.toInt() % 5 == 0 || value.toInt() == 1 || value.toInt() == daysInMonth) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
                        leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}tr',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          barGroups: dailyData.map((spot) => 
            BarChartGroupData(
              x: spot.x.toInt(),
              barRods: [
                BarChartRodData(
                  toY: spot.y,
                  color: Theme.of(context).colorScheme.primary,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            )
          ).toList(),
        ),
      ),
    );
  }
}