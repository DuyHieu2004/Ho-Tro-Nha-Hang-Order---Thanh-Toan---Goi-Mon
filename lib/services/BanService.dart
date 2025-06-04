import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Ban.dart'; // Đảm bảo đường dẫn này đúng với vị trí của file Ban.dart

class BanService {
  final CollectionReference _banCollection = FirebaseFirestore.instance.collection('Ban');

  // Phương thức để lấy danh sách tất cả các bàn
  Future<List<Ban>> getBanList() async {
    try {
      QuerySnapshot snapshot = await _banCollection.get();
      return snapshot.docs.map((doc) {
        // Đảm bảo rằng ID của document được gán vào trường 'ma' nếu bạn dùng 'ma' làm ID
        // Nếu trường 'ma' đã có sẵn trong dữ liệu, bạn có thể không cần gán lại
        return Ban.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách bàn: $e");
      return [];
    }
  }

  // Phương thức để thêm một bàn mới
  // Firestore sẽ tự động tạo một ID document nếu bạn dùng .add()
  Future<void> addBan(Ban ban) async {
    try {
      await _banCollection.add(ban.toMap());
    } catch (e) {
      print("Lỗi khi thêm bàn: $e");
      rethrow; // Ném lại lỗi để xử lý ở tầng trên nếu cần
    }
  }

  // Phương thức để cập nhật thông tin của một bàn
  // Cần ID của document để cập nhật
  Future<void> updateBan(String banId, Ban ban) async {
    try {
      // Bạn cần ID của document (ví dụ: 'B001') để cập nhật.
      // Nếu trường 'ma' của Ban là ID document, bạn có thể dùng ban.ma!
      await _banCollection.doc(banId).update(ban.toMap());
    } catch (e) {
      print("Lỗi khi cập nhật bàn $banId: $e");
      rethrow;
    }
  }

  // Phương thức để xóa một bàn
  // Cần ID của document để xóa
  Future<void> deleteBan(String banId) async {
    try {
      await _banCollection.doc(banId).delete();
    } catch (e) {
      print("Lỗi khi xóa bàn $banId: $e");
      rethrow;
    }
  }

  // Phương thức lấy thông tin một bàn cụ thể theo mã (nếu mã là ID document)
  Future<Ban?> getBanById(String banId) async {
    try {
      DocumentSnapshot doc = await _banCollection.doc(banId).get();
      if (doc.exists) {
        return Ban.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy bàn theo ID $banId: $e");
      return null;
    }
  }

  // Phương thức lấy danh sách bàn theo trạng thái (ví dụ: "Trống", "Đã đặt", "Đang phục vụ")
  Future<List<Ban>> getBanByTrangThai(String trangThai) async {
    try {
      QuerySnapshot snapshot = await _banCollection
          .where('trangThai', isEqualTo: trangThai)
          .get();
      return snapshot.docs.map((doc) => Ban.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Lỗi khi lấy bàn theo trạng thái $trangThai: $e");
      return [];
    }
  }

  // Phương thức lấy danh sách bàn theo sức chứa tối thiểu
  Future<List<Ban>> getBanBySucChuaMin(int sucChuaMin) async {
    try {
      QuerySnapshot snapshot = await _banCollection
          .where('sucChua', isGreaterThanOrEqualTo: sucChuaMin)
          .get();
      return snapshot.docs.map((doc) => Ban.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Lỗi khi lấy bàn theo sức chứa tối thiểu $sucChuaMin: $e");
      return [];
    }
  }
}