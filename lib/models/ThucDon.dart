class ThucDon {
  String? _ma;
  String? _ten;

  // Constructors
  ThucDon({String? ma, String? ten}) {
    _ma = ma;
    _ten = ten;
  }

  // fromMap contructor
  ThucDon.fromMap(Map<String, dynamic> map) {
    _ma = map['ma'];
    _ten = map['ten'];
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {'ma': _ma, 'ten': _ten};
  }
  
  // Getters
  get getMa => _ma;
  get getTen => _ten;

  // Setters
  set ma(String ma) {
    if (ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set ten(String ten) {
    if (ten.isNotEmpty) {
      _ten = ten;
    }
  }
}
