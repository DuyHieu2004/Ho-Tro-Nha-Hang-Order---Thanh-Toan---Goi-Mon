import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';

class DonGoiMonService{
  final CollectionReference _donGoiMon = FirebaseFirestore.instance.collection('DonGoiMon');

  Future<List<DonGoiMon>> getAllDonGoiMon() async {
    QuerySnapshot snapshot = await _donGoiMon.get();
    return snapshot.docs.map((doc) => DonGoiMon.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addDonGoiMon(DonGoiMon donGoiMonData) async {
    await _donGoiMon.doc(donGoiMonData.ma).set(donGoiMonData.toMap());
  }

  Future<void> updateDonGoiMon(DonGoiMon donGoiMonData) async {
    await _donGoiMon.doc(donGoiMonData.ma).update(donGoiMonData.toMap());
  }

  Future<void> deleteDonGoiMon(String id) async {
    await _donGoiMon.doc(id).delete();
  }
}