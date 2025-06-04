// File: lib/screens/SelectDishesScreen.dart
import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/services/MonAnService.dart';

class SelectDishesScreen extends StatefulWidget {
  final List<ChiTietGoiMon> initialSelectedDishes;

  const SelectDishesScreen({Key? key, required this.initialSelectedDishes}) : super(key: key);

  @override
  _SelectDishesScreenState createState() => _SelectDishesScreenState();
}

class _SelectDishesScreenState extends State<SelectDishesScreen> {
  final MonAnService _monAnService = MonAnService();
  final Map<String, int> _selectedQuantities = {}; // key: MonAn.ma, value: quantity
  final Map<String, MonAn> _monAnMap = {}; // Để lưu trữ đối tượng MonAn theo mã

  @override
  void initState() {
    super.initState();
    print("SelectDishesScreen initState started."); // Debug

    // Khởi tạo _selectedQuantities và _monAnMap từ dữ liệu ban đầu
    for (var ctgm in widget.initialSelectedDishes) {
      if (ctgm.getMonAn?.getMa != null && ctgm.getSoLuong != null) {
        _selectedQuantities[ctgm.getMonAn!.getMa!] = ctgm.getSoLuong!;
        _monAnMap[ctgm.getMonAn!.getMa!] = ctgm.getMonAn!;
        print("  - Initial selected: ${ctgm.getMonAn!.getTen} (Ma: ${ctgm.getMonAn!.getMa}), Qty: ${ctgm.getSoLuong}"); // Debug
      } else {
        print("  - Initial selected dish with null MonAn or quantity: ${ctgm.getMonAn?.getMa}"); // Debug
      }
    }
    print("Initial _selectedQuantities: $_selectedQuantities"); // Debug
    print("Initial _monAnMap keys: ${_monAnMap.keys}"); // Debug

    // Lắng nghe stream món ăn để cập nhật _monAnMap liên tục
    _monAnService.getAllMonAn().listen((monAnList) {
      bool changed = false;
      if (monAnList.length != _monAnMap.length) {
        changed = true;
      } else {
        // Kiểm tra xem có bất kỳ sự thay đổi nào về dữ liệu món ăn không
        for (var monAn in monAnList) {
          if (monAn.getMa != null && (_monAnMap[monAn.getMa!] == null || _monAnMap[monAn.getMa!]?.getTen != monAn.getTen || _monAnMap[monAn.getMa!]?.getGiaBan != monAn.getGiaBan)) {
            changed = true;
            break;
          }
        }
      }

      if (changed) {
        setState(() {
          _monAnMap.clear(); // Xóa map cũ
          for (var monAn in monAnList) {
            if (monAn.getMa != null) {
              _monAnMap[monAn.getMa!] = monAn; // Cập nhật map mới
            }
          }
          print("MonAn map updated from stream. New keys: ${_monAnMap.keys}"); // Debug
        });
      }
    }, onError: (e) {
      print("Error listening to MonAn stream in initState: $e"); // Debug lỗi stream
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn món ăn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              List<ChiTietGoiMon> result = [];
              _selectedQuantities.forEach((monAnMa, soLuong) {
                if (soLuong > 0) {
                  final monAn = _monAnMap[monAnMa]; // Lấy đối tượng MonAn thật từ map
                  if (monAn != null) {
                    result.add(ChiTietGoiMon(
                      monAn: monAn,
                      soLuong: soLuong,
                    ));
                  } else {
                    print("Lỗi: Không tìm thấy MonAn với mã $monAnMa trong _monAnMap khi trả về."); // Debug
                  }
                }
              });
              print("Returning selected dishes: ${result.map((ctgm) => "${ctgm.getMonAn?.getTen} x ${ctgm.getSoLuong}").join(', ')}"); // Debug
              Navigator.pop(context, result);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<MonAn>>(
        stream: _monAnService.getAllMonAn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("StreamBuilder: ConnectionState.waiting"); // Debug
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('StreamBuilder: Lỗi tải món ăn: ${snapshot.error}'); // Debug
            return Center(child: Text('Lỗi tải món ăn: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("StreamBuilder: Không có món ăn nào hoặc dữ liệu rỗng."); // Debug
            return const Center(child: Text('Không có món ăn nào trong thực đơn.'));
          }

          final dishes = snapshot.data!;
          print("StreamBuilder: Đã nhận ${dishes.length} món ăn."); // Debug
          return ListView.builder(
            itemCount: dishes.length,
            itemBuilder: (context, index) {
              final monAn = dishes[index];
              final String? monAnMa = monAn.getMa; // Lấy mã món ăn

              // Debug: In ra thông tin món ăn trước khi hiển thị
              print("  Rendering item: ${monAn.getTen} (Ma: $monAnMa, Gia: ${monAn.getGiaBan}, TinhTrang: ${monAn.getTinhTrang}, Anh: ${monAn.getHinhAnh})");

              int currentQuantity = 0;
              if (monAnMa != null) {
                 currentQuantity = _selectedQuantities[monAnMa] ?? 0;
                 print("    -> Current quantity for $monAnMa: $currentQuantity"); // Debug
              } else {
                print("    -> Cảnh báo: MonAn có tên '${monAn.getTen}' không có mã (getMa là null)."); // Debug
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(monAn.getHinhAnh != null && monAn.getHinhAnh!.isNotEmpty
                                ? monAn.getHinhAnh!
                                : 'https://via.placeholder.com/150'), // Placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(monAn.getTen ?? 'Món không tên', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('${monAn.getGiaBan?.toStringAsFixed(0) ?? '0'} VND', style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              print("Nút '-' được nhấn cho ${monAn.getTen} (Mã: $monAnMa)"); // Debug
                              if (monAnMa != null) {
                                setState(() {
                                  int qty = _selectedQuantities[monAnMa] ?? 0;
                                  if (qty > 0) {
                                    _selectedQuantities[monAnMa] = qty - 1;
                                  }
                                  if (_selectedQuantities[monAnMa] == 0) {
                                    _selectedQuantities.remove(monAnMa); // Xóa khỏi map nếu số lượng về 0
                                  }
                                  print("  -> Giảm. Số lượng mới cho ${monAn.getTen}: ${_selectedQuantities[monAnMa] ?? 0}"); // Debug
                                });
                              } else {
                                print("  -> Lỗi: Mã món ăn null khi nhấn nút '-'"); // Debug
                              }
                            },
                          ),
                          Text(currentQuantity.toString(), style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              print("Nút '+' được nhấn cho ${monAn.getTen} (Mã: $monAnMa)"); // Debug
                              if (monAnMa != null) {
                                setState(() {
                                  int qty = _selectedQuantities[monAnMa] ?? 0;
                                  _selectedQuantities[monAnMa] = qty + 1;
                                  print("  -> Tăng. Số lượng mới cho ${monAn.getTen}: ${_selectedQuantities[monAnMa]}"); // Debug
                                });
                              } else {
                                print("  -> Lỗi: Mã món ăn null khi nhấn nút '+'"); // Debug
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}