import 'ThucDon.dart';

class MonAn{
  String? _ma;
  String? _ten;
  double? _giaBan;
  String? _tinhTrang;
  ThucDon? _thucDon;
  String? _hinhAnh;

  MonAn(this._ma, this._ten, this._giaBan, this._tinhTrang, this._thucDon, this._hinhAnh);

  // toMap method: Chuyển đổi đối tượng MonAn thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'Ma': _ma,         // Đổi từ 'ma' -> 'Ma'
      'Ten': _ten,       // Đổi từ 'ten' -> 'Ten'
      'GiaBan': _giaBan, // Đổi từ 'giaBan' -> 'GiaBan'
      'TinhTrang': _tinhTrang, // Đổi từ 'tinhTrang' -> 'TinhTrang'
      'ThucDon': _thucDon?.toMap(), // Chuyển đổi ThucDon thành Map
      'HinhAnh': _hinhAnh, // Đổi từ 'hinhAnh' -> 'HinhAnh'
    };
  }

  // fromMap constructor: Tạo đối tượng MonAn từ Map đọc từ Firestore
  MonAn.fromMap(Map<String, dynamic> map) {
    _ma = map['Ma']?.toString(); // Đổi từ 'ma' -> 'Ma'
    _ten = map['Ten']?.toString(); // Đổi từ 'ten' -> 'Ten'
    _giaBan = (map['GiaBan'] as num?)?.toDouble(); // Đổi từ 'giaBan' -> 'GiaBan'
    _tinhTrang = map['TinhTrang']?.toString(); // Đổi từ 'tinhTrang' -> 'TinhTrang'
    _thucDon = map['ThucDon'] != null ? ThucDon.fromMap(map['ThucDon'] as Map<String, dynamic>) : null;
    _hinhAnh = map['HinhAnh']?.toString(); // Đổi từ 'hinhAnh' -> 'HinhAnh'
  }

  // Getters
  get getMa => _ma;
  get getTen => _ten;
  get getGiaBan => _giaBan;
  get getTinhTrang => _tinhTrang;
  get getThucDon => _thucDon;
  get getHinhAnh => _hinhAnh;

  // Setters
  set ma(String ma) {
    if (ma.isNotEmpty) {
      _ma = ma;
    }
  }

  set ten(String ten) {
    if (ten.isNotEmpty) {
      _ten = ten;
    }
  }

  set giaBan(double giaBan){
    if(giaBan > 0) {
      _giaBan = giaBan;
    } else {
      throw Exception("Giá bán phải lớn hơn 0");
    }
  }

  set tinhTrang(String? tinhTrang) {
    if(tinhTrang == "Còn hàng" || tinhTrang == "Đã hết") {
      _tinhTrang = tinhTrang;
    } else {
      throw Exception("Tình trạng phải \"Còn hàng\" hoặc \"Đã hết\"");
    }
  }

  set thucDon(ThucDon thucDon) {
    _thucDon = thucDon;
  }

  set hinhAnh(String hinhAnh) {
    _hinhAnh = hinhAnh;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonAn && other._ma == _ma;
  }

  @override
  int get hashCode => _ma.hashCode;
}