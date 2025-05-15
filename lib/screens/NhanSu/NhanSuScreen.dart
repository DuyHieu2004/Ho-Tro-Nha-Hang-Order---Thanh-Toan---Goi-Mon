import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/AddNhanSuScreen.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/ChiTietNhanSuScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NhanSuScreen extends StatefulWidget {
  const NhanSuScreen({super.key});

  @override
  State<NhanSuScreen> createState() => _NhanSuScreenState();
}

class _NhanSuScreenState extends State<NhanSuScreen> {
  List<NhanVien> nhanViens = [];
  final NhanSuProvider _nhanSuPro = NhanSuProvider();
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNhanSu();
  }

  Future<void> _loadNhanSu() async {
    setState(() {
      nhanViens = _nhanSuPro.nhanSu;
    });
  }

  void _searchList() {
    setState(() {
      if (search.text.isNotEmpty) {
        nhanViens = _nhanSuPro.nhanSu.where((element) =>
            element.ma!.toLowerCase().contains(search.text.toLowerCase()) ||
            element.ten!.toLowerCase().contains(search.text.toLowerCase())).toList();
      } else {
        nhanViens = _nhanSuPro.nhanSu;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Nhân sự", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNhanSuScreen()),
              );
              _loadNhanSu();
            },
            icon: const Icon(Icons.add_sharp),
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
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: "Tìm kiếm nhân viên",
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
              onChanged: (value) => _searchList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Danh sách nhân sự",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: _sortList,
                  icon: Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Theme.of(context).colorScheme.onSurface
                  ),
                  tooltip: _sortAscending ? 'Sắp xếp A-Z' : 'Sắp xếp Z-A',
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nhanViens.length,
                itemBuilder: (context, index) => NhanSuItemCard(
                  nv: nhanViens[index],
                  onRefresh: _loadNhanSu,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NhanSuItemCard extends StatelessWidget {
  final NhanVien? nv;
  final VoidCallback onRefresh;
  NhanSuItemCard({super.key, required this.nv, required this.onRefresh});

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin nhân viên'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(nv!.anh ?? 'https://via.placeholder.com/150'),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(context,'Mã nhân viên:', nv!.ma!),
                _buildInfoRow(context,'Họ và tên:', nv!.ten!),
                _buildInfoRow(context,'Số điện thoại:', nv!.SDT!),
                _buildInfoRow(context,'CCCD:', nv!.CCCD!),
                _buildInfoRow(context,'Tài khoản:', nv!.tk!),
                _buildInfoRow(context,'Vai trò:', nv!.vaiTro!.toString()),
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
                final nhanSuProvider = Provider.of<NhanSuProvider>(context, listen: false);
                try {
                  await nhanSuProvider.deleteNhanVien(nv!.ma!);
                  Navigator.pop(context);
                  onRefresh();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xóa thành công')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi xóa: $e')),
                  );
                }
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChiTietNhanSuScreen(nhanVien: nv!)),
                ).then((_) => onRefresh());
                Navigator.pop(context);
              },
              child: const Text('Chỉnh sửa'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context,String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundImage: NetworkImage(nv!.anh ?? 'https://via.placeholder.com/150'),
        ),
        title: Text(
          nv!.ten!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChiTietNhanSuScreen(nhanVien: nv!)),
            ).then((_) => onRefresh());
          },
          icon: Icon(Icons.more_horiz_outlined, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}