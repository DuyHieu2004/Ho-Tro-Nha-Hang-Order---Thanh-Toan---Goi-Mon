class ReportEntry {
  final String employeeId;        // Mã nhân viên (NV001, NV002,...)
  final String name;              // Tên nhân viên
  final int invoiceCount;
  final double revenue;
  final int customerCount;
  final String shiftStart;        // Giờ bắt đầu ca
  final String shiftEnd;          // Giờ kết thúc ca

  ReportEntry({
    required this.employeeId,
    required this.name,
    required this.invoiceCount,
    required this.revenue,
    required this.customerCount,
    required this.shiftStart,
    required this.shiftEnd,
  });
}

final Map<String, List<ReportEntry>> mockReportData = {
  '31/05/2025': [
    ReportEntry(employeeId: 'NV001', name: 'Nguyễn Hoàng Long', invoiceCount: 7, revenue: 1750000, customerCount: 10, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV002', name: 'Trần Thu Hà', invoiceCount: 5, revenue: 570000, customerCount: 7, shiftStart: '12:00', shiftEnd: '16:00'),
    ReportEntry(employeeId: 'NV003', name: 'Đỗ Hoàng Uyên', invoiceCount: 2, revenue: 170000, customerCount: 2, shiftStart: '16:00', shiftEnd: '22:00'),
  ],
  '30/05/2025': [
    ReportEntry(employeeId: 'NV004', name: 'Lê Minh Tuấn', invoiceCount: 14, revenue: 2600000, customerCount: 15, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV005', name: 'Phạm Hải Nam', invoiceCount: 8, revenue: 1500000, customerCount: 9, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '29/05/2025': [
    ReportEntry(employeeId: 'NV006', name: 'Ngô Mai Anh', invoiceCount: 16, revenue: 3100000, customerCount: 18, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV007', name: 'Đỗ Trung Kiên', invoiceCount: 7, revenue: 1200000, customerCount: 7, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '28/05/2025': [
    ReportEntry(employeeId: 'NV008', name: 'Hoàng Ngọc Bích', invoiceCount: 18, revenue: 3300000, customerCount: 20, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV001', name: 'Nguyễn Hoàng Long', invoiceCount: 6, revenue: 950000, customerCount: 6, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '27/05/2025': [
    ReportEntry(employeeId: 'NV002', name: 'Trần Thu Hà', invoiceCount: 11, revenue: 1950000, customerCount: 12, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV004', name: 'Lê Minh Tuấn', invoiceCount: 10, revenue: 1800000, customerCount: 11, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '26/05/2025': [
    ReportEntry(employeeId: 'NV005', name: 'Phạm Hải Nam', invoiceCount: 13, revenue: 2400000, customerCount: 14, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV006', name: 'Ngô Mai Anh', invoiceCount: 5, revenue: 870000, customerCount: 5, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '25/05/2025': [
    ReportEntry(employeeId: 'NV007', name: 'Đỗ Trung Kiên', invoiceCount: 9, revenue: 1600000, customerCount: 10, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV008', name: 'Hoàng Ngọc Bích', invoiceCount: 8, revenue: 1500000, customerCount: 9, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '24/05/2025': [
    ReportEntry(employeeId: 'NV001', name: 'Nguyễn Hoàng Long', invoiceCount: 15, revenue: 2800000, customerCount: 17, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV002', name: 'Trần Thu Hà', invoiceCount: 10, revenue: 1900000, customerCount: 11, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '23/05/2025': [
    ReportEntry(employeeId: 'NV004', name: 'Lê Minh Tuấn', invoiceCount: 12, revenue: 2200000, customerCount: 13, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV005', name: 'Phạm Hải Nam', invoiceCount: 7, revenue: 1300000, customerCount: 8, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
  '22/05/2025': [
    ReportEntry(employeeId: 'NV006', name: 'Ngô Mai Anh', invoiceCount: 14, revenue: 2500000, customerCount: 15, shiftStart: '08:00', shiftEnd: '12:00'),
    ReportEntry(employeeId: 'NV007', name: 'Đỗ Trung Kiên', invoiceCount: 6, revenue: 980000, customerCount: 6, shiftStart: '12:00', shiftEnd: '16:00'),
  ],
};

