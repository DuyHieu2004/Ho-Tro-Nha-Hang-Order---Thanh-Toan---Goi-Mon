import 'package:doan_nhom_cuoiky/models/KhachHang.dart';
import 'package:doan_nhom_cuoiky/services/KhachHangService.dart';
import 'package:flutter/foundation.dart';

class KhachHangProvider extends ChangeNotifier {
  List<KhachHang> _khachHangs = [];
  final KhachHangService _khachHangService = KhachHangService();

  KhachHangProvider() {
    _loadKhachHangs();
  }

  Future<void> _loadKhachHangs() async {
    _khachHangs = await _khachHangService.getKhachHang();
    notifyListeners();
  }

  List<KhachHang> get khachHangs => _khachHangs;

  Future<void> addKhachHang(KhachHang khachHang) async{
    await _khachHangService.addKhachHang(khachHang);
    _loadKhachHangs();
  }

  Future<void> updateKhachHang(KhachHang khachHang) async{
    await _khachHangService.updateKhachHang(khachHang);
    _loadKhachHangs();
  }

  Future<void> deleteKhachHang(KhachHang khachHang) async{
    await _khachHangService.deleteKhachHang(khachHang.maKhachHang!);
    _loadKhachHangs();
  }

  Future<void> clearKhachHangs() async{
    _khachHangs.clear();
    _loadKhachHangs();
  }
}