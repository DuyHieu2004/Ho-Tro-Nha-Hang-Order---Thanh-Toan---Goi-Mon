import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/services/ChiTietDonGoiMonService.dart';
import 'package:flutter/foundation.dart';

class ChiTietDonGoiMonProvider extends ChangeNotifier {
  final ChiTietDonGoiMonService _service = ChiTietDonGoiMonService();
  List<ChiTietGoiMon> _chiTietDonGoiMonList = [];

  ChiTietDonGoiMonProvider() {
    _loadChiTietDonGoiMonList();
  }

  Future<void> _loadChiTietDonGoiMonList() async {
    _chiTietDonGoiMonList = await _service.getChiTietDonGoiMonList();
    notifyListeners();
  }

  List<ChiTietGoiMon> get chiTietDonGoiMonList => _chiTietDonGoiMonList;

  Future<void> addChiTietDonGoiMon(ChiTietGoiMon chiTiet) async {
    await _service.addChiTietDonGoiMon(chiTiet);
    await _loadChiTietDonGoiMonList();
  }

  Future<void> updateChiTietDonGoiMon(ChiTietGoiMon chiTiet) async {
    await _service.updateChiTietDonGoiMon(chiTiet);
    await _loadChiTietDonGoiMonList();
  }

  Future<void> deleteChiTietDonGoiMon(String id) async {
    await _service.deleteChiTietDonGoiMon(id);
    await _loadChiTietDonGoiMonList();
  }

  List<ChiTietGoiMon> getChiTietById(String id) {
    return _chiTietDonGoiMonList.where((chiTiet) => (chiTiet.getMaDonGoiMon as DonGoiMon).ma == id).toList();
  }
}