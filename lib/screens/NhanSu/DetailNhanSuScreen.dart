import 'package:doan_nhom_cuoiky/main.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/NhanSuScreen.dart';
import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../models/VaiTro.dart';

class DetailNhanSu extends StatefulWidget {
  final NhanVien nhanVien;

  const DetailNhanSu({Key? key, required this.nhanVien}) : super(key: key);

  @override
  _DetailNhanSuState createState() => _DetailNhanSuState();
}

class _DetailNhanSuState extends State<DetailNhanSu> {
  late TextEditingController idController;
  late TextEditingController maController;
  late TextEditingController tenController;
  late TextEditingController sdtController;
  late TextEditingController cccdController;
  late TextEditingController tkController;
  late TextEditingController mkController;
  late TextEditingController anhController;
  File? _image;
  String selectedVaiTro = ''; // Thêm biến để lưu vai trò được chọn
  
  final List<String> vaiTroOptions = ['Quản lý', 'Thu ngân', 'Phục vụ']; // Thêm danh sách vai trò

  @override
  void initState() {
    super.initState();
    maController = TextEditingController(text: widget.nhanVien.ma);
    tenController = TextEditingController(text: widget.nhanVien.ten);
    sdtController = TextEditingController(text: widget.nhanVien.SDT);
    cccdController = TextEditingController(text: widget.nhanVien.CCCD);
    tkController = TextEditingController(text: widget.nhanVien.tk);
    mkController = TextEditingController(text: widget.nhanVien.mk);
    anhController = TextEditingController(text: widget.nhanVien.anh);
    selectedVaiTro = widget.nhanVien.vaiTro.toString(); // Khởi tạo giá trị vai trò
  }

  Widget _buildInfoRow(BuildContext context, String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: value,
          ),
        ],
      ),
    );
  }

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

  Future<void> _pickImage() async {
    await _requestPermission();
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() {
      _image = imageTemp;
      anhController.text = image.path;
    });
  }

  Future<void> _updateNhanVien(BuildContext context) async {
    final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
    try {
      final updatedNhanVien = NhanVien(
        id: idController.text,
        ma: maController.text,
        ten: tenController.text,
        SDT: sdtController.text,
        CCCD: cccdController.text,
        tk: tkController.text,
        mk: mkController.text,
        vaiTro: VaiTro.fromString(selectedVaiTro), // Sử dụng vai trò đã chọn
        anh: anhController.text.isNotEmpty ? anhController.text : null,
      );
      await nhanSuProvider.updateNhanVien(updatedNhanVien);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
      Navigator.pop(context);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa nhân viên này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
                try {
                  await nhanSuProvider.deleteNhanVien(widget.nhanVien.ma!);
                  Navigator.pop(context); // Đóng dialog loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xóa nhân viên thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const NhanSuScreen()),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi khi xóa: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết nhân viên',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (widget.nhanVien.anh != null && widget.nhanVien.anh!.isNotEmpty
                            ? NetworkImage(widget.nhanVien.anh!)
                            : const AssetImage('assets/images/default.png')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _pickImage,
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      'Mã nhân viên:',
                      TextFormField(
                        controller: maController,
                        decoration: const InputDecoration(border: InputBorder.none),
                        enabled: false,
                      ),                      
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Họ và tên:',
                      TextFormField(
                        controller: tenController,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Số điện thoại:',
                      TextFormField(
                        controller: sdtController,
                        decoration: const InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'CCCD:',
                      TextFormField(
                        controller: cccdController,
                        decoration: const InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Tài khoản:',
                      TextFormField(
                        controller: tkController,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Vai trò:',
                      DropdownButton<String>(
                        value: selectedVaiTro,
                        isExpanded: true,
                        underline: Container(), // Bỏ đường gạch chân
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedVaiTro = newValue!;
                          });
                        },
                        items: vaiTroOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Mật khẩu:',
                      TextFormField(
                        controller: mkController,
                        decoration: const InputDecoration(border: InputBorder.none),
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _updateNhanVien(context),
                      child: const Text('Cập nhật'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}