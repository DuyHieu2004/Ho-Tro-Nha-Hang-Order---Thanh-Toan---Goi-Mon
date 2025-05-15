import 'package:doan_nhom_cuoiky/models/ThucDon.dart';

class MonAn{
  String? _ma; 
  String? _ten;
  double? _giaBan;
  String? _tinhTrang;
  ThucDon? _thucDon;
  String? _hinhAnh;

  MonAn(this._ma, this._ten, this._giaBan, this._tinhTrang, this._thucDon, this._hinhAnh);

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'ma': _ma,
      'ten': _ten,
      'giaBan': _giaBan,
      'tinhTrang': _tinhTrang,
      'thucDon': _thucDon,
      'hinhAnh': _hinhAnh,
    };
  }

  // fromMap constructor
  MonAn.fromMap(Map<String, dynamic> map) {
    _ma = map['ma'];
    _ten = map['ten'];
    _giaBan = map['giaBan'];
    _tinhTrang = map['tinhTrang'];
    _thucDon = ThucDon.fromMap(map['thucDon']);
    _hinhAnh = map['hinhAnh'];
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
}