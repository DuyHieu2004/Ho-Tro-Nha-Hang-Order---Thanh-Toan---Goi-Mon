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
      'monAn': _monAn?.toMap(), // Chuyển đổi MonAn thành Map
      'soLuong': _soLuong,
      'maDonGoiMon': _donGoiMon?.toMap(), // Chuyển đổi DonGoiMon thành Map
    };
  }

  // fromMap constructor
  ChiTietGoiMon.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString();
    _monAn = map['monAn'] != null ? MonAn.fromMap(map['monAn'] as Map<String, dynamic>) : null; // Chuyển đổi Map thành MonAn
    _soLuong = map['soLuong'] as int?;
    _donGoiMon = map['maDonGoiMon'] != null ? DonGoiMon.fromMap(map['maDonGoiMon'] as Map<String, dynamic>) : null;
  }

  // Getters
  get getMa => _ma;
  get getMonAn => _monAn;
  get getSoLuong => _soLuong;
  get getMaDonGoiMon => _donGoiMon;
  get tinhTien => (_monAn?.getGiaBan ?? 0) * (_soLuong ?? 0); // Đảm bảo xử lý null an toàn

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