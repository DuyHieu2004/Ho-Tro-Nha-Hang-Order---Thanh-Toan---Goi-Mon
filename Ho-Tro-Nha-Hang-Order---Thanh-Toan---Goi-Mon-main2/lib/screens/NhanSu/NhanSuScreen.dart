import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/AddNhanSuScreen.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/DetailNhanSuScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doan_nhom_cuoiky/main.dart';

class NhanSuScreen extends StatefulWidget {
  const NhanSuScreen({super.key});

  @override
  State<NhanSuScreen> createState() => _NhanSuScreenState();
}

class _NhanSuScreenState extends State<NhanSuScreen> {
  List<NhanVien> nhanViens = [];
  TextEditingController search = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNhanSu();
    });
  }

  Future<void> _loadNhanSu() async {
    setState(() {
      _isLoading = true;
    });
    
    final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
    
    setState(() {
      nhanViens = nhanSuProvider.nhanSu;
      _isLoading = false;
    });
  }

  void _searchList() {
    setState(() {
      if (search.text.isNotEmpty) {
        nhanViens =
            nhanViens
                .where(
                  (element) =>
                      element.ma!.toLowerCase().contains(
                        search.text.toLowerCase(),
                      ) ||
                      element.ten!.toLowerCase().contains(
                        search.text.toLowerCase(),
                      ),
                )
                .toList();
      } else {
        _loadNhanSu();
      }
    });
  }

  bool _sortAscending = true;

  void _sortList() {
    setState(() {
      nhanViens.sort((a, b) {
        if (_sortAscending) {
          return (a.ten ?? '').compareTo(b.ten ?? '');
        } else {
          return (b.ten ?? '').compareTo(a.ten ?? '');
        }
      });
      _sortAscending = !_sortAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NhanSuProvider>(
      builder: (context, nhanSuProvider, child) {
        if (nhanViens.isEmpty && nhanSuProvider.nhanSu.isNotEmpty) {
          nhanViens = nhanSuProvider.nhanSu;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Nhân sự",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNhanSuScreen(),
                    ),
                  );
                  if (result == true) {
                    _loadNhanSu();
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              children: [
                TextField(
                  controller: search,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    hintText: "Tìm kiếm nhân viên",
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  onChanged: (value) => _searchList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Danh sách nhân sự",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: _sortList,
                      icon: Icon(
                        _sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      tooltip: _sortAscending ? 'Sắp xếp A-Z' : 'Sắp xếp Z-A',
                    ),
                  ],
                ),
                Expanded(
                  child:
                      nhanViens.isEmpty
                          ? Center(child: Text('Không có nhân viên nào'))
                          : ListView.builder(
                            itemCount: nhanViens.length,
                            itemBuilder:
                                (context, index) => NhanSuItemCard(
                                  nv: nhanViens[index],
                                  onRefresh: _loadNhanSu,
                                ),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NhanSuItemCard extends StatelessWidget {
  final NhanVien? nv;
  final VoidCallback onRefresh;
  const NhanSuItemCard({super.key, required this.nv, required this.onRefresh});

  void _showDetailDialog(BuildContext context) {
    if (nv == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông tin nhân viên'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    (
                          (nv?.anh != null && nv!.anh!.isNotEmpty)
                        ? NetworkImage(nv!.anh!)
                            :
                        AssetImage('assets/images/default.png')

                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(context, 'Mã nhân viên:', nv?.ma ?? 'Không có'),
                _buildInfoRow(context, 'Họ và tên:', nv?.ten ?? 'Không có'),
                _buildInfoRow(context, 'Số điện thoại:', nv?.SDT ?? 'Không có'),
                _buildInfoRow(context, 'CCCD:', nv?.CCCD ?? 'Không có'),
                _buildInfoRow(context, 'Tài khoản:', nv?.tk ?? 'Không có'),
                _buildInfoRow(
                  context,
                  'Vai trò:',
                  nv?.vaiTro?.toString() ?? 'Không có',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                if (nv?.ma == null) return;

                // Hiển thị loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                final nhanSuProvider = Provider.of<NhanSuProvider>(
                  context,
                  listen: false,
                );
                try {
                  await nhanSuProvider.deleteNhanVien(nv!);
                  Navigator.pop(context); // Đóng loading
                  Navigator.pop(context); // Đóng dialog chi tiết
                  onRefresh(); // Refresh danh sách
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xóa thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context); // Đóng loading
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
            TextButton(
              onPressed: () async {
                if (nv?.ma == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailNhanSu(nhanVien: nv!),
                  ),
                ).then((_) => onRefresh());
              },
              child: const Text(
                'Chỉnh sửa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu nv là null thì trả về một widget trống
    if (nv == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            strokeAlign: 1,
          ),
        ),
      ),
      child: ListTile(
        onTap: () => _showDetailDialog(context),
        leading: CircleAvatar(
          backgroundImage:
          ( nv!.anh != null && nv!.anh!.isNotEmpty
              ? NetworkImage(nv!.anh!)
              : const AssetImage('assets/images/default.png')) as ImageProvider,
        ),
        title: Text(
          nv?.ten ?? 'Không có tên',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        subtitle: Text(
          nv?.vaiTro.toString() ?? '',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (nv == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailNhanSu(nhanVien: nv!),
                  ),
                ).then((_) => onRefresh());
              },
              icon: Icon(
                Icons.more_horiz_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}