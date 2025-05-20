import 'package:doan_nhom_cuoiky/models/HoaDon.dart';
import 'package:doan_nhom_cuoiky/services/HoaDonSerivice.dart';
import 'package:flutter/foundation.dart';

class HoaDonProvider extends ChangeNotifier {
  List<HoaDon> _hoaDons = [];
  final HoaDonService _hoaDonService = HoaDonService();

  HoaDonProvider() {
    loadHoaDon();
  }
  
  List<HoaDon> get hoaDons => _hoaDons;

  Future<void> loadHoaDon() async {
    _hoaDons = await _hoaDonService.getHoaDon();
    notifyListeners();
  }

  Future<void> addHoaDon(HoaDon hoaDon) async {
    await _hoaDonService.addHoaDon(hoaDon);
    _hoaDons.add(hoaDon);
    loadHoaDon();
  }

  Future<void> updateHoaDon(HoaDon hoaDon) async {
    await _hoaDonService.updateHoaDon(hoaDon);
    int index = _hoaDons.indexWhere((element) => element.ma == hoaDon.ma);
    if (index != -1) {
      _hoaDons[index] = hoaDon;
    }
    loadHoaDon();
  }

  Future<void> deleteHoaDon(String id) async {
    await _hoaDonService.deleteHoaDon(id);
    _hoaDons.removeWhere((element) => element.ma == id);
    loadHoaDon();
  }
  
  // Phương thức lấy tổng doanh thu
  double getTongDoanhThu() {
    return _hoaDons.fold(0, (sum, hoaDon) => sum + (hoaDon.tongTien ?? 0));
  }
  
  // Phương thức lấy doanh thu theo ngày
  double getDoanhThuTheoNgay(DateTime ngay) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.year == ngay.year &&
            hoaDon.ngayThanhToan!.month == ngay.month &&
            hoaDon.ngayThanhToan!.day == ngay.day)
        .fold(0, (sum, hoaDon) => sum + (hoaDon.tongTien ?? 0));
  }
  
  // Phương thức lấy doanh thu theo tháng
  double getDoanhThuTheoThang(int thang, int nam) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.month == thang &&
            hoaDon.ngayThanhToan!.year == nam)
        .fold(0, (sum, hoaDon) => sum + (hoaDon.tongTien ?? 0));
  }
  
  // Phương thức lấy doanh thu theo năm
  double getDoanhThuTheoNam(int nam) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.year == nam)
        .fold(0, (sum, hoaDon) => sum + (hoaDon.tongTien ?? 0));
  }
  
  // Phương thức lấy doanh thu trong khoảng thời gian
  double getDoanhThuTrongKhoang(DateTime tuNgay, DateTime denNgay) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.isAfter(tuNgay) &&
            hoaDon.ngayThanhToan!.isBefore(denNgay.add(Duration(days: 1))))
        .fold(0, (sum, hoaDon) => sum + (hoaDon.tongTien ?? 0));
  }
  
  // Phương thức lấy số lượng hóa đơn
  int getSoLuongHoaDon() {
    return _hoaDons.length;
  }
  
  // Phương thức lấy số lượng hóa đơn theo ngày
  int getSoLuongHoaDonTheoNgay(DateTime ngay) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.year == ngay.year &&
            hoaDon.ngayThanhToan!.month == ngay.month &&
            hoaDon.ngayThanhToan!.day == ngay.day)
        .length;
  }
  
  // Phương thức lấy danh sách hóa đơn theo ngày
  List<HoaDon> getHoaDonTheoNgay(DateTime ngay) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.year == ngay.year &&
            hoaDon.ngayThanhToan!.month == ngay.month &&
            hoaDon.ngayThanhToan!.day == ngay.day)
        .toList();
  }
  
  // Phương thức lấy danh sách hóa đơn theo tháng
  List<HoaDon> getHoaDonTheoThang(int thang, int nam) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.month == thang &&
            hoaDon.ngayThanhToan!.year == nam)
        .toList();
  }
  
  // Phương thức lấy danh sách hóa đơn theo khoảng thời gian
  List<HoaDon> getHoaDonTrongKhoang(DateTime tuNgay, DateTime denNgay) {
    return _hoaDons
        .where((hoaDon) => 
            hoaDon.ngayThanhToan != null &&
            hoaDon.ngayThanhToan!.isAfter(tuNgay) &&
            hoaDon.ngayThanhToan!.isBefore(denNgay.add(Duration(days: 1))))
        .toList();
  }
  
  // Phương thức lấy hóa đơn có giá trị cao nhất
  HoaDon? getHoaDonGiaTriCaoNhat() {
    if (_hoaDons.isEmpty) return null;
    return _hoaDons.reduce((curr, next) => 
        (curr.tongTien ?? 0) > (next.tongTien ?? 0) ? curr : next);
  }
  
  // Phương thức lấy hóa đơn có giá trị cao nhất theo tháng
  HoaDon? getHoaDonGiaTriCaoNhatTheoThang(int thang, int nam) {
    List<HoaDon> hoaDonsTheoThang = getHoaDonTheoThang(thang, nam);
    if (hoaDonsTheoThang.isEmpty) return null;
    return hoaDonsTheoThang.reduce((curr, next) => 
        (curr.tongTien ?? 0) > (next.tongTien ?? 0) ? curr : next);
  }
  
  // Phương thức lấy giá trị hóa đơn trung bình
  double getGiaTriTrungBinh() {
    if (_hoaDons.isEmpty) return 0;
    return getTongDoanhThu() / _hoaDons.length;
  }
}