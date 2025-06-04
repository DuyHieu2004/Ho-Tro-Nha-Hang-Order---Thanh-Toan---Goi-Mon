import 'dart:io';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/BanProvider.dart';
import 'package:doan_nhom_cuoiky/providers/ChiTietDonGoiMonProvider.dart';
import 'package:doan_nhom_cuoiky/providers/DonDatChoProvider.dart';
import 'package:doan_nhom_cuoiky/providers/DonGoiMonProvider.dart';
import 'package:doan_nhom_cuoiky/providers/KhachHangProvider.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:doan_nhom_cuoiky/providers/PhieuTamUngProvider.dart';
import 'package:doan_nhom_cuoiky/providers/SettingProvider.dart';
import 'package:doan_nhom_cuoiky/providers/HoaDonProvider.dart';
import 'package:doan_nhom_cuoiky/screens/Home_Screen.dart';
import 'package:doan_nhom_cuoiky/screens/LogIn_Screen.dart';
import 'package:doan_nhom_cuoiky/services/Auth_Service.dart';
import 'package:doan_nhom_cuoiky/services/NotificationService.dart';
import 'package:doan_nhom_cuoiky/services/SharedPreferencesHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  
  bool? isLoggedIn = await SharedPreferencesHelper.getUserLoggedIn();
  String? email = await SharedPreferencesHelper.getUserEmail();
  String? password = await SharedPreferencesHelper.getUserPassword();
  
  NhanVien? loggedInNhanVien;
  if (isLoggedIn == true && email != null && password != null) {
    Auth_Service authService = Auth_Service();
    loggedInNhanVien = await authService.signInWithEmailAndPassword(email, password);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => NhanSuProvider()),
        ChangeNotifierProvider(create: (_) => HoaDonProvider()),
        ChangeNotifierProvider(create: (_) => DonGoiMonProvider()),
        ChangeNotifierProvider(create: (_) => ChiTietDonGoiMonProvider()),
        ChangeNotifierProvider(create: (_) => BanProvider()),
        ChangeNotifierProvider(create: (_) => DonDatChoProvider()),
        ChangeNotifierProvider(create: (_) => KhachHangProvider()),
        ChangeNotifierProvider(create: (_) => PhieuTamUngProvider()),
      ],
      child: MyApp(loggedInNhanVien: loggedInNhanVien,),
    ),
  );
}

class MyApp extends StatelessWidget {
  final NhanVien? loggedInNhanVien;
  
  const MyApp({super.key, this.loggedInNhanVien});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (context, settingProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ứng dụng hỗ trợ nhà hàng',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFFFF4D4D),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF4D4D),
              secondary: Color(0xFF4CAF50),
              surface: Color(0xFFFFFFFF),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Colors.black,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontFamily: settingProvider.fontFamily,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: settingProvider.fontFamily,
              ),
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: settingProvider.fontFamily,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF4CAF50),
            scaffoldBackgroundColor: const Color(0xFF1E1E1E),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4CAF50),
              secondary: Color(0xFF2196F3),
              surface: Color(0xFF2C2C2C),
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: settingProvider.fontFamily,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: settingProvider.fontFamily,
              ),
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: settingProvider.fontFamily,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            cardTheme: CardTheme(
              color: const Color(0xFF2C2C2C),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          themeMode: settingProvider.themeMode,
          home: loggedInNhanVien != null ? Home_Screen1(nhanVien: loggedInNhanVien!) : const LogIn_Screen(),
        );
      },
    );
  }
}