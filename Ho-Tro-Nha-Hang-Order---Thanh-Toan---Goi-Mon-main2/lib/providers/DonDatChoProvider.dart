import 'package:doan_nhom_cuoiky/models/DonDatCho.dart';
import 'package:flutter/foundation.dart';
import '../services/DonDatChoService.dart';
import '../services/NotificationService.dart';

class DonDatChoProvider extends ChangeNotifier {
  List<DonDatCho> _donDatChoList = [];
  final DonDatChoService _donDatChoService = DonDatChoService();
  final NotificationService _notificationService = NotificationService();

  List<DonDatCho> get donDatChoList => _donDatChoList;

  DonDatChoProvider() {
    _loadDonDatCho();
  }

  Future<void> _loadDonDatCho() async {
    _donDatChoList = await _donDatChoService.getDonDatCho();
    
    // Lên lịch thông báo cho tất cả đơn đặt chỗ
    for (var donDatCho in _donDatChoList) {
      if (donDatCho.ngayDat != null) {
        await _notificationService.scheduleReservationNotification(donDatCho);
      }
    }
    
    notifyListeners();
  }

  Future<void> addDonDatCho(DonDatCho donDatCho) async {
    await _donDatChoService.addDonDatCho(donDatCho);
    
    // Lên lịch thông báo cho đơn đặt chỗ mới
    if (donDatCho.ngayDat != null) {
      await _notificationService.scheduleReservationNotification(donDatCho);
    }
    
    _loadDonDatCho();
  }

  Future<void> deleteDonDatCho(String id) async {
    // Hủy thông báo trước khi xóa đơn đặt chỗ
    await _notificationService.cancelReservationNotification(id);
    
    await _donDatChoService.deleteDonDatCho(id);
    _loadDonDatCho();
  }

  Future<void> updateDonDatCho(DonDatCho donDatCho) async {
    await _donDatChoService.updateDonDatCho(donDatCho);
    
    // Hủy thông báo cũ và lên lịch thông báo mới
    if (donDatCho.ma != null) {
      await _notificationService.cancelReservationNotification(donDatCho.ma!);
      
      if (donDatCho.ngayDat != null) {
        await _notificationService.scheduleReservationNotification(donDatCho);
      }
    }
    
    _loadDonDatCho();
  }
}