// File: lib/services/ReservationService.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DonGoiMon>> getReservationsForDate(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    print('Truy vấn đặt chỗ từ ${startOfDay.toIso8601String()} đến ${endOfDay.toIso8601String()}');

    return _firestore
        .collection('DonGoiMon')
        .where('NgayLap', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay)) // Đảm bảo key 'NgayLap'
        .where('NgayLap', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay)) // Đảm bảo key 'NgayLap'
        .snapshots()
        .map((snapshot) {
          print('Số lượng tài liệu DonGoiMon nhận được: ${snapshot.docs.length}');
          if (snapshot.docs.isEmpty) {
            print('Không tìm thấy đơn đặt chỗ nào cho ngày này.');
          }
          return snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                print('Dữ liệu thô DonGoiMon từ Firestore (${doc.id}): $data');
                try {
                  return DonGoiMon.fromMap(data);
                } catch (e) {
                  print('Lỗi chuyển đổi DonGoiMon (${doc.id}): $e, Dữ liệu: $data');
                  return DonGoiMon(ma: doc.id);
                }
              })
              .toList();
        });
  }

  Stream<List<Ban>> getAvailableTables() {
    // Phương thức này lấy TẤT CẢ các bàn, logic lọc sẽ ở lớp UI (CreateReservationScreen)
    return _firestore.collection('Ban').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Ban.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> addReservation(DonGoiMon donGoiMon, List<ChiTietGoiMon> chiTietGoiMonList) async {
    try {
      print("Bắt đầu thêm đơn đặt chỗ...");
      DocumentReference docRef = await _firestore.collection('DonGoiMon').add(donGoiMon.toMap());
      print("Đã thêm DonGoiMon với ID tạm: ${docRef.id}");

      await docRef.update({'Ma': docRef.id});
      donGoiMon.ma = docRef.id;
      print("Đã cập nhật mã DonGoiMon: ${donGoiMon.ma}");

      for (var chiTiet in chiTietGoiMonList) {
        await docRef.collection('ChiTietGoiMon').add(chiTiet.toMap());
        print("Đã thêm chi tiết món ăn: ${chiTiet.getMonAn?.getTen}");
      }
      print("Đã thêm tất cả chi tiết món ăn.");

      // Cập nhật trạng thái bàn thành "Đã đặt"
      if (donGoiMon.maBan != null && donGoiMon.maBan!.ma != null) {
        await _firestore.collection('Ban').doc(donGoiMon.maBan!.ma).update({'TrangThai': 'Đã đặt'}); // Sửa thành 'TrangThai' (PascalCase)
        print("Đã cập nhật trạng thái bàn ${donGoiMon.maBan!.ma} thành Đã đặt.");
      } else {
        print("Không có bàn được chọn để cập nhật trạng thái.");
      }
      print("Hoàn tất thêm đơn đặt chỗ thành công.");
    } catch (e) {
      print("Lỗi cụ thể khi thêm đơn đặt chỗ trong ReservationService: $e");
      rethrow;
    }
  }

  Future<void> cancelReservation(String donGoiMonMa, String? banMa) async {
    try {
      await _firestore.collection('DonGoiMon').doc(donGoiMonMa).update({'TrangThai': 'Hủy'});
      if (banMa != null) {
        await _firestore.collection('Ban').doc(banMa).update({'TrangThai': 'Trống'});
      }
    } catch (e) {
      print("Lỗi khi hủy đơn đặt chỗ: $e");
      rethrow;
    }
  }

  Stream<List<ChiTietGoiMon>> getChiTietGoiMonForDonGoiMon(String donGoiMonId) {
    return _firestore
        .collection('DonGoiMon')
        .doc(donGoiMonId)
        .collection('ChiTietGoiMon')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChiTietGoiMon.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}