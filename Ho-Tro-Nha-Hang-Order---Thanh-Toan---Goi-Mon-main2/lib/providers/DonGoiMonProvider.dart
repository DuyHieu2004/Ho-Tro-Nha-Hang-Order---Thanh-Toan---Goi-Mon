

import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/services/DonGoiMonService.dart';
import 'package:flutter/foundation.dart';

class DonGoiMonProvider extends ChangeNotifier{
  List<DonGoiMon> _donGoiMonList = [];
  final DonGoiMonService _donGoiMonService = DonGoiMonService();

  List<DonGoiMon> get donGoiMonList => _donGoiMonList;

  DonGoiMonProvider() {
    _loadDonGoiMon();
  }

  Future<void> _loadDonGoiMon() async {
    _donGoiMonList = await _donGoiMonService.getAllDonGoiMon();
    notifyListeners();
  }

  Future<void> addDonGoiMon(DonGoiMon donGoiMon) async {
    await _donGoiMonService.addDonGoiMon(donGoiMon);
    _loadDonGoiMon();
  }

  Future<void> updateDonGoiMon(DonGoiMon donGoiMon) async {
    await _donGoiMonService.updateDonGoiMon(donGoiMon);
    _loadDonGoiMon();
  }

  Future<void> deleteDonGoiMon(String id) async {
    await _donGoiMonService.deleteDonGoiMon(id);
    _loadDonGoiMon();
  }

  List<DonGoiMon> layDonDangPhucVu() {
    return _donGoiMonList.where((donGoiMon) => donGoiMon.trangThai == 'Đang phục vụ').toList();
  }
}