import 'dart:io';
import 'dart:async';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/models/VaiTro.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddNhanSuScreen extends StatefulWidget {
  const AddNhanSuScreen({super.key});

  @override
  State<AddNhanSuScreen> createState() => _AddNhanSuScreenState();
}

class _AddNhanSuScreenState extends State<AddNhanSuScreen> {
  TextEditingController ma = TextEditingController();
  TextEditingController ten = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController cccd = TextEditingController();
  TextEditingController tk = TextEditingController();
  TextEditingController mk = TextEditingController();
  String selectedVaiTro = 'Phục vụ';
  TextEditingController anh = TextEditingController();

  final List<String> vaiTroOptions = ['Quản lý', 'Thu ngân', 'Phục vụ'];
  final _formKey = GlobalKey<FormState>();
  File? _image;

  Future<void> _requestPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quyền truy cập vào thư viện ảnh bị từ chối'),
          ),
        );
        return;
      }
    }
  }

  Future<void> getImage() async {
    await _requestPermission();
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      _image = imageTemp;
      anh.text = image.path; // Cập nhật đường dẫn ảnh
    });
  }

  void addNhanSu() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
        bool exists = await nhanSuProvider.checkNhanVienExists(ma.text);
        if (exists) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mã nhân viên đã tồn tại'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        VaiTro vaiTro = VaiTro.fromString(selectedVaiTro);
        NhanVien nv = NhanVien(
          ma: ma.text,
          ten: ten.text,
          SDT: sdt.text,
          CCCD: cccd.text,
          tk: tk.text,
          mk: mk.text,
          vaiTro: vaiTro,
          anh: anh.text.isNotEmpty ? anh.text : null,
        );

        await nhanSuProvider.addNhanVien(nv);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm nhân viên thành công'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi thêm: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ma.text = Provider.of<NhanSuProvider>(context, listen: false).getMaNhanVien();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm nhân viên',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFE6E1FA),
                    shape: BoxShape.circle,
                  ),
                  child: _image == null
                      ? Icon(
                          Icons.person_outline,
                          size: 50,
                          color: Colors.indigo[800],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: getImage,
                  child: const Text('Chọn ảnh'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ma,
                  decoration: InputDecoration(
                    labelText: 'Mã nhân viên *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ten,
                  decoration: InputDecoration(
                    labelText: 'Nhập họ và tên *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: sdt,
                  decoration: InputDecoration(
                    labelText: 'Nhập số điện thoại *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (value.length != 10) {
                      return 'Số điện thoại phải có 10 số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cccd,
                  decoration: InputDecoration(
                    labelText: 'Nhập CCCD *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập CCCD';
                    }
                    if (value.length != 12) {
                      return 'CCCD phải có 12 số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tk,
                  decoration: InputDecoration(
                    labelText: 'Nhập tài khoản *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tài khoản';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: mk,
                  decoration: InputDecoration(
                    labelText: 'Nhập mật khẩu *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedVaiTro,
                  decoration: InputDecoration(
                    labelText: 'Chọn vai trò *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: vaiTroOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedVaiTro = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn vai trò';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: 400,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: addNhanSu,
                    child: const Text(
                      'Thêm nhân viên',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}