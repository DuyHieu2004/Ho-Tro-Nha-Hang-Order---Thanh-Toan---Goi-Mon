import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/PhieuTamUng.dart';

class PhieuTamUngService{
  final CollectionReference _phieuTamUngCollection = FirebaseFirestore.instance.collection('PhieuTamUng');

  Future<List<PhieuTamUng>> getPhieuTamUng() async {
    QuerySnapshot snapshot = await _phieuTamUngCollection.get();
    return snapshot.docs.map((doc) => PhieuTamUng.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addPhieuTamUng(PhieuTamUng phieuTamUng) async {
    await _phieuTamUngCollection.doc(phieuTamUng.ma).set(phieuTamUng.toMap());
  }

  Future<void> updatePhieuTamUng(PhieuTamUng phieuTamUng) async {
    await _phieuTamUngCollection.doc(phieuTamUng.ma).update(phieuTamUng.toMap());
  }

  Future<void> deletePhieuTamUng(String id) async {
    await _phieuTamUngCollection.doc(id).delete();
  }
}