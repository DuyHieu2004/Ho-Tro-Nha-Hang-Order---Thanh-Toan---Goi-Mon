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
    final List<double> dailyRevenue = [250, 105, 120, 140, 90, 104, 100];
    final List<double> customerCounts = [17, 24, 10, 50, 12, 30, 15];
    final List<int> orderCounts = [15, 7, 8, 10, 12, 5, 4];

    final double revenueScale = 0.2;
    final double maxY = 60;

    // Ngày gần đây (7 ngày gần nhất)
    final now = DateTime.now();
    final List<String> recentDays = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return '${date.day}/${date.month}';
    });

    final List<FlSpot> revenueLine = List.generate(
      dailyRevenue.length,
          (i) => FlSpot(i + 0.5, dailyRevenue[i] * revenueScale),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thống kê doanh thu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Row(
            children: [
              Row(
                children: [
                  Container(width: 16, height: 8, color: Colors.green.shade600),
                  const SizedBox(width: 4),
                  const Text('Khách hàng', style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(width: 16, height: 8, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  const Text('Doanh thu', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          AspectRatio(
            aspectRatio: 0.9, //kích thước biêủ đồ
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    gridData: FlGridData(show: false),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < recentDays.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  recentDays[value.toInt()],
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 10,
                          getTitlesWidget: (value, meta) {
                            final scaled = value / revenueScale;
                            if (scaled % 10 == 0) { //chỉnh cột y bên phải
                              return Text('${scaled.toStringAsFixed(0)}k', style: const TextStyle(fontSize: 12));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(customerCounts.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 40,
                        barRods: [
                          BarChartRodData(
                            toY: customerCounts[i],
                            color: Colors.green.shade600,
                            width: 15, //độ rộng cột
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 10,
                    ),
                    lineTouchData: LineTouchData(enabled: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
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

  const SizedBox(height: 20),

          /// Mục thống kê hôm nay
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thống kê hôm nay',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Text('Số khách hàng:'),
                    const Spacer(),
                    Text('${customerCounts.last.toInt()} người'),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text('Tổng doanh thu:'),
                    const Spacer(),
                    Text('${dailyRevenue.last.toInt()}.000 VNĐ'),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text('Số đơn hàng:'),
                    const Spacer(),
                    Text('${orderCounts.last.toInt()} đơn'),
                  ],
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
