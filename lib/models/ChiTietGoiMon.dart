import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';

class ChiTietGoiMon {
  String? _ma;
  MonAn? _monAn;
  int? _soLuong;
  DonGoiMon? _donGoiMon;

  // Constructors
  ChiTietGoiMon({
    String? ma,
    MonAn? monAn,
    int? soLuong,
    DonGoiMon? maDonGoiMon,
  })
  {
    _ma = ma;
    _monAn = monAn;
    _soLuong = soLuong;
    _donGoiMon = maDonGoiMon;
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'monAn': _monAn,
      'soLuong': _soLuong,
      'maDonGoiMon': _donGoiMon?.toMap(),
    };
  }

  // fromMap constructor
  ChiTietGoiMon.fromMap(Map<String, dynamic> map) {
    _ma = map['ma'];
    _monAn = map['monAn'];
    _soLuong = map['soLuong'];
    _donGoiMon = map['maDonGoiMon'] != null ? DonGoiMon.fromMap(map['maDonGoiMon']) : null;
  }

  // Getters
  get getMa => _ma;
  get getMonAn => _monAn;
  get getSoLuong => _soLuong;
  get getMaDonGoiMon => _donGoiMon;
  get tinhTien => _monAn?.getGiaBan() * _soLuong;

  // Setters
  set ma(String ma) {
    if (ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set monAn(MonAn monAn) {
    _monAn = monAn;
  }

  set soLuong(int soLuong) {
    _soLuong = soLuong;
  }

  set maDonGoiMon(DonGoiMon maDonGoiMon) {
    _donGoiMon = maDonGoiMon;
  }
}