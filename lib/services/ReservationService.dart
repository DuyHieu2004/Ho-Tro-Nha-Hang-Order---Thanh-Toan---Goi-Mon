// File: lib/services/ReservationService.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart'; // Đảm bảo import MonAn nếu bạn dùng nó trong ChiTietGoiMon

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DonGoiMon>> getReservationsForDate(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection('DonGoiMon') // Sửa 'donGoiMon' thành 'DonGoiMon'
        .where('ngayLap', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay)) // Chuyển sang Timestamp
        .where('ngayLap', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay)) // Chuyển sang Timestamp
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DonGoiMon.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Ban>> getAvailableTables() {
    // print('Đang lấy dữ liệu bàn từ Firestore...'); // Có thể bỏ comment này
    return _firestore.collection('Ban').snapshots().map((snapshot) { // Sửa 'ban' thành 'Ban'
      // print('Số lượng tài liệu bàn nhận được từ Firestore: ${snapshot.docs.length}'); // Có thể bỏ comment này
      if (snapshot.docs.isEmpty) {
        // print('Không có tài liệu nào trong collection "Ban".'); // Có thể bỏ comment này
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // print('Dữ liệu thô từ Firestore cho bàn ${doc.id}: $data'); // Có thể bỏ comment này
        try {
          final ban = Ban.fromMap(data);
          // print('Đã chuyển đổi Ban thành công: ${ban.ma} - ${ban.trangThai}'); // Có thể bỏ comment này
          return ban;
        } catch (e) {
          print('Lỗi chuyển đổi dữ liệu bàn ${doc.id} thành Ban: $e, Dữ liệu: $data');
          rethrow; // Ném lại lỗi để có thể bắt ở lớp UI
        }
      }).toList();
    });
  }

  Future<void> addReservation(DonGoiMon donGoiMon, List<ChiTietGoiMon> chiTietGoiMonList) async {
    try {
      // print("Bắt đầu thêm đơn đặt chỗ..."); // Có thể bỏ comment này

      // Thêm DonGoiMon và lấy DocumentReference để cập nhật mã
      DocumentReference docRef = await _firestore.collection('DonGoiMon').add(donGoiMon.toMap()); // Sửa 'donGoiMon' thành 'DonGoiMon'

      // Cập nhật trường 'ma' của DonGoiMon bằng ID tự động của Firestore
      await docRef.update({'ma': docRef.id});
      donGoiMon.ma = docRef.id; // Cập nhật lại đối tượng DonGoiMon trong bộ nhớ

      // print("Đã thêm DonGoiMon với ID: ${docRef.id}"); // Có thể bỏ comment này

      for (var chiTiet in chiTietGoiMonList) {
        // Đảm bảo ChiTietGoiMon.toMap() bao gồm cả MonAn.toMap()
        await docRef.collection('ChiTietGoiMon').add(chiTiet.toMap()); // Sửa 'chiTietGoiMon' thành 'ChiTietGoiMon'
        // print("Đã thêm chi tiết món ăn: ${chiTiet.getMonAn?.getTen}"); // Có thể bỏ comment này
      }
      // print("Đã thêm tất cả chi tiết món ăn."); // Có thể bỏ comment này

      // Cập nhật trạng thái bàn
      if (donGoiMon.maBan != null && donGoiMon.maBan!.ma != null) {
        await _firestore.collection('Ban').doc(donGoiMon.maBan!.ma).update({'trangThai': 'Đã đặt'}); // Sửa 'ban' thành 'Ban'
        // print("Đã cập nhật trạng thái bàn ${donGoiMon.maBan!.ma} thành Đã đặt."); // Có thể bỏ comment này
      } else {
        // print("Không có bàn được chọn để cập nhật trạng thái."); // Có thể bỏ comment này
      }
      // print("Hoàn tất thêm đơn đặt chỗ thành công."); // Có thể bỏ comment này
    } catch (e) {
      print("Lỗi cụ thể khi thêm đơn đặt chỗ: $e");
      rethrow;
    }
  }

  Future<void> cancelReservation(String donGoiMonMa, String? banMa) async {
    try {
      await _firestore.collection('DonGoiMon').doc(donGoiMonMa).update({'trangThai': 'Hủy'}); // Sửa 'donGoiMon' thành 'DonGoiMon'
      if (banMa != null) {
        await _firestore.collection('Ban').doc(banMa).update({'trangThai': 'Trống'}); // Sửa 'ban' thành 'Ban'
      }
    } catch (e) {
      print("Lỗi khi hủy đơn đặt chỗ: $e");
      rethrow;
    }
  }

  Stream<List<ChiTietGoiMon>> getChiTietGoiMonForDonGoiMon(String donGoiMonId) {
    return _firestore
        .collection('DonGoiMon') // Sửa 'donGoiMon' thành 'DonGoiMon'
        .doc(donGoiMonId)
        .collection('ChiTietGoiMon') // Sửa 'chiTietGoiMon' thành 'ChiTietGoiMon'
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChiTietGoiMon.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}