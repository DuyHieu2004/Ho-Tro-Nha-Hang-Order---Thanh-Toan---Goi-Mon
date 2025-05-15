import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/services/NhanSuService.dart';
import 'package:flutter/foundation.dart';

class NhanSuProvider extends ChangeNotifier {
  List<NhanVien> _nhanSu = [];
  final NhanSuService _nhanSuService = NhanSuService();

  NhanSuProvider() {
    _loadNhanSu();
  }

  Future<void> _loadNhanSu() async {
    try {
      _nhanSu = await _nhanSuService.getNhanSu();
      notifyListeners();
    } catch (e) {
      print('Lỗi khi tải nhân sự: $e');
    }
  }

  Future<void> refreshNhanSu() async {
    await _loadNhanSu();
  }

  List<NhanVien> get nhanSu => _nhanSu;

  Future<void> addNhanVien(NhanVien nhanVien) async {
    try {
      await _nhanSuService.addNhanSu(nhanVien);
      await _loadNhanSu();
    } catch (e) {
      print('Lỗi khi thêm nhân viên: $e');
    }
  }

  Future<void> updateNhanVien(NhanVien nhanVien) async {
    try {
      await _nhanSuService.updateNhanSu(nhanVien);
      await _loadNhanSu();
    } catch (e) {
      print('Lỗi khi cập nhật nhân viên: $e');
    }
  }

  Future<void> deleteNhanVien(String ma) async {
    try {
      await _nhanSuService.deleteNhanSu(ma);
      await _loadNhanSu();
    } catch (e) {
      print('Lỗi khi xóa nhân viên: $e');
    }
  }
}