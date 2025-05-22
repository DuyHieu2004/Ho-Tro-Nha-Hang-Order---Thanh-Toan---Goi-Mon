import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/NhanVien.dart';

class Auth_Service {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm đăng nhập
  Future<NhanVien?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        return await _getNhanVienByUid(user.uid);
      }
      return null;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return null;
    }
  }

  // Hàm lấy thông tin nhân viên theo UID
  Future<NhanVien?> _getNhanVienByUid(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('NhanVien').doc(uid).get();

      if (snapshot.exists) {
        return NhanVien.fromMap(snapshot.data()!, snapshot.id);
      } else {
        print("Không tìm thấy nhân viên với UID: $uid");
        return null;
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin nhân viên: $e");
      return null;
    }
  }

// Các hàm khác như đăng ký, đăng xuất có thể được thêm vào đây
}