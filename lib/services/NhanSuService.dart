import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';

class NhanSuService {
  final CollectionReference _ns =  FirebaseFirestore.instance.collection('NhanSu');

  Future<List<NhanVien>> getNhanSu() async {
    QuerySnapshot snapshot = await _ns.get();
    return snapshot.docs.map((doc) => NhanVien.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addNhanSu(NhanVien nhanSu) async {
    await _ns.add(nhanSu.toMap());
  }

  Future<void> updateNhanSu(NhanVien nhanSu) async {
    await _ns.doc(nhanSu.ma).update(nhanSu.toMap());
  }

  Future<void> deleteNhanSu(String ma) async {
    await _ns.doc(ma).delete();
  }
}