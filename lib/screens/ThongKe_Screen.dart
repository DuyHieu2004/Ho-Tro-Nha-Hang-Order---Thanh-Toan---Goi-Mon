import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/dsnhanvien_data.dart';
import '../data/report_data.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedTab = 0;

  List<String> getNewEmployees(List<Employee> employees) {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
    return employees
        .where((e) => e.workingDate.isAfter(cutoffDate))
        .map((e) => e.name)
        .toList();
  }

  List<String> getOldEmployees(List<Employee> employees) {
    final newNames = getNewEmployees(employees).toSet();
    return employees
        .where((e) => !newNames.contains(e.name))
        .map((e) => e.name)
        .toList();
  }

  int getTotalUniqueEmployees(List<Employee> employees) {
    return employees.map((e) => e.name).toSet().length;
  }

  List<Map<String, dynamic>> buildEmployeeDisplayList(List<String> names) {
    return names.map((name) => {'name': name, 'isChecked': false}).toList();
  }

  void _showEmployeeDetails(String name) {
    final employee = employeeList.firstWhere((e) => e.name == name);
    final formattedDate = DateFormat('dd/MM/yyyy').format(employee.workingDate); // <-- Định dạng ngày

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Tên: ${employee.name}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Ngày vào làm: $formattedDate', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              // Thêm các thông tin khác nếu có, ví dụ: chức vụ, số điện thoại,...
              // Text('Chức vụ: ${employee.position}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmployeeList(List<Map<String, dynamic>> employeeList) {
    return Column(
      children: employeeList.map((employee) {
        final String fullName = employee['name'];
        final String firstLetter = fullName.split(' ').first.substring(0, 1).toUpperCase();

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade700,
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(fullName),
          trailing: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_horiz, size: 20, color: Colors.black87),
              onPressed: () {
                _showEmployeeDetails(fullName);
              },
            ),
          ),
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final newEmployees = getNewEmployees(employeeList);
    final oldEmployees = getOldEmployees(employeeList);
    final newEmployeesList = buildEmployeeDisplayList(newEmployees);
    final oldEmployeesList = buildEmployeeDisplayList(oldEmployees);

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
          child: Container(height: 0.5, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
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
                  _buildCircleBox(
                    title: 'Tổng',
                    color: Colors.black,
                    value: getTotalUniqueEmployees(employeeList),
                  ),
                  const SizedBox(width: 24),
                  _buildCircleBox(
                    title: 'Mới',
                    color: Colors.greenAccent,
                    value: newEmployees.length,
                  ),
                ],
              ),
            ),
          Expanded(
            child: _selectedTab == 0
                ? _buildEmployeeStatistics(newEmployeesList, oldEmployeesList)
                : _buildRevenueStatistics(),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBox({required String title, required Color color, required int value}) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
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

  Widget _buildEmployeeStatistics(
      List<Map<String, dynamic>> newEmployees,
      List<Map<String, dynamic>> oldEmployees) {
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
              children: newEmployees.isEmpty
                  ? [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Không có nhân viên mới.'),
                )
              ]
                  : [_buildEmployeeList(newEmployees)],
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
              children: oldEmployees.isEmpty
                  ? [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Không có nhân viên cũ.'),
                )
              ]
                  : [_buildEmployeeList(oldEmployees)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueStatistics() {
    final now = DateTime.now();
    final double revenueScale = 1 / 1_000_000; // 1 đơn vị = 1 triệu
    // final double maxY = 6.0; // 6 triệu -> 6 sau khi scale

    // Lấy 7 ngày gần nhất và format key
    final List<DateTime> last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    final List<String> recentDays = last7Days.map((date) => '${date.day}/${date.month}').toList();

    // Dữ liệu thống kê mỗi ngày
    final List<double> dailyRevenue = [];
    final List<double> customerCounts = [];
    final List<int> orderCounts = [];

    for (final date in last7Days) {
      final key = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      final dailyReports = mockReportData[key] ?? [];

      final revenue = dailyReports.fold<double>(0.0, (sum, e) => sum + e.revenue);
      final customers = dailyReports.fold<int>(0, (sum, e) => sum + e.customerCount);
      final orders = dailyReports.fold<int>(0, (sum, e) => sum + e.invoiceCount);

      dailyRevenue.add(revenue);
      customerCounts.add(customers.toDouble());
      orderCounts.add(orders);
    }

    final List<FlSpot> revenueLine = List.generate(
      dailyRevenue.length,
          (index) => FlSpot(index.toDouble(), dailyRevenue[index] * revenueScale),
    );

    //Thống kê hôm nay
    final todayKey = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final todayReport = mockReportData[todayKey] ?? [];
    final int todayCustomerCount = todayReport.fold(0, (sum, entry) => sum + entry.customerCount);
    final int todayInvoiceCount = todayReport.fold(0, (sum, entry) => sum + entry.invoiceCount);
    final double todayRevenue = todayReport.fold(0.0, (sum, entry) => sum + entry.revenue);

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
            aspectRatio: 0.9,
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    minY: 0,
                    maxY: 60,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.black54,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${recentDays[group.x.toInt()]}\n'
                                'Khách hàng: ${customerCounts[group.x.toInt()].toInt()}',
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < recentDays.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  recentDays[value.toInt()],
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
                          interval: 10,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    groupsSpace: 10,
                    barGroups: List.generate(customerCounts.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: customerCounts[i],
                            color: Colors.green.shade600,
                            width: 18,
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
                    maxY: 6,
                    gridData: FlGridData(show: false),
                    lineTouchData: LineTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}tr',
                              style: const TextStyle(fontSize: 10),
                              textAlign: TextAlign.left,
                            );
                          },
                        ),
                      ),
                    ),
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


          const SizedBox(height: 28),

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
                    Text('$todayCustomerCount người'),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text('Tổng doanh thu:'),
                    const Spacer(),
                    Text('${todayRevenue.toInt().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')} VNĐ'),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text('Số đơn hàng:'),
                    const Spacer(),
                    Text('$todayInvoiceCount đơn'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  }

