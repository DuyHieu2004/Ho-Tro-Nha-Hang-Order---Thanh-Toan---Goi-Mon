import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/services/BanService.dart';
import 'package:flutter/material.dart';

class BanProvider extends ChangeNotifier{
  final BanService _banService = BanService();
  List<Ban> _bans = [];

  List<Ban> get bans => _bans;

  BanProvider() {
    _loadBans();
  }

  Future<void> _loadBans() async {
    _bans = await _banService.getBanList();
    notifyListeners();
  }

  Future<void> addBan(Ban ban) async {
    await _banService.addBan(ban);
    _loadBans();
  }

  Future<void> updateBan(Ban ban) async {
    await _banService.updateBan(ban);
    _loadBans();
  }

  Future<void> deleteBan(String id) async {
    await _banService.deleteBan(id);
    _loadBans();
  }

  Ban getBanById(String id) {
    return _bans.firstWhere((ban) => ban.ma == id);
  }
}