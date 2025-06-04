import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NhanSuService {
  final CollectionReference _ns = FirebaseFirestore.instance.collection('NhanVien');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<NhanVien>> getNhanSu() async {
    QuerySnapshot snapshot = await _ns.get();
    return snapshot.docs
        .map(
          (doc) => NhanVien.fromMap(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> addNhanSu(NhanVien nhanSu) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: nhanSu.tk!,
      password: nhanSu.mk!,
    );

    // Lưu document với mã nhân viên làm ID
    await _ns.doc(nhanSu.ma).set(nhanSu.toMap());
    
    // Cập nhật authUid
    await _ns.doc(nhanSu.ma).update({
      'authUid': userCredential.user!.uid,
    });
    
    // Set ID cho object
    nhanSu.id = nhanSu.ma;
    
  } catch (e) {
    print('Lỗi khi thêm nhân viên: $e');
    if (_auth.currentUser != null) {
      await _auth.currentUser!.delete();
    }
    throw Exception('Không thể thêm nhân viên: $e');
  }
}

  Future<void> updateNhanSu(NhanVien nhanSu) async {
    await _ns.doc(nhanSu.ma).update(nhanSu.toMap());
  }

  Future<void> updateFirebaseAuthPassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('Không có người dùng nào đăng nhập. Vui lòng đăng nhập lại.');
    }
  }

Future<void> updateNhanVienPasswordInFirestore(String nhanVienId, String newPassword) async {
    try {
      await _ns.doc(nhanVienId).update({
        'MatKhau': newPassword,
      });
    } catch (e) {
      throw Exception('Không thể cập nhật mật khẩu trong Firestore: $e');
    }
  }

  Future<NhanVien?> getNhanVienByTaiKhoan(String taiKhoan) async {
    try {
      final querySnapshot = await _ns
          .where('TaiKhoan', isEqualTo: taiKhoan)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return NhanVien.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy nhân viên theo tài khoản: $e');
      return null;
    }
  }

  Future<void> deleteNhanSu(NhanVien nv) async {
    try {
      if (nv.ma == null || nv.ma!.isEmpty) {
        throw Exception('Mã nhân viên không hợp lệ');
      }

      DocumentSnapshot doc = await _ns.doc(nv.ma).get();
      
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        
        // Xóa tài khoản Firebase Auth nếu có
        if (data != null && 
            data.containsKey('TaiKhoan') && 
            data.containsKey('MatKhau')) {
          String email = data['TaiKhoan'] as String;
          String password = data['MatKhau'] as String;

          try {
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);
            await userCredential.user?.delete();
          } catch (e) {
            print('Lỗi khi xóa tài khoản Auth: $e');
            // Tiếp tục xóa document dù Auth thất bại
          }
        }
        
        // Xóa document
        await _ns.doc(nv.ma).delete();
      } else {
        throw Exception('Không tìm thấy nhân viên với mã: ${nv.ma}');
      }
    } catch (e) {
      print('Lỗi khi xóa nhân viên: $e');
      throw Exception('Không thể xóa nhân viên: $e');
    }
  }
}