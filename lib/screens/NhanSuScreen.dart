import 'package:doan_nhom_cuoiky/models/NhanVien.dart';
import 'package:doan_nhom_cuoiky/providers/NhanSuProvider.dart';
import 'package:doan_nhom_cuoiky/screens/NhanSu/AddNhanSuScreen.dart';
import 'package:flutter/material.dart';

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
    nhanViens = _nhanSuPro.nhanSu;
  }

  void _filterList() {
    if (search.text.isNotEmpty) {
      nhanViens
          .where(
            (element) =>
                element.ma == search.text || element.ten == search.text,
          )
          .toList();
    } else {
      nhanViens = _nhanSuPro.nhanSu;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nhân sự",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNhanSuScreen()),
              );
            },
            icon: Icon(Icons.add_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: "Tìm kiếm nhân viên",
              ),
              onChanged: (value) => _filterList,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Danh sách nhân sự",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.sort_by_alpha),
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: nhanViens.length,
                    itemBuilder:
                        (context, index) =>
                            NhanSuItemCard(nv: nhanViens[index]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NhanSuItemCard extends StatelessWidget {
  NhanVien? nv;
  NhanSuItemCard({super.key, required this.nv});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Color.fromRGBO(235, 235, 235, 1),
            strokeAlign: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(nv!.anh!)),
        title: Text(
          nv!.ten!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz_outlined),
        ),
      ),
    );
  }
}
