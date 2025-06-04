import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:doan_nhom_cuoiky/models/NhanVien.dart'; // Đảm bảo đường dẫn đúng
import 'package:doan_nhom_cuoiky/services/NhanVienService.dart'; // Import NhanVienService

class ChangePassword_Screen extends StatefulWidget {
  final NhanVien? nhanVien; // Nhận đối tượng NhanVien từ màn hình trước
  ChangePassword_Screen({required this.nhanVien});

  @override
  _ChangePassword_ScreenState createState() => _ChangePassword_ScreenState();
}

class _ChangePassword_ScreenState extends State<ChangePassword_Screen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;
  bool _isUpdating = false;

  final NhanVienService _nhanVienService = NhanVienService(); // Khởi tạo Service

  AnimationController? _buttonAnimationController;
  Animation<double>? _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _buttonAnimationController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _buttonAnimationController?.dispose();
    super.dispose();
  }

  // Hàm kiểm tra tính hợp lệ của mật khẩu (cần ít nhất 6 ký tự)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống.';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    return null;
  }

  // Hàm kiểm tra xác nhận mật khẩu mới
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Xác nhận mật khẩu không được để trống.';
    }
    if (value != _newPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    return null;
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      // Nếu form không hợp lệ, có thể thêm rung nhẹ cho nút Cập nhật (tùy chọn)
      // _buttonAnimationController?.forward().then((_) => _buttonAnimationController?.reverse());
      return; // Dừng lại nếu form không hợp lệ
    }

    // Lấy thông tin người dùng hiện tại từ Firebase Authentication
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar('Bạn cần đăng nhập để đổi mật khẩu.', Colors.red);
      return;
    }

    setState(() {
      _isUpdating = true;
      _buttonAnimationController?.forward();
    });

    try {
      // 1. Xác thực lại người dùng bằng mật khẩu hiện tại (quan trọng cho security)
      // Để đổi mật khẩu, người dùng cần xác thực lại.
      // Dùng EmailAuthProvider.credential nếu bạn dùng Email/Password
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!, // Email của người dùng hiện tại
        password: _currentPasswordController.text,
      );

      await currentUser.reauthenticateWithCredential(credential);

      // 2. Cập nhật mật khẩu trong Firebase Authentication
      final String newPassword = _newPasswordController.text;
      await _nhanVienService.updateFirebaseAuthPassword(newPassword);

      // 3. Cập nhật mật khẩu trong Firestore
      // Đảm bảo widget.nhanVien.id có giá trị
      if (widget.nhanVien?.id != null) {
        await _nhanVienService.updateNhanVienPasswordInFirestore(
          widget.nhanVien!.id!,
          newPassword,
        );
      } else {
        // Trường hợp không có id nhân viên, có thể tìm kiếm theo tài khoản
        // hoặc thông báo lỗi nếu id là bắt buộc.
        print('Không tìm thấy ID nhân viên để cập nhật Firestore. Đang thử cập nhật qua tài khoản.');
        // Bạn có thể implement logic để tìm kiếm ID dựa trên email của người dùng nếu cần.
        // Ví dụ:
        // NhanVien? nv = await _nhanVienService.getNhanVienByTaiKhoan(currentUser.email!);
        // if (nv?.id != null) {
        //   await _nhanVienService.updateNhanVienPasswordInFirestore(nv!.id!, newPassword);
        // } else {
        //   throw Exception('Không thể tìm thấy nhân viên trong Firestore để cập nhật.');
        // }
      }

      _showSnackBar('Đổi mật khẩu thành công!', Colors.green);
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Đổi mật khẩu thất bại. Vui lòng thử lại.';
      if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu hiện tại không đúng.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Bạn cần đăng nhập lại gần đây để đổi mật khẩu.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Tài khoản của bạn đã bị vô hiệu hóa.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy người dùng.';
      } else {
        errorMessage = 'Lỗi Firebase: ${e.message}';
      }
      _showSnackBar(errorMessage, Colors.red);
      print('Firebase Auth Error: ${e.code} - ${e.message}');
    } catch (e) {
      _showSnackBar('Đã xảy ra lỗi không mong muốn: ${e.toString()}', Colors.red);
      print('General Error: $e');
    } finally {
      setState(() {
        _isUpdating = false;
        _buttonAnimationController?.reverse();
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Đổi Mật Khẩu', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: _obscureConfirmNewPassword,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
                      });
                    },
                  ),
                ),
                validator: _validateConfirmPassword,
              ),
              SizedBox(height: 30.0),
              ScaleTransition(
                scale: _buttonScaleAnimation!,
                child: ElevatedButton(
                  onPressed: _isUpdating ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                  ),
                  child: _isUpdating
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Cập nhật',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}