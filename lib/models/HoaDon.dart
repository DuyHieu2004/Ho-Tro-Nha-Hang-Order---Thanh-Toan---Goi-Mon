// import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
// import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class HoaDon {
//   String? _ma;
//   NhanVien? _nhanVien;
//   DateTime? _ngayThanhToan;
//   double? _tongTien;
//   DonGoiMon? _DGM;
//
//   // Constructors
//   HoaDon({
//     String? ma,
//     NhanVien? nhanVien,
//     DateTime? ngayThanhToan,
//     double? tongTien,
//     DonGoiMon? maDGM,
//   }) {
//     _ma = ma ?? '';
//     _nhanVien = nhanVien;
//     _ngayThanhToan = ngayThanhToan ?? DateTime.now();
//     _tongTien = tongTien ?? 0;
//     _DGM = maDGM ?? DonGoiMon();
//   }
//
//   // fromMap contructor
//   HoaDon.fromMap(Map<String, dynamic> map) {
//     _ma = map['ma']?.toString() ?? '';
//     _nhanVien = map['maNhanVien'] != null
//         ? NhanVien.fromMap(map['maNhanVien'])
//         : null;
//     _ngayThanhToan = map['ngayThanhToan'] != null
//         ? DateTime.parse(map['ngayThanhToan'].toString())
//         : null;
//     _tongTien = (map['tongTien'] as num?)?.toDouble() ?? 0;
//     _DGM = map['MaDGM'] != null ? DonGoiMon.fromMap(map['MaDGM']) : null;
//   }
//
//   // toMap method
//   Map<String, dynamic> toMap() {
//     return {
//       'ma': _ma,
//       'maNhanVien': _nhanVien?.toMap(),
//       'ngayThanhToan': _ngayThanhToan?.toIso8601String(),
//       'tongTien': _tongTien,
//       'MaDGM': _DGM?.toMap(),
//     };
//   }
//
//   // Getters
//   String? get ma => _ma;
//   NhanVien? get nhanVien => _nhanVien;
//   DateTime? get ngayThanhToan => _ngayThanhToan;
//   double? get tongTien => _tongTien;
//   DonGoiMon? get donGoiMon => _DGM;
//
//   // Setters
//   set ma(String? ma) {
//     if (ma != null && ma.isNotEmpty) {
//       _ma = ma;
//     }
//   }
//
//   set nhanVien(NhanVien? nhanVien) {
//     if (nhanVien != null) {
//       _nhanVien = nhanVien;
//     }
//   }
//
//   set ngayThanhToan(DateTime? ngayThanhToan) {
//     if (ngayThanhToan != null) {
//       _ngayThanhToan = ngayThanhToan;
//     }
//   }
//
//   set tongTien(double? tongTien) {
//     if (tongTien != null && tongTien >= 0) {
//       _tongTien = tongTien;
//     }
//   }
//
//   set donGoiMon(DonGoiMon? maDGM) {
//     if (maDGM != null) {
//       _DGM = maDGM;
//     }
//   }
// }


import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart'; // Đảm bảo import đúng đường dẫn
import 'package:doan_nhom_cuoiky/models/NhanVien.dart'; // Đảm bảo import đúng đường dẫn
import 'package:cloud_firestore/cloud_firestore.dart'; // Rất quan trọng: import Firestore Timestamp

class HoaDon {
  String? _ma;
  NhanVien? _nhanVien;
  DateTime? _ngayThanhToan;
  double? _tongTien;
  DonGoiMon? _DGM;

  // Constructors
  HoaDon({
    String? ma,
    NhanVien? nhanVien,
    DateTime? ngayThanhToan,
    double? tongTien,
    DonGoiMon? maDGM,
  }) {
    _ma = ma ?? '';
    _nhanVien = nhanVien;
    _ngayThanhToan = ngayThanhToan ?? DateTime.now();
    _tongTien = tongTien ?? 0;
    _DGM = maDGM ?? DonGoiMon();
  }

  // fromMap constructor
  HoaDon.fromMap(Map<String, dynamic> map) {
    _ma = map['ma']?.toString() ?? '';
    _nhanVien = map['maNhanVien'] != null
        ? NhanVien.fromMap(map['maNhanVien'])
        : null;
    // SỬA ĐỔI QUAN TRỌNG: Chuyển đổi Firestore Timestamp sang DateTime
    _ngayThanhToan = (map['ngayThanhToan'] as Timestamp?)?.toDate();
    _tongTien = (map['tongTien'] as num?)?.toDouble() ?? 0;
    _DGM = map['MaDGM'] != null ? DonGoiMon.fromMap(map['MaDGM']) : null;
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'maNhanVien': _nhanVien?.toMap(),
      // SỬA ĐỔI QUAN TRỌNG: Chuyển đổi DateTime sang Firestore Timestamp khi lưu
      'ngayThanhToan': _ngayThanhToan != null ? Timestamp.fromDate(_ngayThanhToan!) : null,
      'tongTien': _tongTien,
      'MaDGM': _DGM?.toMap(),
    };
  }

  // Getters
  String? get ma => _ma;
  NhanVien? get nhanVien => _nhanVien;
  DateTime? get ngayThanhToan => _ngayThanhToan;
  double? get tongTien => _tongTien;
  DonGoiMon? get donGoiMon => _DGM;

  // Setters
  set ma(String? ma) {
    if (ma != null && ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set nhanVien(NhanVien? nhanVien) {
    if (nhanVien != null) {
      _nhanVien = nhanVien;
    }
  }

  set ngayThanhToan(DateTime? ngayThanhToan) {
    if (ngayThanhToan != null) {
      _ngayThanhToan = ngayThanhToan;
    }
  }

  set tongTien(double? tongTien) {
    if (tongTien != null && tongTien >= 0) {
      _tongTien = tongTien;
    }
  }

  set donGoiMon(DonGoiMon? maDGM) {
    if (maDGM != null) {
      _DGM = maDGM;
    }
  }
}