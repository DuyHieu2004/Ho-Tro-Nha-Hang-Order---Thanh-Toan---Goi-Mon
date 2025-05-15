import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:provider/provider.dart';

class ChiTietNhanSuScreen extends StatelessWidget {
  final NhanVien nhanVien;

  ChiTietNhanSuScreen({Key? key, required this.nhanVien}) : super(key: key);

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNhanVien(BuildContext context, NhanVien nhanVien) async {
    final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
    try {
      await nhanSuProvider.updateNhanVien(nhanVien);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
      Navigator.pop(context);
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
                final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
                try {
                  await nhanSuProvider.deleteNhanVien(nhanVien.ma!);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi xóa: $e')),
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
            icon: const Icon(Icons.delete, color: Colors.red),
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
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(nhanVien.anh ?? 'https://via.placeholder.com/150'),
                child: nhanVien.anh == null
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
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
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(nhanVien.anh ?? 'https://via.placeholder.com/150'),
                      child: nhanVien.anh == null
                          ? const Icon(Icons.person, size: 30, color: Colors.grey)
                          : null,
                    ),
                    const Divider(),
                    _buildInfoRow(context, 'Mã nhân viên:', nhanVien.ma!),
                    const Divider(),
                    _buildInfoRow(context, 'Họ và tên:', nhanVien.ten!),
                    const Divider(),
                    _buildInfoRow(context, 'Số điện thoại:', nhanVien.SDT!),
                    const Divider(),
                    _buildInfoRow(context, 'CCCD:', nhanVien.CCCD!),
                    const Divider(),
                    _buildInfoRow(context, 'Tài khoản:', nhanVien.tk!),
                    const Divider(),
                    _buildInfoRow(context, 'Vai trò:', nhanVien.vaiTro.toString()),
                    const Divider(),
                    _buildInfoRow(context, 'Mật khẩu:', nhanVien.mk!),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _updateNhanVien(context, nhanVien),
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