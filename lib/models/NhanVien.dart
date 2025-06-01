import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/VaiTro.dart';

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
    required String? id,
    required String? ma,
    required String? ten,
    required String? SDT,
    required String? CCCD,
    required String? tk,
    required String? mk,
    required VaiTro? vaiTro,
    required String? anh,
    this.ngayVL
  }) : _ma = ma,
       _ten = ten,
       _SDT = SDT,
       _CCCD = CCCD,
       _tk = tk,
       _mk = mk,
       _vaiTro = vaiTro,
       _anh = anh;

  // fromMap constructor
  NhanVien.fromMap(Map<String, dynamic> map) {
    _ma = map['ma'];
    _ten = map['ten'];
    _SDT = map['SDT'];
    _CCCD = map['CCCD'];
    _tk = map['tk'];
    _mk = map['mk'];
    _vaiTro = map['vaiTro'] != null ? VaiTro.fromMap(map['vaiTro']) : null;
    _anh = map['anh'];
    ngayVL: map['NgayVL'] as Timestamp?;
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'Ma': ma,
      'Ten': ten,
      'Anh': anh,
      'CCCD': CCCD,
      'VaiTro': vaiTro,
      'MatKhau': mk,
      'SDT': SDT,
      'TaiKhoan': tk,
      'NgayVL': ngayVL,
    };
  }

  bool get isQuanLy => vaiTro == 'QL';

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

  set SDT(String? SDT) {
    if (SDT != null && SDT.isNotEmpty) {
      _SDT = SDT;
    }
  }

  set CCCD(String? CCCD) {
    if (CCCD != null && CCCD.isNotEmpty) {
      _CCCD = CCCD;
    }
  }

  set tk(String? tk) {
    if (tk != null && tk.isNotEmpty) {
      _tk = tk;
    }
  }

  set mk(String? mk) {
    if (mk != null && mk.isNotEmpty) {
      _mk = mk;
    }
  }

  set vaiTro(VaiTro? vaiTro) {
    if (vaiTro != null) {
      _vaiTro = vaiTro;
    }
  }

  set anh(String? anh) {
    if (anh != null && anh.isNotEmpty) {
      _anh = anh;
    }
  }
}