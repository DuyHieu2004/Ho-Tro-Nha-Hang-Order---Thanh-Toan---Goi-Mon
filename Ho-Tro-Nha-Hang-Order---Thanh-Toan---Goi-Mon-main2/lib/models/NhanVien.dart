import 'package:cloud_firestore/cloud_firestore.dart';

import 'VaiTro.dart';

class NhanVien {
  String? id;
  String? _ma;
  String? _ten;
  String? _SDT;
  String? _CCCD;
  String? _tk;
  String? _mk;
  VaiTro? _vaiTro;
  String? _anh;
  Timestamp? ngayVL;

  // Constructors
  NhanVien({
    this.id,
    required String? ma,
    required String? ten,
    String? SDT,
    String? CCCD, 
    required String? tk,
    required String? mk,
    VaiTro? vaiTro, 
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
  NhanVien.fromMap(Map<String, dynamic> map) {
    id = map['Id']?.toString();
    _ma = map['Ma']?.toString(); 
    _ten = map['Ten']?.toString(); 
    _SDT = map['SDT']?.toString(); 
    _CCCD = map['CCCD']?.toString(); 
    _tk = map['TaiKhoan']?.toString(); 
    _mk = map['MatKhau']?.toString(); 
    _vaiTro = map['VaiTro'] != null ? VaiTro.fromMap(map['VaiTro'] as Map<String, dynamic>) : null; 
    _anh = map['Anh']?.toString(); 
    ngayVL = map['NgayVL'] as Timestamp?; 
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'Id': id, 
      'Ma': _ma,
      'Ten': _ten,
      'SDT': _SDT,
      'CCCD': _CCCD,
      'TaiKhoan': _tk, 
      'MatKhau': _mk, 
      'VaiTro': _vaiTro?.toMap(), 
      'Anh': _anh,
      'NgayVL': ngayVL,
    };
  }

  bool get isQuanLy => _vaiTro?.ten == 'Quản lý';

  // Getters
  String? get ma => _ma;
  String? get ten => _ten;
  String? get SDT => _SDT;
  String? get CCCD => _CCCD;
  String? get tk => _tk;
  String? get mk => _mk;
  VaiTro? get vaiTro => _vaiTro;
  String? get anh => _anh;

  // Setters 
  set ma(String? value) => _ma = value;
  set ten(String? value) => _ten = value;
  set SDT(String? value) => _SDT = value;
  set CCCD(String? value) => _CCCD = value;
  set tk(String? value) => _tk = value;
  set mk(String? value) => _mk = value;
  set vaiTro(VaiTro? value) => _vaiTro = value;
  set anh(String? value) => _anh = value;
}