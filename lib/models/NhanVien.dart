import 'package:cloud_firestore/cloud_firestore.dart';

class NhanVien {
  final String id;
  final String ma;
  final String ten;
  final String anh;
  final String cccd;
  final String vaiTro;
  final String matKhau;
  final String sdt;
  final String taiKhoan;
  final Timestamp? ngayVL; // Thay đổi kiểu dữ liệu thành Timestamp? (cho phép null)

  NhanVien({
    required this.id,
    required this.ma,
    required this.ten,
    required this.anh,
    required this.cccd,
    required this.vaiTro,
    required this.matKhau,
    required this.sdt,
    required this.taiKhoan,
    this.ngayVL, // Cập nhật constructor
  });

  factory NhanVien.fromMap(Map<String, dynamic> map, String id) {
    return NhanVien(
      id: id,
      ma: map['Ma'] ?? '',
      ten: map['Ten'] ?? '',
      anh: map['Anh'] ?? '',
      cccd: map['CCCD'] ?? '',
      vaiTro: map['VaiTro'] ?? '',
      matKhau: map['MatKhau'] ?? '',
      sdt: map['SDT'] ?? '',
      taiKhoan: map['TaiKhoan'] ?? '',
      ngayVL: map['NgayVL'] as Timestamp?, // Ép kiểu về Timestamp?
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Ma': ma,
      'Ten': ten,
      'Anh': anh,
      'CCCD': cccd,
      'VaiTro': vaiTro,
      'MatKhau': matKhau,
      'SDT': sdt,
      'TaiKhoan': taiKhoan,
      'NgayVL': ngayVL, // Lưu Timestamp trực tiếp
    };
  }

  bool get isQuanLy => vaiTro == 'QL';
}