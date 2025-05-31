class ReportEntry {
  final String name;
  final int invoiceCount;
  final double revenue;
  final int customerCount; // Số khách hàng phục vụ

  ReportEntry({
    required this.name,
    required this.invoiceCount,
    required this.revenue,
    required this.customerCount,
  });
}

final Map<String, List<ReportEntry>> mockReportData = {
  '31/05/2025': [
    ReportEntry(name: 'Nguyễn Hoàng Long', invoiceCount: 7, revenue: 1750000, customerCount: 10),
    ReportEntry(name: 'Trần Thu Hà', invoiceCount: 5, revenue: 570000, customerCount: 7),
    ReportEntry(name: 'Đỗ Hoàng Uyên', invoiceCount: 2, revenue: 170000, customerCount: 2),
  ],
  '30/05/2025': [
    ReportEntry(name: 'Lê Minh Tuấn', invoiceCount: 14, revenue: 2600000, customerCount: 15),
    ReportEntry(name: 'Phạm Hải Nam', invoiceCount: 8, revenue: 1500000, customerCount: 9),
  ],
  '29/05/2025': [
    ReportEntry(name: 'Ngô Mai Anh', invoiceCount: 16, revenue: 3100000, customerCount: 18),
    ReportEntry(name: 'Đỗ Trung Kiên', invoiceCount: 7, revenue: 1200000, customerCount: 7),
  ],
  '28/05/2025': [
    ReportEntry(name: 'Hoàng Ngọc Bích', invoiceCount: 18, revenue: 3300000, customerCount: 20),
    ReportEntry(name: 'Nguyễn Hoàng Long', invoiceCount: 6, revenue: 950000, customerCount: 6),
  ],
  '27/05/2025': [
    ReportEntry(name: 'Trần Thu Hà', invoiceCount: 11, revenue: 1950000, customerCount: 12),
    ReportEntry(name: 'Lê Minh Tuấn', invoiceCount: 10, revenue: 1800000, customerCount: 11),
  ],
  '26/05/2025': [
    ReportEntry(name: 'Phạm Hải Nam', invoiceCount: 13, revenue: 2400000, customerCount: 14),
    ReportEntry(name: 'Ngô Mai Anh', invoiceCount: 5, revenue: 870000, customerCount: 5),
  ],
  '25/05/2025': [
    ReportEntry(name: 'Đỗ Trung Kiên', invoiceCount: 9, revenue: 1600000, customerCount: 10),
    ReportEntry(name: 'Hoàng Ngọc Bích', invoiceCount: 8, revenue: 1500000, customerCount: 9),
  ],
  '24/05/2025': [
    ReportEntry(name: 'Nguyễn Hoàng Long', invoiceCount: 15, revenue: 2800000, customerCount: 17),
    ReportEntry(name: 'Trần Thu Hà', invoiceCount: 10, revenue: 1900000, customerCount: 11),
  ],
  '23/05/2025': [
    ReportEntry(name: 'Lê Minh Tuấn', invoiceCount: 12, revenue: 2200000, customerCount: 13),
    ReportEntry(name: 'Phạm Hải Nam', invoiceCount: 7, revenue: 1300000, customerCount: 8),
  ],
  '22/05/2025': [
    ReportEntry(name: 'Ngô Mai Anh', invoiceCount: 14, revenue: 2500000, customerCount: 15),
    ReportEntry(name: 'Đỗ Trung Kiên', invoiceCount: 6, revenue: 980000, customerCount: 6),
  ],
};
