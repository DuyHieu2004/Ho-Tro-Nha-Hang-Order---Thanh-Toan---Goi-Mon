import 'package:doan_nhom_cuoiky/screens/LogIn_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Init_Screen());
}

class Init_Screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng hỗ trợ nhà hàng',
      home: LogIn_Screen()
    );
  }
}