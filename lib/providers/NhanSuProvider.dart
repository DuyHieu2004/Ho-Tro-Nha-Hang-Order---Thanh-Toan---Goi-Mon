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
    _nhanSu = await _nhanSuService.getNhanSu();
    notifyListeners();
  }

  List<NhanVien> get nhanSu => _nhanSu;

  Future<void> addNhanVien(NhanVien nhanVien) async {
    await _nhanSuService.addNhanSu(nhanVien);
    await _loadNhanSu(); // Làm mới danh sách sau khi thêm
  }

  Future<void> updateNhanVien(NhanVien nhanVien) async {
    await _nhanSuService.updateNhanSu(nhanVien);
    await _loadNhanSu(); // Làm mới danh sách sau khi sửa
  }

  Future<void> deleteNhanVien(String ma) async {
    await _nhanSuService.deleteNhanSu(ma);
    await _loadNhanSu();
  }

  Future<bool> checkNhanVienExists(String ma) async {
    final snapshot = await _nhanSuService.getNhanSuByMa(ma);
    return snapshot.isNotEmpty;
  }
}