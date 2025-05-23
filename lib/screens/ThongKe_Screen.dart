import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatisticsScreen(),
    ),
  );
}

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedTab = 0; // 0: Nhân viên, 1: Doanh thu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Thống kê',
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
      body: Column(
        children: [
          // Tab chọn loại thống kê
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatisticTab(
                  label: 'Nhân viên',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                const SizedBox(width: 16),
                _buildStatisticTab(
                  label: 'Doanh thu',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
          ),

          if (_selectedTab == 0)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Vòng tròn "Tổng"
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tổng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('155', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Vòng tròn "Mới"
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Mới', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Nội dung thống kê
          Expanded(
            child: _selectedTab == 0
                ? _buildEmployeeStatistics()
                : _buildRevenueStatistics(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> newEmployees = [
    {'name': 'Nguyễn Văn A', 'isChecked': false},
    {'name': 'Nguyễn Văn B', 'isChecked': true},
    {'name': 'Nguyễn Văn C', 'isChecked': true},
  ];

  List<Map<String, dynamic>> employees = [
    {'name': 'Trần Thị D', 'isChecked': false},
    {'name': 'Lê Văn E', 'isChecked': true},
    {'name': 'Phạm Thị F', 'isChecked': true},
  ];

  Widget _buildEmployeeStatistics() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: const Text(
                'Nhân viên mới',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [_buildEmployeeList(newEmployees)],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: const Text(
                'Nhân viên',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [_buildEmployeeList(employees)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(List<Map<String, dynamic>> employees) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade700,
            child: Text(
              employee['name'].toString().substring(0, 1),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(employee['name']),
          trailing: GestureDetector(
            onTap: () {
              // TODO: Xử lý khi nhấn vào dấu 3 chấm
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1.5),
              ),
              padding: const EdgeInsets.all(6.0),
              child: const Icon(
                Icons.more_horiz,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevenueStatistics() {
    final List<double> dailyRevenue = [10, 15, 12, 14, 9, 14, 10]; // doanh thu
    final List<double> customerCounts = [30, 40, 28, 50, 20, 35, 45]; // khách hàng

    // Scale doanh thu để phù hợp với trục y (giả sử max khách hàng ~60)
    final double revenueScale = 3.5;
    final List<FlSpot> revenueLine = List.generate(
      dailyRevenue.length,
          (index) => FlSpot(index + 1.8, dailyRevenue[index] * revenueScale), // dịch qua phải
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê doanh thu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          AspectRatio(
            aspectRatio: 1.6,
            child: Stack(
              children: [
                /// Biểu đồ cột (Khách hàng)
                BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: 300,
                    barTouchData: BarTouchData(enabled: false),
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  days[value.toInt()],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(customerCounts.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 40, // thêm khoảng cách giữa các cột
                        barRods: [
                          BarChartRodData(
                            toY: customerCounts[i],
                            color: Colors.green.shade600,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                /// Biểu đồ đường (Doanh thu)
                LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 110,
                          getTitlesWidget: (value, meta) {
                            final scaledValue = value / revenueScale;
                            return Text('${scaledValue.toStringAsFixed(0)}k', style: const TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 60,
                    lineBarsData: [
                      LineChartBarData(
                        spots: revenueLine,
                        isCurved: true,
                        color: Colors.amber.shade700,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
