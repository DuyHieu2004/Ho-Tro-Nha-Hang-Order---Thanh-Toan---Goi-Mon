class Ban {
  String? _ma;
  String? _viTri;
  int? _sucChua;
  String? _trangThai;

  // Constructors
  Ban({String? ma, String? viTri, int? sucChua, String? trangThai}) {
    _ma = ma ?? '';
    _viTri = viTri ?? '';
    _sucChua = sucChua ?? 1;
    _trangThai = trangThai ?? "Trống";
  }

  // fromMap constructor
  Ban.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString();
    _viTri = map['viTri']?.toString();
    _sucChua = map['sucChua'] as int?;
    _trangThai = map['trangThai']?.toString();
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'viTri': _viTri,
      'sucChua': _sucChua,
      'trangThai': _trangThai,
    };
  }

  // Getters
  String? get ma => _ma;
  String? get viTri => _viTri;
  int? get sucChua => _sucChua;
  String? get trangThai => _trangThai;

  // Setters
  set ma(String? ma) {
    if (ma != null && ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set viTri(String? viTri) {
    if (viTri != null) {
      _viTri = viTri;
    }
  }

  set sucChua(int? sucChua) {
    if (sucChua != null && sucChua >= 1) {
      _sucChua = sucChua;
    }
  }

  set trangThai(String? trangThai) {
    if (trangThai != null &&
        (trangThai == "Đang phục vụ" ||
            trangThai == "Trống" ||
            trangThai == "Đã đặt")) {
      _trangThai = trangThai;
    }
  }
}