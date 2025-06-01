import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import CloudFirestore để dùng Timestamp

class DonGoiMon {
  String? _ma;
  DateTime? _ngayLap;
  String? _trangThai;
  String? _ghiChu;
  Ban? _maBan;
  DateTime? _ngayGioDenDuKien; // Thêm trường này nếu bạn đã thêm nó vào model

  // Constructors
  DonGoiMon({
    String? ma,
    DateTime? ngayLap,
    String? trangThai,
    String? ghiChu,
    Ban? maBan,
    DateTime? ngayGioDenDuKien, // Thêm vào constructor nếu bạn đã thêm nó vào model
  }) {
    _ma = ma ?? '';
    _ngayLap = ngayLap ?? DateTime.now();
    _trangThai = trangThai ?? "Chờ";
    _ghiChu = ghiChu ?? "";
    _maBan = maBan ?? Ban();
    _ngayGioDenDuKien = ngayGioDenDuKien; // Gán giá trị
  }

  // fromMap contructor: Đảm bảo đọc từ các key PascalCase và xử lý Timestamp
  DonGoiMon.fromMap(Map<String, dynamic> map) {
    _ma = map['Ma']?.toString(); // Sửa từ 'ma' -> 'Ma'
    _ngayLap = (map['NgayLap'] as Timestamp?)?.toDate(); // Sửa từ DateTime.parse -> Timestamp
    _trangThai = map['TrangThai']?.toString(); // Sửa từ 'trangThai' -> 'TrangThai'
    _ghiChu = map['GhiChu']?.toString(); // Sửa từ 'ghiChu' -> 'GhiChu'
    _maBan = map['MaBan'] != null ? Ban.fromMap(map['MaBan'] as Map<String, dynamic>) : null; // Sửa từ 'maBan' -> 'MaBan'
    _ngayGioDenDuKien = (map['NgayGioDenDuKien'] as Timestamp?)?.toDate(); // Đọc từ NgayGioDenDuKien
  }

  // toMap method: Đảm bảo ghi với các key PascalCase và xử lý Timestamp
  Map<String, dynamic> toMap() {
    return {
      'Ma': _ma,
      'NgayLap': _ngayLap != null ? Timestamp.fromDate(_ngayLap!) : null, // Chuyển DateTime -> Timestamp
      'TrangThai': _trangThai,
      'GhiChu': _ghiChu,
      'MaBan': _maBan?.toMap(),
      'NgayGioDenDuKien': _ngayGioDenDuKien != null ? Timestamp.fromDate(_ngayGioDenDuKien!) : null, // Ghi NgayGioDenDuKien
    };
  }

  // Getters (đã thêm getter cho _ngayGioDenDuKien nếu có)
  String? get ma => _ma;
  DateTime? get ngayLap => _ngayLap;
  String? get trangThai => _trangThai;
  String? get ghiChu => _ghiChu;
  Ban? get maBan => _maBan;
  DateTime? get ngayGioDenDuKien => _ngayGioDenDuKien; // Thêm getter

  // Setters (giữ nguyên, chúng hoạt động với các trường _ma, v.v.)
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

  set ngayGioDenDuKien(DateTime? value) {
    _ngayGioDenDuKien = value;
  }
}