class QuyDinhNhaHang {
  String? _ma;
  String? _tenViPham;
  double? _tienPhat;

  // Constructors
  QuyDinhNhaHang(String ma, String ten, double tien) {
    _ma = ma;
    _tenViPham = ten;
    _tienPhat = tien;
  }

  QuyDinhNhaHang.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString();
    _tenViPham = map['TenViPham']?.toString();
    _tienPhat = (map['tienPhat'] as num?)?.toDouble();
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'TenViPham': _tenViPham,
      'tienPhat': _tienPhat,
    };
  }

  // Getters
  String? get ma => _ma;
  String? get tenViPham => _tenViPham;
  double? get tienPhat => _tienPhat;

  // Setters
  set ma(String? ma) {
    if (ma != null && ma.isNotEmpty) {
      _ma = ma;
    } else {
      _ma = null;
    }
  }

  set tenViPham(String? ten) {
    if (ten != null && ten.isNotEmpty) {
      _tenViPham = ten;
    } else {
      _tenViPham = null;
    }
  }

  set tienPhat(double? tien) {
    if (tien != null && tien > 0) {
      _tienPhat = tien;
    } else {
      throw Exception('Tiền phải lớn hơn 0');
    }
  }
}