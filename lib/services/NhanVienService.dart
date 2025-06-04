// lib/services/NhanVienService.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/NhanVien.dart'; // Đảm bảo đường dẫn đúng

class NhanVienService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm để cập nhật mật khẩu trong Firebase Authentication
  Future<void> updateFirebaseAuthPassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('Không có người dùng nào đăng nhập. Vui lòng đăng nhập lại.');
    }
  }

  // Hàm để cập nhật mật khẩu trong Firestore
  Future<void> updateNhanVienPasswordInFirestore(String nhanVienId, String newPassword) async {
    try {
      await _firestore.collection('NhanVien').doc(nhanVienId).update({
        'MatKhau': newPassword,
      });
    } catch (e) {
      throw Exception('Không thể cập nhật mật khẩu trong Firestore: $e');
    }
  }

  // Hàm để lấy thông tin nhân viên theo tài khoản (email)
  Future<NhanVien?> getNhanVienByTaiKhoan(String taiKhoan) async {
    try {
      final querySnapshot = await _firestore
          .collection('NhanVien')
          .where('TaiKhoan', isEqualTo: taiKhoan)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return NhanVien.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy nhân viên theo tài khoản: $e');
      return null;
    }
  }
}