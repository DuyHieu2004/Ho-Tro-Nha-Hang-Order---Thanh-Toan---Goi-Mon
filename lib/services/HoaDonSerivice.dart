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
}