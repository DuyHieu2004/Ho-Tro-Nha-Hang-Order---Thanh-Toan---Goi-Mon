import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import thư viện Firebase Auth
import 'package:firebase_core/firebase_core.dart';
import '../services/SharedPreferencesHelper.dart';
import '../models/NhanVien.dart';
import '../services/Auth_Service.dart';
import '../widgets/CustomAlertDialog.dart';
import 'Home_Screen.dart'; // Import thư viện Firebase Core
// Import file cấu hình Firebase của bạn

class LogIn_Screen extends StatefulWidget {
  const LogIn_Screen({super.key});

  @override
  State<LogIn_Screen> createState() => _LogIn_ScreenState();
}

class _LogIn_ScreenState extends State<LogIn_Screen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  bool _rememberMe = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm hiển thị dialog thông báo (có thể dùng chung cho thành công và lỗi)
  void _showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Hàm hiển thị dialog thông báo tùy chỉnh
  void _showCustomAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible:
          false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          icon: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
          backgroundColor:
              isSuccess ? Colors.green.shade400 : Colors.red.shade400,
        );
      },
    );
  }

  // Hàm xử lý đăng nhập với Firebase
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("Đang đăng nhập..."),
          ],
        ),
      );
    },
  );

  NhanVien? loggedInNhanVien;
  String? errorMessage;

  try {
    String email = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Thực hiện đăng nhập
    loggedInNhanVien = await _authService.signInWithEmailAndPassword(email, password);

    // Nếu đăng nhập thành công và người dùng chọn "Ghi nhớ đăng nhập"
    if (loggedInNhanVien != null && _rememberMe) {
      await SharedPreferencesHelper.saveUserEmail(email);
      await SharedPreferencesHelper.saveUserPassword(password);
      await SharedPreferencesHelper.saveUserLoggedIn(true);
    }
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi cụ thể từ Firebase Authentication
      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy người dùng với email này.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu không đúng.';
      } else if (e.code == 'invalid-email') {
        errorMessage = "Email không hợp lệ.";
      } else {
        errorMessage = 'Có lỗi xảy ra khi đăng nhập: ${e.message}';
      }
    } catch (e) {
      // Xử lý các lỗi chung khác
      errorMessage = 'Đã xảy ra lỗi không mong muốn: $e';
    }

    // 2. Chờ khoảng 2 giây để hiển thị thông báo "Đang đăng nhập..."
    // Điều này đảm bảo người dùng thấy thông báo loading đủ lâu
    await Future.delayed(const Duration(seconds: 2));

    // 3. Đóng hộp thoại "Đang đăng nhập..." sau khi đã chờ
    // Kiểm tra canPop để tránh lỗi nếu dialog đã bị đóng bằng cách nào đó
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // 4. Xử lý kết quả đăng nhập sau khi hộp thoại loading đã đóng
    if (loggedInNhanVien != null) {
      // Đăng nhập thành công:
      // Chuyển hướng trực tiếp đến Home_Screen1 mà không hiển thị thêm dialog thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home_Screen1(nhanVien: loggedInNhanVien),
        ),
      );
    } else {
      // Đăng nhập thất bại:
      // Hiển thị thông báo lỗi bằng SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Đăng nhập không thành công. Vui lòng kiểm tra lại.'),
        ),
      );
      // Nếu bạn vẫn muốn dùng _showCustomAlertDialog cho lỗi, bạn có thể gọi nó ở đây:
      // _showCustomAlertDialog(
      //   context: context,
      //   title: 'Lỗi đăng nhập',
      //   content: errorMessage ?? 'Đăng nhập không thành công.',
      //   isSuccess: false,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4C3), // Màu vàng nhạt ấm áp
      body: Stack(
        children: [
          // Hình nền (tùy chọn, có thể là ảnh nhà hàng mờ)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/restaurant_background.jpg',
                // Thay thế bằng đường dẫn ảnh nền của bạn
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Biểu tượng ứng dụng với hiệu ứng ScaleTransition
                    ScaleTransition(
                      scale: _logoAnimation,
                      child: const Icon(
                        Icons.restaurant_outlined,
                        // Một icon liên quan đến nhà hàng
                        size: 80.0,
                        color: const Color(
                          0xFF7CB342,
                        ), // Màu xanh lá cây tươi mát
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    // Khoảng cách tương đối với chiều cao màn hình
                    // TextFormField Tài khoản (đổi thành email)
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress, // Sử dụng email
                      decoration: InputDecoration(
                        labelText: 'Email', // Đổi label thành Email
                        labelStyle: const TextStyle(color: Color(0xFF558B2F)),
                        // Màu xanh đậm hơn cho label
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF8BC34A),
                          ), // Viền màu xanh lá
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF689F38),
                            width: 2.0,
                          ), // Viền đậm hơn khi focus
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF558B2F),
                        ), // Đổi icon thành email
                        filled: true,
                        fillColor: Colors.white.withOpacity(
                          0.8,
                        ), // Nền trắng mờ
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email'; // Thông báo lỗi cho email
                        }
                        // Kiểm tra định dạng email
                        if (!RegExp(
                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value)) {
                          return 'Email không hợp lệ.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // TextFormField Mật khẩu
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: const TextStyle(color: Color(0xFF558B2F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF8BC34A),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF689F38),
                            width: 2.0,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF558B2F),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Color(0xFF558B2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF689F38),
                        ),
                        const Text(
                          'Ghi nhớ đăng nhập',
                          style: TextStyle(color: Color(0xFF558B2F)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Nút Đăng nhập
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Gọi hàm xử lý đăng nhập Firebase
                          _signInWithEmailAndPassword(context);
                          // _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: const Color(
                          0xFF689F38,
                        ), // Màu xanh lá đậm nổi bật
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final Auth_Service _authService = Auth_Service();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      NhanVien? loggedInNhanVien = await _authService
          .signInWithEmailAndPassword(email, password);

      if (loggedInNhanVien != null) {
        // Đăng nhập thành công, bạn có thể chuyển sang màn hình Home_Screen
        // và truyền đối tượng loggedInNhanVien nếu cần
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home_Screen1(nhanVien: loggedInNhanVien)),
        );
      } else {
        // Hiển thị thông báo lỗi đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
              'Đăng nhập không thành công. Vui lòng kiểm tra email và mật khẩu.')),
        );
      }
    }
  }
}
