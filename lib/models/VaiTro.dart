class VaiTro {
  String? _ma;
  String? _ten;

  // Constructors
  VaiTro({String? ma, String? ten}) {
    _ma = ma;
    _ten = ten;
  }

  VaiTro.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString();
    _ten = map['ten']?.toString();
  }

  // Factory method to create VaiTro from String (e.g., from dropdown)
  factory VaiTro.fromString(String ten) {
    switch (ten) {
      case 'Quản lý':
        return VaiTro(ma: 'QL', ten: 'Quản lý');
      case 'Thu ngân':
        return VaiTro(ma: 'TN', ten: 'Thu ngân');
      case 'Phục vụ':
        return VaiTro(ma: 'PV', ten: 'Phục vụ');
      default:
        return VaiTro(ma: 'PV', ten: 'Phục vụ'); // Mặc định là Phục vụ
    }
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {'ma': _ma, 'ten': _ten};
  }

  // Getters
  String? get ma => _ma;
  String? get ten => _ten;

  // Setters
  set ma(String? ma) {
    if (ma != null && ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set ten(String? ten) {
    if (ten != null && ten.isNotEmpty) {
      _ten = ten;
    }
  }

  @override
  String toString() => _ten ?? 'Phục vụ';
}