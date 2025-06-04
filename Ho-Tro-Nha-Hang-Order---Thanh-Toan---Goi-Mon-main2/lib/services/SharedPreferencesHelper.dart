import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String userEmailKey = 'USER_EMAIL';
  static String userPasswordKey = 'USER_PASSWORD';
  static String userLoggedInKey = 'USER_LOGGED_IN';

  // Lưu email người dùng
  static Future<bool> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, email);
  }

  // Lưu mật khẩu người dùng
  static Future<bool> saveUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPasswordKey, password);
  }

  // Lưu trạng thái đăng nhập
  static Future<bool> saveUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(userLoggedInKey, isLoggedIn);
  }

  // Lấy email người dùng
  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Lấy mật khẩu người dùng
  static Future<String?> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPasswordKey);
  }

  // Kiểm tra người dùng đã đăng nhập chưa
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  // Xóa tất cả thông tin đăng nhập
  static Future<bool> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userEmailKey);
    await prefs.remove(userPasswordKey);
    return prefs.setBool(userLoggedInKey, false);
  }
}