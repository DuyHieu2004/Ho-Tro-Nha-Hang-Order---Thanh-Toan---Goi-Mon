class Employee {
  final String name;
  final DateTime workingDate;
  final bool isChecked;

  Employee({
    required this.name,
    required this.workingDate,
    this.isChecked = false,
  });
}

final List<Employee> employeeList = [
  Employee(name: 'Nguyễn Hoàng Long', workingDate: DateTime(2025, 3, 12)),
  Employee(name: 'Trần Thu Hà', workingDate: DateTime(2025, 4, 5)),
  Employee(name: 'Lê Minh Tuấn', workingDate: DateTime(2025, 3, 25)),
  Employee(name: 'Phạm Hải Nam', workingDate: DateTime(2025, 4, 20)),
  Employee(name: 'Ngô Mai Anh', workingDate: DateTime(2025, 5, 3)),
  Employee(name: 'Đỗ Trung Kiên', workingDate: DateTime(2025, 3, 30)),
  Employee(name: 'Hoàng Ngọc Bích', workingDate: DateTime(2025, 4, 28)),
  Employee(name: 'Đỗ Hoàng Uyên', workingDate: DateTime.now()), // mới vào hôm nay
];
