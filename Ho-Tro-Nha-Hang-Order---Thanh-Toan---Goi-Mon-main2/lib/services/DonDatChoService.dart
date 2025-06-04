import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/DonDatCho.dart';
class DonDatChoService{
  final CollectionReference _donDatChoCollection = FirebaseFirestore.instance.collection('DonDatCho');
  Future<List<DonDatCho>> getDonDatCho() async {
    QuerySnapshot snapshot = await _donDatChoCollection.get();
    return snapshot.docs.map((doc) => DonDatCho.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addDonDatCho(DonDatCho donDatCho) async {
    await _donDatChoCollection.doc(donDatCho.ma).set(donDatCho.toMap());
  }

  Future<void> updateDonDatCho(DonDatCho donDatCho) async {
    await _donDatChoCollection.doc(donDatCho.ma).update(donDatCho.toMap());
  }
  Future<void> deleteDonDatCho(String id) async {
    await _donDatChoCollection.doc(id).delete();
  }
}