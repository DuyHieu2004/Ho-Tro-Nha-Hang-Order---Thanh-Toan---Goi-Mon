class DonDatCho {
  String? ma;
  String? tenKhachHang;
  String? soDienThoai;
  DateTime? ngayDat;
  String? ghiChu;
  String? maKhachHang;
  String? maPhieuTamUng;
  String? maDonGoiMon;

  DonDatCho({
    this.ma,
    this.tenKhachHang,
    this.soDienThoai,
    this.ngayDat,
    this.ghiChu,
    this.maKhachHang,
    this.maPhieuTamUng,
    this.maDonGoiMon,
  });

  Map<String, dynamic> toMap() {
    return {
      'ma': ma,
      'tenKhachHang': tenKhachHang,
      'soDienThoai': soDienThoai,
      'ngayDat': ngayDat,
      'ghiChu': ghiChu,
      'maKhachHang': maKhachHang,
      'maPhieuTamUng': maPhieuTamUng,
    };
  }

  factory DonDatCho.fromMap(Map<String, dynamic> map) {
    return DonDatCho(
      ma: map['ma'],
      tenKhachHang: map['tenKhachHang'],
      soDienThoai: map['soDienThoai'],
      ngayDat: DateTime.tryParse(map['ngayDat'] ?? ''),
      ghiChu: map['ghiChu'],
      maKhachHang: map['maKhachHang'],
      maPhieuTamUng: map['maPhieuTamUng'],
      maDonGoiMon: map['maDonGoiMon'],
    );
  }
}