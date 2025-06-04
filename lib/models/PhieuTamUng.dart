class PhieuTamUng{
  String? ma;
  String? maPhieuTamUng;
  String? soTien;
  DateTime? ngayLap;

  PhieuTamUng({
    this.ma,
    this.maPhieuTamUng,
    this.soTien,
    this.ngayLap,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': ma,
      'maPhieuTamUng': maPhieuTamUng,
      'soTien': soTien,
      'ngayLap': ngayLap?.toIso8601String(),
    };
  }

  factory PhieuTamUng.fromMap(Map<String, dynamic> map) {
    return PhieuTamUng(
      ma: map['ma'],
      maPhieuTamUng: map['maPhieuTamUng'],
      soTien: map['soTien'],
      ngayLap: DateTime.tryParse(map['ngayLap'] ?? ''),
    );
  }
}