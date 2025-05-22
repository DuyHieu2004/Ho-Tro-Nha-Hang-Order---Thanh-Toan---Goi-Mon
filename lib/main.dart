import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:doan_nhom_cuoiky/providers/SettingProvider.dart';
import 'package:doan_nhom_cuoiky/providers/HoaDonProvider.dart';
import 'package:doan_nhom_cuoiky/screens/LogIn_Screen.dart';
import 'package:doan_nhom_cuoiky/screens/SettingScreen.dart';
import 'package:doan_nhom_cuoiky/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => NhanSuProvider()),
        ChangeNotifierProvider(create: (_) => HoaDonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (context, settingProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ứng dụng hỗ trợ nhà hàng',
          theme: AppTheme.lightTheme(settingProvider.fontFamily),
          darkTheme: AppTheme.darkTheme(settingProvider.fontFamily),
          themeMode: settingProvider.themeMode,
          home: const LogIn_Screen(),
        );
      },
    );
  }
}
