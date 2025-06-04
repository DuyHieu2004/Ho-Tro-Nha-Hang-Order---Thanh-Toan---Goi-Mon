class KhachHang{
  String? maKhachHang;
  String? tenKhachHang;
  String? soDienThoai;
  String? email;

  KhachHang({
    this.maKhachHang,
    this.tenKhachHang,
    this.soDienThoai,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'maKhachHang': maKhachHang,
      'tenKhachHang': tenKhachHang,
      'soDienThoai': soDienThoai,
      'email': email,
    };
  }

  factory KhachHang.fromMap(Map<String, dynamic> map) {
    return KhachHang(
      maKhachHang: map['maKhachHang'],
      tenKhachHang: map['tenKhachHang'],
      soDienThoai: map['soDienThoai'],
      email: map['email'],
    );
  }
}