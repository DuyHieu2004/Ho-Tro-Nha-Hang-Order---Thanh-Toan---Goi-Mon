import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NhanSuService {
  final CollectionReference _ns = FirebaseFirestore.instance.collection(
    'NhanVien',
  );

  Future<List<NhanVien>> getNhanSu() async {
    QuerySnapshot snapshot = await _ns.get();
    return snapshot.docs
        .map(
          (doc) => NhanVien.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<List<NhanVien>> getNhanSuByMa(String ma) async {
    QuerySnapshot snapshot = await _ns.where('Ma', isEqualTo: ma).get();
    return snapshot.docs
        .map(
          (doc) => NhanVien.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<void> addNhanSu(NhanVien nhanSu) async {
    try {
      if (nhanSu.id != null) {
        await _ns.doc(nhanSu.id).set(nhanSu.toMap());
      } else {
        DocumentReference docRef = await _ns.add(nhanSu.toMap());
        nhanSu.id = docRef.id; // Cập nhật ID mới cho đối tượng
      }
    } catch (e) {
      print('Lỗi khi thêm nhân viên: $e');
      throw Exception('Không thể thêm nhân viên');
    }
  }

  Future<void> updateNhanSu(NhanVien nhanSu) async {
    try {
      if (nhanSu.id == null) {
        // Nếu không có ID, tìm theo mã
        QuerySnapshot snapshot = await _ns.where('Ma', isEqualTo: nhanSu.ma).limit(1).get();
        if (snapshot.docs.isEmpty) {
          throw Exception('Không tìm thấy nhân viên với mã ${nhanSu.ma}');
        }
        nhanSu.id = snapshot.docs.first.id;
      }
      
      await _ns.doc(nhanSu.id).update(nhanSu.toMap());
    } catch (e) {
      print('Lỗi khi cập nhật nhân viên: $e');
      throw Exception('Không thể cập nhật nhân viên');
    }
  }

  Future<void> deleteNhanSu(String id, String ma) async {
    try {
      if (id.isNotEmpty) {
        // Xóa tài khoản Firebase Authentication trước
        DocumentSnapshot doc = await _ns.doc(id).get();
        if (doc.exists) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('TaiKhoan') && data.containsKey('MatKhau')) {
            String email = data['TaiKhoan'] as String;
            String password = data['MatKhau'] as String;
            
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);
            await userCredential.user?.delete();
          }
          await _ns.doc(id).delete();
        }
      } else {
        QuerySnapshot snapshot = await _ns.where('Ma', isEqualTo: ma).get();
        if (snapshot.docs.isNotEmpty) {
          var docData = snapshot.docs.first.data() as Map<String, dynamic>;
          if (docData.containsKey('TaiKhoan') && docData.containsKey('MatKhau')) {
            String email = docData['TaiKhoan'] as String;
            String password = docData['MatKhau'] as String;
            
            try {
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
              await userCredential.user?.delete();
            } catch (e) {
              print('Lỗi khi xóa tài khoản Auth: $e');
            }
          }
          await snapshot.docs.first.reference.delete();
        }
      }
    } catch (e) {
      print('Lỗi khi xóa nhân viên: $e');
      throw Exception('Không thể xóa nhân viên');
    }
  }

  Future<bool> isMaNhanVienExists(String ma) async {
    try {
      QuerySnapshot snapshot = await _ns.where('Ma', isEqualTo: ma).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Lỗi khi kiểm tra mã nhân viên: $e');
      throw Exception('Không thể kiểm tra mã nhân viên');
    }
  }
}
