import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/NhanSuScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class DetailNhanSu extends StatefulWidget {
  final NhanVien nhanVien;

  const DetailNhanSu({Key? key, required this.nhanVien}) : super(key: key);

  @override
  _DetailNhanSuState createState() => _DetailNhanSuState();
}

class _DetailNhanSuState extends State<DetailNhanSu> {
  // Controllers
  late TextEditingController maController;
  late TextEditingController tenController;
  late TextEditingController sdtController;
  late TextEditingController cccdController;
  late TextEditingController tkController;
  late TextEditingController mkController;
  late TextEditingController anhController;
  late TextEditingController ngayVLController;

  // State variables
  File? _image;
  String selectedVaiTro = '';
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final List<String> vaiTroOptions = ['Quản lý', 'Thu ngân', 'Phục vụ'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeState();
  }

  void _initializeControllers() {
    maController = TextEditingController(text: widget.nhanVien.ma);
    tenController = TextEditingController(text: widget.nhanVien.ten);
    sdtController = TextEditingController(text: widget.nhanVien.SDT);
    cccdController = TextEditingController(text: widget.nhanVien.CCCD);
    tkController = TextEditingController(text: widget.nhanVien.tk);
    mkController = TextEditingController(text: widget.nhanVien.mk);
    anhController = TextEditingController(text: widget.nhanVien.anh ?? '');
    ngayVLController = TextEditingController();
  }

  void _initializeState() {
    if (widget.nhanVien.ngayVL != null) {
      _selectedDate = widget.nhanVien.ngayVL!.toDate();
      ngayVLController.text = _dateFormat.format(_selectedDate!);
    }
    selectedVaiTro = widget.nhanVien.vaiTro.toString();
  }

  // Event Handlers
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        ngayVLController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _requestPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        _showSnackBar('Quyền truy cập vào thư viện ảnh bị từ chối', Colors.red);
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

  Future<void> _updateNhanVien() async {
    final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
    _showLoadingDialog();

    try {
      final Timestamp? ngayVLTimestamp = _selectedDate != null
          ? Timestamp.fromDate(_selectedDate!)
          : widget.nhanVien.ngayVL;

      final updatedNhanVien = NhanVien(
        id: widget.nhanVien.id,
        ma: maController.text,
        ten: tenController.text,
        SDT: sdtController.text,
        CCCD: cccdController.text,
        tk: tkController.text,
        mk: mkController.text,
        vaiTro: selectedVaiTro,
        anh: anhController.text.isNotEmpty ? anhController.text : null,
        ngayVL: ngayVLTimestamp,
      );

      await nhanSuProvider.updateNhanVien(updatedNhanVien);
      _showSnackBar('Cập nhật thành công', Colors.green);
      Navigator.pop(context);
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Lỗi khi cập nhật: $e', Colors.red);
    } finally {
      Navigator.pop(context); // Đóng loading dialog
    }
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text(
            'Xác nhận xóa',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Bạn có chắc chắn muốn xóa nhân viên này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            TextButton(
              onPressed: () => _handleDelete(),
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        ).animate().fade(duration: 300.ms).scale(duration: 300.ms, alignment: Alignment.center);
      },
    );
  }

  Future<void> _handleDelete() async {
    _showLoadingDialog();

    final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
    try {
      await nhanSuProvider.deleteNhanVien(widget.nhanVien.id!, widget.nhanVien.ma!);
      Navigator.pop(context); // Đóng loading
      Navigator.pop(context); // Đóng dialog xác nhận
      _showSnackBar('Xóa nhân viên thành công', Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NhanSuScreen()),
      );
    } catch (e) {
      Navigator.pop(context); // Đóng loading
      _showSnackBar('Lỗi khi xóa: $e', Colors.red);
    }
  }

  // UI Helpers
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
          Expanded(flex: 3, child: value),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
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
            onPressed: _showDeleteConfirmDialog,
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
                            : const AssetImage('assets/images/default.png'))
                            as ImageProvider,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() => selectedVaiTro = newValue!);
                        },
                        items: vaiTroOptions
                            .map<DropdownMenuItem<String>>((String value) {
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
                      onPressed: _updateNhanVien,
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

  @override
  void dispose() {
    maController.dispose();
    tenController.dispose();
    sdtController.dispose();
    cccdController.dispose();
    tkController.dispose();
    mkController.dispose();
    anhController.dispose();
    ngayVLController.dispose();
    super.dispose();
  }
}