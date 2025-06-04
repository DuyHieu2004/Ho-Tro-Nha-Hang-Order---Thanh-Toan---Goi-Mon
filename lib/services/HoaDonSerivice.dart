import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/HoaDon.dart';

class HoaDonService{
  final CollectionReference _hoadon = FirebaseFirestore.instance.collection('HoaDon');

  Future<List<HoaDon>> getHoaDon() async {
    QuerySnapshot snapshot = await _hoadon.get();
    return snapshot.docs.map((doc) => HoaDon.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addHoaDon(HoaDon hoaDon) async {
    await _hoadon.add(hoaDon.toMap());
  }

  Future<void> updateHoaDon(HoaDon hoaDon) async {
    await _hoadon.doc(hoaDon.ma).update(hoaDon.toMap());
  }

  Future<void> deleteHoaDon(String id) async {
    await _hoadon.doc(id).delete();
  }

  Future<int> getTodayHoaDonCount() async {
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();
    // Tạo DateTime cho đầu ngày hôm nay (00:00:00)
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    // Tạo DateTime cho cuối ngày hôm nay (23:59:59)
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Thực hiện truy vấn Firestore để lấy các hóa đơn trong khoảng thời gian này
    QuerySnapshot snapshot = await _hoadon
        .where('ngayThanhToan', isGreaterThanOrEqualTo: startOfDay)
        .where('ngayThanhToan', isLessThanOrEqualTo: endOfDay)
        .get();

    // Trả về số lượng hóa đơn tìm thấy
    return snapshot.docs.length;
  }

  Future<double> getTodayRevenue() async {
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();
    // Tạo DateTime cho đầu ngày hôm nay (00:00:00)
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    // Tạo DateTime cho cuối ngày hôm nay (23:59:59)
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Thực hiện truy vấn Firestore để lấy các hóa đơn trong khoảng thời gian này
    QuerySnapshot snapshot = await _hoadon
        .where('ngayThanhToan', isGreaterThanOrEqualTo: startOfDay)
        .where('ngayThanhToan', isLessThanOrEqualTo: endOfDay)
        .get();

    double totalRevenue = 0.0;
    // Duyệt qua từng hóa đơn và cộng tổng tiền vào totalRevenue
    for (var doc in snapshot.docs) {
      // Chuyển đổi dữ liệu tài liệu sang đối tượng HoaDon
      HoaDon hoaDon = HoaDon.fromMap(doc.data() as Map<String, dynamic>);
      // Cộng tổng tiền của hóa đơn vào tổng doanh thu
      totalRevenue += hoaDon.tongTien ?? 0.0; // Sử dụng 0.0 nếu tongTien là null
    }

    return totalRevenue;
  }

}