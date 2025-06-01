// File: lib/services/MonAnService.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart'; // Đảm bảo MonAn có toMap() và fromMap()

class MonAnService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MonAn>> getAllMonAn() {
    return _firestore.collection('MonAn').snapshots().map((snapshot) => // Sửa 'monAn' thành 'MonAn' nếu tên collection là 'MonAn'
        snapshot.docs.map((doc) => MonAn.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }
}