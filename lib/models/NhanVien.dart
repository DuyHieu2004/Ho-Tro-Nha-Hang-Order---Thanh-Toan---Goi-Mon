import 'package:cloud_firestore/cloud_firestore.dart';

class NhanVien {
  String? id;
  String? _ma;
  String? _ten;
  String? _SDT;
  String? _CCCD;
  String? _tk;
  String? _mk;
  String? _vaiTro;
  String? _anh;
  Timestamp? ngayVL;

  // Constructors
  NhanVien({
    this.id,
    String? ma,
    String? ten,
    String? SDT,
    String? CCCD,
    String? tk,
    String? mk,
    String? vaiTro,
    String? anh,
    this.ngayVL,
  })  : _ma = ma,
        _ten = ten,
        _SDT = SDT,
        _CCCD = CCCD,
        _tk = tk,
        _mk = mk,
        _vaiTro = vaiTro,
        _anh = anh;

  // fromMap constructor
  NhanVien.fromMap(Map<String, dynamic> map, String id) {
    this.id = id;
    _ma = map['Ma'] as String?;
    _ten = map['Ten'] as String?;
    _SDT = map['SDT'] as String?;
    _CCCD = map['CCCD'] as String?;
    _tk = map['TaiKhoan'] as String?;
    _mk = map['MatKhau'] as String?;
    _vaiTro = map['VaiTro'] as String?;
    _anh = map['Anh'] as String?;
    ngayVL = map['NgayVL'] as Timestamp?;
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'Ma': _ma,
      'Ten': _ten,
      'Anh': _anh,
      'CCCD': _CCCD,
      'VaiTro': _vaiTro,
      'MatKhau': _mk,
      'SDT': _SDT,
      'TaiKhoan': _tk,
      'NgayVL': ngayVL,
    };
  }

  bool get isQuanLy => _vaiTro == 'QL';

  // Getters
  String? get ma => _ma;
  String? get ten => _ten;
  String? get SDT => _SDT;
  String? get CCCD => _CCCD;
  String? get tk => _tk;
  String? get mk => _mk;
  String? get vaiTro => _vaiTro;
  String? get anh => _anh;

  // Setters
  set ma(String? ma) => _ma = ma;
  set ten(String? ten) => _ten = ten;
  set SDT(String? SDT) => _SDT = SDT;
  set CCCD(String? CCCD) => _CCCD = CCCD;
  set tk(String? tk) => _tk = tk;
  set mk(String? mk) => _mk = mk;
  set vaiTro(String? vaiTro) => _vaiTro = vaiTro;
  set anh(String? anh) => _anh = anh;
}