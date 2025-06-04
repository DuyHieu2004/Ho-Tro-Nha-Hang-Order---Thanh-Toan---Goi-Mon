
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/KhachHang.dart';

class KhachHangService{
  final CollectionReference _khachHangCollection = FirebaseFirestore.instance.collection('KhachHang');

  Future<List<KhachHang>> getKhachHang() async {
    QuerySnapshot snapshot = await _khachHangCollection.get();
    return snapshot.docs.map((doc) => KhachHang.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addKhachHang(KhachHang khachHang) async {
    await _khachHangCollection.add(khachHang.toMap());
  }

  Future<void> updateKhachHang(String maKhachHang, KhachHang khachHang) async {
    await _khachHangCollection.doc(maKhachHang).update(khachHang.toMap());
  }

  Future<void> deleteKhachHang(String maKhachHang) async {
    await _khachHangCollection.doc(maKhachHang).delete();
  }
}