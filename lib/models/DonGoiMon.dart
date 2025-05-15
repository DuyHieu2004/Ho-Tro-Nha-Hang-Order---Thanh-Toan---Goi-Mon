import 'package:doan_nhom_cuoiky/models/Ban.dart';

class DonGoiMon {
  String? _ma;
  DateTime? _ngayLap;
  String? _trangThai;
  String? _ghiChu;
  Ban? _maBan;

  // Constructors
  DonGoiMon({
    String? ma,
    DateTime? ngayLap,
    String? trangThai,
    String? ghiChu,
    Ban? maBan,
  }) {
    _ma = ma ?? '';
    _ngayLap = ngayLap ?? DateTime.now();
    _trangThai = trangThai ?? "Chờ";
    _ghiChu = ghiChu ?? "";
    _maBan = maBan ?? Ban();
  }

  // fromMap contructor
  DonGoiMon.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString();
    _ngayLap = map['ngayLap'] != null ? DateTime.parse(map['ngayLap']) : null;
    _trangThai = map['trangThai']?.toString();
    _ghiChu = map['ghiChu']?.toString();
    _maBan = map['maBan'] != null ? Ban.fromMap(map['maBan']) : null;
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'ngayLap': _ngayLap?.toIso8601String(),
      'trangThai': _trangThai,
      'ghiChu': _ghiChu,
      'maBan': _maBan?.toMap(),
    };
  }

  // Getters
  String? get ma => _ma;
  DateTime? get ngayLap => _ngayLap;
  String? get trangThai => _trangThai;
  String? get ghiChu => _ghiChu;
  Ban? get maBan => _maBan;

  // Setters
  set ma(String? ma) {
    if (ma != null && ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set ngayLap(DateTime? ngayLap) {
    if (ngayLap != null) {
      _ngayLap = ngayLap;
    }
  }

  set trangThai(String? trangThai) {
    if (trangThai != null && trangThai.isNotEmpty) {
      _trangThai = trangThai;
    }
  }

  set ghiChu(String? ghiChu) {
    if (ghiChu != null) {
      _ghiChu = ghiChu;
    }
  }

  set maBan(Ban? maBan) {
    if (maBan != null) {
      _maBan = maBan;
    }
  }
}