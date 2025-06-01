import 'package:doan_nhom_cuoiky/models/HoaDon.dart';
import 'package:doan_nhom_cuoiky/models/QuyDinhNhaHang.dart';

class ChiTietViPham {
  String? _ma;
  HoaDon? _hoaDon;
  QuyDinhNhaHang? _maVP;

  // Constructors
  ChiTietViPham({String? ma, HoaDon? hoaDon, QuyDinhNhaHang? maVP}) {
    _ma = ma ?? '';
    _hoaDon = hoaDon;
    _maVP = maVP;
  }

  // fromMap constructor
  ChiTietViPham.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString();
    _hoaDon = map['maHoaDon'] != null ? HoaDon.fromMap(map['maHoaDon']) : null;
    _maVP = map['maQuyDinhNhaHang'] != null ? QuyDinhNhaHang.fromMap(map['maQuyDinhNhaHang']) : null;
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'maHoaDon': _hoaDon?.toMap(),
      'maQuyDinhNhaHang': _maVP?.toMap(),
    };
  }

  // Getters
  String? get ma => _ma;
  HoaDon? get hoaDon => _hoaDon;
  QuyDinhNhaHang? get maVP => _maVP;

  // Setters
  set ma(String? ma) {
    if (ma != null && ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set hoaDon(HoaDon? hoaDon) {
    if (hoaDon != null) {
      _hoaDon = hoaDon;
    }
  }

  set maVP(QuyDinhNhaHang? maVP) {
    if (maVP != null) {
      _maVP = maVP;
    }
  }
}