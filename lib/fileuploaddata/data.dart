import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:doan_nhom_cuoiky/models/Ban.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/ChiTietViPham.dart';
import 'package:doan_nhom_cuoiky/models/HoaDon.dart';
import 'package:doan_nhom_cuoiky/models/VaiTro.dart';
import 'package:doan_nhom_cuoiky/models/ThucDon.dart';
import 'package:doan_nhom_cuoiky/models/MonAn.dart';
import 'package:doan_nhom_cuoiky/models/DonGoiMon.dart';
import 'package:doan_nhom_cuoiky/models/QuyDinhNhaHang.dart';
import 'package:doan_nhom_cuoiky/models/NhanVien.dart';

class DataGenerator {
  // Singleton pattern
  static final DataGenerator _instance = DataGenerator._internal();

  factory DataGenerator() {
    return _instance;
  }

  DataGenerator._internal();

  // Phương thức chính để tạo tất cả dữ liệu
  Future<void> generateAllData() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      // Tạo dữ liệu mẫu và đẩy lên Firestore
      await generateBanData();
      await generateVaiTroData();
      await generateNhanVienData();
      await generateThucDonData();
      await generateMonAnData();
      await generateDonGoiMonData();
      await generateChiTietGoiMonData();
      await generateHoaDonData();
      await generateQuyDinhNhaHangData();
      await generateChiTietViPhamData();

      print("Đã đẩy toàn bộ dữ liệu mẫu lên Firestore!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu: $e");
    }
  }

  // Phương thức kiểm tra document đã tồn tại chưa
  Future<bool> documentExists(String collection, String docId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
      return doc.exists;
    } catch (e) {
      print("Lỗi khi kiểm tra document $docId trong collection $collection: $e");
      return false;
    }
  }

  // 1. Tạo dữ liệu mẫu cho Ban
  Future<void> generateBanData() async {
    try {
      final CollectionReference banCollection = FirebaseFirestore.instance.collection('Ban');
      List<Ban> bans = [
        Ban(ma: "B001", viTri: "1", sucChua: 4, trangThai: "Trống"),
        Ban(ma: "B002", viTri: "2", sucChua: 6, trangThai: "Đang phục vụ"),
        Ban(ma: "B003", viTri: "3", sucChua: 2, trangThai: "Đã đặt"),
        Ban(ma: "B004", viTri: "4", sucChua: 8, trangThai: "Trống"),
        Ban(ma: "B005", viTri: "5", sucChua: 4, trangThai: "Đang phục vụ"),
        Ban(ma: "B006", viTri: "6", sucChua: 6, trangThai: "Trống"),
        Ban(ma: "B007", viTri: "7", sucChua: 10, trangThai: "Đã đặt"),
        Ban(ma: "B008", viTri: "8", sucChua: 4, trangThai: "Trống"),
        Ban(ma: "B009", viTri: "9", sucChua: 6, trangThai: "Đang phục vụ"),
        Ban(ma: "B010", viTri: "10", sucChua: 8, trangThai: "Trống"),
      ];

      int count = 0;
      for (var ban in bans) {
        bool exists = await documentExists('Ban', ban.ma!);
        if (!exists) {
          await banCollection.doc(ban.ma).set(ban.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho Ban!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu Ban: $e");
    }
  }

  // 2. Tạo dữ liệu mẫu cho VaiTro
  Future<void> generateVaiTroData() async {
    try {
      final CollectionReference vaiTroCollection = FirebaseFirestore.instance.collection('VaiTro');
      List<VaiTro> vaiTros = [
        VaiTro(ma: "QL001", ten: "Quản lý"),
        VaiTro(ma: "TN001", ten: "Thu ngân"),
        VaiTro(ma: "PV001", ten: "Phục vụ"),
        VaiTro(ma: "QL002", ten: "Quản lý"),
        VaiTro(ma: "TN002", ten: "Thu ngân"),
        VaiTro(ma: "PV002", ten: "Phục vụ"),
        VaiTro(ma: "QL003", ten: "Quản lý"),
        VaiTro(ma: "TN003", ten: "Thu ngân"),
        VaiTro(ma: "PV003", ten: "Phục vụ"),
        VaiTro(ma: "QL004", ten: "Quản lý"),
      ];

      int count = 0;
      for (var vaiTro in vaiTros) {
        bool exists = await documentExists('VaiTro', vaiTro.ma!);
        if (!exists) {
          await vaiTroCollection.doc(vaiTro.ma).set(vaiTro.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho VaiTro!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu VaiTro: $e");
    }
  }

  // 3. Tạo dữ liệu mẫu cho NhanVien
  Future<void> generateNhanVienData() async {
    try {
      final CollectionReference nhanVienCollection = FirebaseFirestore.instance.collection('NhanVien');
      List<NhanVien> nhanViens = [
        NhanVien(
          ma: "NV001",
          ten: "Nguyen Van A",
          SDT: "0901234567",
          CCCD: "123456789",
          tk: "nva@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "QL001", ten: "Quản lý"),
          anh: null,
        ),
        NhanVien(
          ma: "NV002",
          ten: "Tran Thi B",
          SDT: "0901234568",
          CCCD: "123456790",
          tk: "ttb@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "TN001", ten: "Thu ngân"),
          anh: null,
        ),
        NhanVien(
          ma: "NV003",
          ten: "Le Van C",
          SDT: "0901234569",
          CCCD: "123456791",
          tk: "lvc@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "PV001", ten: "Phục vụ"),
          anh: null,
        ),
        NhanVien(
          ma: "NV004",
          ten: "Pham Thi D",
          SDT: "0901234570",
          CCCD: "123456792",
          tk: "ptd@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "QL002", ten: "Quản lý"),
          anh: null,
        ),
        NhanVien(
          ma: "NV005",
          ten: "Hoang Van E",
          SDT: "0901234571",
          CCCD: "123456793",
          tk: "hve@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "TN002", ten: "Thu ngân"),
          anh: null,
        ),
        NhanVien(
          ma: "NV006",
          ten: "Nguyen Thi F",
          SDT: "0901234572",
          CCCD: "123456794",
          tk: "ntf@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "PV002", ten: "Phục vụ"),
          anh: null,
        ),
        NhanVien(
          ma: "NV007",
          ten: "Tran Van G",
          SDT: "0901234573",
          CCCD: "123456795",
          tk: "tvg@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "QL003", ten: "Quản lý"),
          anh: null,
        ),
        NhanVien(
          ma: "NV008",
          ten: "Le Thi H",
          SDT: "0901234574",
          CCCD: "123456796",
          tk: "lth@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "TN003", ten: "Thu ngân"),
          anh: null,
        ),
        NhanVien(
          ma: "NV009",
          ten: "Pham Van I",
          SDT: "0901234575",
          CCCD: "123456797",
          tk: "pvi@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "PV003", ten: "Phục vụ"),
          anh: null,
        ),
        NhanVien(
          ma: "NV010",
          ten: "Hoang Thi K",
          SDT: "0901234576",
          CCCD: "123456798",
          tk: "htk@example.com",
          mk: "123",
          vaiTro: VaiTro(ma: "QL004", ten: "Quản lý"),
          anh: null,
        ),
      ];

      int count = 0;
      for (var nhanVien in nhanViens) {
        bool exists = await documentExists('NhanVien', nhanVien.ma!);
        if (!exists) {
          await nhanVienCollection.doc(nhanVien.ma).set(nhanVien.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho NhanVien!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu NhanVien: $e");
    }
  }

  // 4. Tạo dữ liệu mẫu cho ThucDon
  Future<void> generateThucDonData() async {
    try {
      final CollectionReference thucDonCollection = FirebaseFirestore.instance.collection('ThucDon');
      List<ThucDon> thucDons = [
        ThucDon(ma: "TD001", ten: "Món khai vị"),
        ThucDon(ma: "TD002", ten: "Món chính"),
        ThucDon(ma: "TD003", ten: "Món tráng miệng"),
        ThucDon(ma: "TD004", ten: "Đồ uống"),
        ThucDon(ma: "TD005", ten: "Món ăn nhẹ"),
        ThucDon(ma: "TD006", ten: "Món đặc biệt"),
        ThucDon(ma: "TD007", ten: "Món chay"),
        ThucDon(ma: "TD008", ten: "Món nướng"),
        ThucDon(ma: "TD009", ten: "Món lẩu"),
        ThucDon(ma: "TD010", ten: "Món hấp"),
      ];

      int count = 0;
      for (var thucDon in thucDons) {
        bool exists = await documentExists('ThucDon', thucDon.getMa);
        if (!exists) {
          await thucDonCollection.doc(thucDon.getMa).set(thucDon.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho ThucDon!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu ThucDon: $e");
    }
  }

  // 5. Tạo dữ liệu mẫu cho MonAn
  Future<void> generateMonAnData() async {
    try {
      final CollectionReference monAnCollection = FirebaseFirestore.instance.collection('MonAn');
      List<MonAn> monAns = [
        MonAn(
          "MA001",
          "Gỏi ngó sen",
          50000,
          "Còn hàng",
          ThucDon(ma: "TD001", ten: "Món khai vị"),
          null,
        ),
        MonAn(
          "MA002",
          "Cơm chiên dương châu",
          70000,
          "Còn hàng",
          ThucDon(ma: "TD002", ten: "Món chính"),
          null,
        ),
        MonAn(
          "MA003",
          "Chè đậu đỏ",
          30000,
          "Còn hàng",
          ThucDon(ma: "TD003", ten: "Món tráng miệng"),
          null,
        ),
        MonAn(
          "MA004",
          "Nước cam",
          25000,
          "Còn hàng",
          ThucDon(ma: "TD004", ten: "Đồ uống"),
          null,
        ),
        MonAn(
          "MA005",
          "Khoai tây chiên",
          40000,
          "Còn hàng",
          ThucDon(ma: "TD005", ten: "Món ăn nhẹ"),
          null,
        ),
        MonAn(
          "MA006",
          "Bò lúc lắc",
          120000,
          "Còn hàng",
          ThucDon(ma: "TD006", ten: "Món đặc biệt"),
          null,
        ),
        MonAn(
          "MA007",
          "Đậu hũ chiên giòn",
          45000,
          "Còn hàng",
          ThucDon(ma: "TD007", ten: "Món chay"),
          null,
        ),
        MonAn(
          "MA008",
          "Gà nướng muối ớt",
          90000,
          "Còn hàng",
          ThucDon(ma: "TD008", ten: "Món nướng"),
          null,
        ),
        MonAn(
          "MA009",
          "Lẩu thái",
          200000,
          "Còn hàng",
          ThucDon(ma: "TD009", ten: "Món lẩu"),
          null,
        ),
        MonAn(
          "MA010",
          "Cá hấp gừng",
          150000,
          "Còn hàng",
          ThucDon(ma: "TD010", ten: "Món hấp"),
          null,
        ),
      ];

      int count = 0;
      for (var monAn in monAns) {
        bool exists = await documentExists('MonAn', monAn.getMa);
        if (!exists) {
          await monAnCollection.doc(monAn.getMa).set(monAn.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho MonAn!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu MonAn: $e");
    }
  }

  // 6. Tạo dữ liệu mẫu cho DonGoiMon
  Future<void> generateDonGoiMonData() async {
    try {
      final CollectionReference donGoiMonCollection = FirebaseFirestore.instance.collection('DonGoiMon');
      List<DonGoiMon> donGoiMons = [
        DonGoiMon(
          ma: "DGM001",
          ngayLap: DateTime(2025, 5, 15),
          trangThai: "Chờ",
          ghiChu: "Khách yêu cầu nhanh",
          maBan: Ban(ma: "B001", viTri: "1"),
        ),
        DonGoiMon(
          ma: "DGM002",
          ngayLap: DateTime(2025, 5, 15),
          trangThai: "Đã phục vụ",
          ghiChu: "",
          maBan: Ban(ma: "B002", viTri: "2"),
        ),
        DonGoiMon(
          ma: "DGM003",
          ngayLap: DateTime(2025, 5, 16),
          trangThai: "Chờ",
          ghiChu: "Không cay",
          maBan: Ban(ma: "B003", viTri: "3"),
        ),
        DonGoiMon(
          ma: "DGM004",
          ngayLap: DateTime(2025, 5, 16),
          trangThai: "Đã phục vụ",
          ghiChu: "",
          maBan: Ban(ma: "B004", viTri: "4"),
        ),
        DonGoiMon(
          ma: "DGM005",
          ngayLap: DateTime(2025, 5, 17),
          trangThai: "Chờ",
          ghiChu: "Thêm rau",
          maBan: Ban(ma: "B005", viTri: "5"),
        ),
        DonGoiMon(
          ma: "DGM006",
          ngayLap: DateTime(2025, 5, 17),
          trangThai: "Đã phục vụ",
          ghiChu: "",
          maBan: Ban(ma: "B006", viTri: "6"),
        ),
        DonGoiMon(
          ma: "DGM007",
          ngayLap: DateTime(2025, 5, 18),
          trangThai: "Chờ",
          ghiChu: "Khách VIP",
          maBan: Ban(ma: "B007", viTri: "7"),
        ),
        DonGoiMon(
          ma: "DGM008",
          ngayLap: DateTime(2025, 5, 18),
          trangThai: "Đã phục vụ",
          ghiChu: "",
          maBan: Ban(ma: "B008", viTri: "8"),
        ),
        DonGoiMon(
          ma: "DGM009",
          ngayLap: DateTime(2025, 5, 19),
          trangThai: "Chờ",
          ghiChu: "Không hành",
          maBan: Ban(ma: "B009", viTri: "9"),
        ),
        DonGoiMon(
          ma: "DGM010",
          ngayLap: DateTime(2025, 5, 19),
          trangThai: "Đã phục vụ",
          ghiChu: "",
          maBan: Ban(ma: "B010", viTri: "10"),
        ),
      ];

      int count = 0;
      for (var donGoiMon in donGoiMons) {
        bool exists = await documentExists('DonGoiMon', donGoiMon.ma!);
        if (!exists) {
          await donGoiMonCollection.doc(donGoiMon.ma).set(donGoiMon.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho DonGoiMon!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu DonGoiMon: $e");
    }
  }

  // 7. Tạo dữ liệu mẫu cho ChiTietGoiMon
  Future<void> generateChiTietGoiMonData() async {
    try {
      final CollectionReference chiTietGoiMonCollection = FirebaseFirestore.instance.collection('ChiTietGoiMon');
      List<ChiTietGoiMon> chiTietGoiMons = [
        ChiTietGoiMon(
          ma: "CTGM001",
          monAn: MonAn(
            "MA001",
            "Gỏi ngó sen",
            50000,
            "Còn hàng",
            ThucDon(ma: "TD001", ten: "Món khai vị"),
            null,
          ),
          soLuong: 2,
          maDonGoiMon: DonGoiMon(ma: "DGM001"),
        ),
        ChiTietGoiMon(
          ma: "CTGM002",
          monAn: MonAn(
            "MA002",
            "Cơm chiên dương châu",
            70000,
            "Còn hàng",
            ThucDon(ma: "TD002", ten: "Món chính"),
            null,
          ),
          soLuong: 3,
          maDonGoiMon: DonGoiMon(ma: "DGM002"),
        ),
        ChiTietGoiMon(
          ma: "CTGM003",
          monAn: MonAn(
            "MA003",
            "Chè đậu đỏ",
            30000,
            "Còn hàng",
            ThucDon(ma: "TD003", ten: "Món tráng miệng"),
            null,
          ),
          soLuong: 1,
          maDonGoiMon: DonGoiMon(ma: "DGM003"),
        ),
        ChiTietGoiMon(
          ma: "CTGM004",
          monAn: MonAn(
            "MA004",
            "Nước cam",
            25000,
            "Còn hàng",
            ThucDon(ma: "TD004", ten: "Đồ uống"),
            null,
          ),
          soLuong: 4,
          maDonGoiMon: DonGoiMon(ma: "DGM004"),
        ),
        ChiTietGoiMon(
          ma: "CTGM005",
          monAn: MonAn(
            "MA005",
            "Khoai tây chiên",
            40000,
            "Còn hàng",
            ThucDon(ma: "TD005", ten: "Món ăn nhẹ"),
            null,
          ),
          soLuong: 2,
          maDonGoiMon: DonGoiMon(ma: "DGM005"),
        ),
        ChiTietGoiMon(
          ma: "CTGM006",
          monAn: MonAn(
            "MA006",
            "Bò lúc lắc",
            120000,
            "Còn hàng",
            ThucDon(ma: "TD006", ten: "Món đặc biệt"),
            null,
          ),
          soLuong: 1,
          maDonGoiMon: DonGoiMon(ma: "DGM006"),
        ),
        ChiTietGoiMon(
          ma: "CTGM007",
          monAn: MonAn(
            "MA007",
            "Đậu hũ chiên giòn",
            45000,
            "Còn hàng",
            ThucDon(ma: "TD007", ten: "Món chay"),
            null,
          ),
          soLuong: 3,
          maDonGoiMon: DonGoiMon(ma: "DGM007"),
        ),
        ChiTietGoiMon(
          ma: "CTGM008",
          monAn: MonAn(
            "MA008",
            "Gà nướng muối ớt",
            90000,
            "Còn hàng",
            ThucDon(ma: "TD008", ten: "Món nướng"),
            null,
          ),
          soLuong: 2,
          maDonGoiMon: DonGoiMon(ma: "DGM008"),
        ),
        ChiTietGoiMon(
          ma: "CTGM009",
          monAn: MonAn(
            "MA009",
            "Lẩu thái",
            200000,
            "Còn hàng",
            ThucDon(ma: "TD009", ten: "Món lẩu"),
            null,
          ),
          soLuong: 1,
          maDonGoiMon: DonGoiMon(ma: "DGM009"),
        ),
        ChiTietGoiMon(
          ma: "CTGM010",
          monAn: MonAn(
            "MA010",
            "Cá hấp gừng",
            150000,
            "Còn hàng",
            ThucDon(ma: "TD010", ten: "Món hấp"),
            null,
          ),
          soLuong: 2,
          maDonGoiMon: DonGoiMon(ma: "DGM010"),
        ),
      ];

      int count = 0;
      for (var chiTietGoiMon in chiTietGoiMons) {
        bool exists = await documentExists('ChiTietGoiMon', chiTietGoiMon.getMa);
        if (!exists) {
          await chiTietGoiMonCollection.doc(chiTietGoiMon.getMa).set(chiTietGoiMon.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho ChiTietGoiMon!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu ChiTietGoiMon: $e");
    }
  }

  // 8. Tạo dữ liệu mẫu cho HoaDon
  Future<void> generateHoaDonData() async {
    try {
      final CollectionReference hoaDonCollection = FirebaseFirestore.instance.collection('HoaDon');
      List<HoaDon> hoaDons = [
        HoaDon(
          ma: "HD001", 
          nhanVien: NhanVien(
            ma: "NV001",
            ten: "Nguyen Van A",
            SDT: "0901234567",
            CCCD: "123456789",
            tk: "nva@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "QL001", ten: "Quản lý"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 15), 
          tongTien: 100000, 
          maDGM: DonGoiMon(ma: "DGM001", maBan: Ban(ma: "B001", viTri: "1"))
        ),
        HoaDon(
          ma: "HD002", 
          nhanVien: NhanVien(
            ma: "NV002",
            ten: "Tran Thi B",
            SDT: "0901234568",
            CCCD: "123456790",
            tk: "ttb@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "TN001", ten: "Thu ngân"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 15), 
          tongTien: 210000, 
          maDGM: DonGoiMon(ma: "DGM002", maBan: Ban(ma: "B002", viTri: "2"))
        ),
        HoaDon(
          ma: "HD003", 
          nhanVien: NhanVien(
            ma: "NV003",
            ten: "Le Van C",
            SDT: "0901234569",
            CCCD: "123456791",
            tk: "lvc@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "PV001", ten: "Phục vụ"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 16), 
          tongTien: 30000, 
          maDGM: DonGoiMon(ma: "DGM003", maBan: Ban(ma: "B003", viTri: "3"))
        ),
        HoaDon(
          ma: "HD004", 
          nhanVien: NhanVien(
            ma: "NV004",
            ten: "Pham Thi D",
            SDT: "0901234570",
            CCCD: "123456792",
            tk: "ptd@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "QL002", ten: "Quản lý"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 16), 
          tongTien: 100000, 
          maDGM: DonGoiMon(ma: "DGM004", maBan: Ban(ma: "B004", viTri: "4"))
        ),
        HoaDon(
          ma: "HD005", 
          nhanVien: NhanVien(
            ma: "NV005",
            ten: "Hoang Van E",
            SDT: "0901234571",
            CCCD: "123456793",
            tk: "hve@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "TN002", ten: "Thu ngân"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 17), 
          tongTien: 80000, 
          maDGM: DonGoiMon(ma: "DGM005", maBan: Ban(ma: "B005", viTri: "5"))
        ),
        HoaDon(
          ma: "HD006", 
          nhanVien: NhanVien(
            ma: "NV006",
            ten: "Nguyen Thi F",
            SDT: "0901234572",
            CCCD: "123456794",
            tk: "ntf@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "PV002", ten: "Phục vụ"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 17), 
          tongTien: 120000, 
          maDGM: DonGoiMon(ma: "DGM006", maBan: Ban(ma: "B006", viTri: "6"))
        ),
        HoaDon(
          ma: "HD007", 
          nhanVien: NhanVien(
            ma: "NV007",
            ten: "Tran Van G",
            SDT: "0901234573",
            CCCD: "123456795",
            tk: "tvg@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "QL003", ten: "Quản lý"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 18), 
          tongTien: 135000, 
          maDGM: DonGoiMon(ma: "DGM007", maBan: Ban(ma: "B007", viTri: "7"))
        ),
        HoaDon(
          ma: "HD008", 
          nhanVien: NhanVien(
            ma: "NV008",
            ten: "Le Thi H",
            SDT: "0901234574",
            CCCD: "123456796",
            tk: "lth@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "TN003", ten: "Thu ngân"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 18), 
          tongTien: 180000, 
          maDGM: DonGoiMon(ma: "DGM008", maBan: Ban(ma: "B008", viTri: "8"))
        ),
        HoaDon(
          ma: "HD009", 
          nhanVien: NhanVien(
            ma: "NV009",
            ten: "Pham Van I",
            SDT: "0901234575",
            CCCD: "123456797",
            tk: "pvi@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "PV003", ten: "Phục vụ"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 19), 
          tongTien: 200000, 
          maDGM: DonGoiMon(ma: "DGM009", maBan: Ban(ma: "B009", viTri: "9"))
        ),
        HoaDon(
          ma: "HD010", 
          nhanVien: NhanVien(
            ma: "NV010",
            ten: "Hoang Thi K",
            SDT: "0901234576",
            CCCD: "123456798",
            tk: "htk@example.com",
            mk: "123",
            vaiTro: VaiTro(ma: "QL004", ten: "Quản lý"),
            anh: null,
          ), 
          ngayThanhToan: DateTime(2025, 5, 19), 
          tongTien: 300000, 
          maDGM: DonGoiMon(ma: "DGM010", maBan: Ban(ma: "B010", viTri: "10"))
        ),
      ];

      int count = 0;
      for (var hoaDon in hoaDons) {
        bool exists = await documentExists('HoaDon', hoaDon.ma!);
        if (!exists) {
          await hoaDonCollection.doc(hoaDon.ma).set(hoaDon.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho HoaDon!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu HoaDon: $e");
    }
  }

  // 9. Tạo dữ liệu mẫu cho QuyDinhNhaHang
  Future<void> generateQuyDinhNhaHangData() async {
    try {
      final CollectionReference quyDinhCollection = FirebaseFirestore.instance.collection('QuyDinhNhaHang');
      List<QuyDinhNhaHang> quyDinhs = [
        QuyDinhNhaHang("QD001", "Hủy đơn không báo trước", 50000),
        QuyDinhNhaHang("QD002", "Gây rối tại nhà hàng", 100000),
        QuyDinhNhaHang("QD003", "Không thanh toán đúng hạn", 20000),
        QuyDinhNhaHang("QD004", "Hút thuốc trong khu vực cấm", 70000),
        QuyDinhNhaHang("QD005", "Mang đồ ăn ngoài vào", 30000),
        QuyDinhNhaHang("QD006", "Phá hoại tài sản", 150000),
        QuyDinhNhaHang("QD007", "Không tuân thủ nội quy", 40000),
        QuyDinhNhaHang("QD008", "Đặt bàn không đến", 60000),
        QuyDinhNhaHang("QD009", "Gây tiếng ồn lớn", 50000),
        QuyDinhNhaHang("QD010", "Không đeo khẩu trang", 20000),
      ];

      int count = 0;
      for (var quyDinh in quyDinhs) {
        bool exists = await documentExists('QuyDinhNhaHang', quyDinh.ma!);
        if (!exists) {
          await quyDinhCollection.doc(quyDinh.ma).set(quyDinh.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho QuyDinhNhaHang!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu QuyDinhNhaHang: $e");
    }
  }

  // 10. Tạo dữ liệu mẫu cho ChiTietViPham
  Future<void> generateChiTietViPhamData() async {
    try {
      final CollectionReference chiTietViPhamCollection = FirebaseFirestore.instance.collection('ChiTietViPham');
      List<ChiTietViPham> chiTietViPhams = [
        ChiTietViPham(
          ma: "CTVP001",
          hoaDon: HoaDon(
            ma: "HD001",
            nhanVien: NhanVien(
              ma: "NV001",
              ten: "Nguyen Van A",
              SDT: "0901234567",
              CCCD: "123456789",
              tk: "nva@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "QL001", ten: "Quản lý"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 15),
            tongTien: 100000,
            maDGM: DonGoiMon(ma: "DGM001"),
          ),
          maVP: QuyDinhNhaHang("QD001", "Hủy đơn không báo trước", 50000),
        ),
        ChiTietViPham(
          ma: "CTVP002",
          hoaDon: HoaDon(
            ma: "HD002",
            nhanVien: NhanVien(
              ma: "NV002",
              ten: "Tran Thi B",
              SDT: "0901234568",
              CCCD: "123456790",
              tk: "ttb@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "TN001", ten: "Thu ngân"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 15),
            tongTien: 210000,
            maDGM: DonGoiMon(ma: "DGM002"),
          ),
          maVP: QuyDinhNhaHang("QD002", "Gây rối tại nhà hàng", 100000),
        ),
        ChiTietViPham(
          ma: "CTVP003",
          hoaDon: HoaDon(
            ma: "HD003",
            nhanVien: NhanVien(
              ma: "NV003",
              ten: "Le Van C",
              SDT: "0901234569",
              CCCD: "123456791",
              tk: "lvc@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "PV001", ten: "Phục vụ"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 16),
            tongTien: 30000,
            maDGM: DonGoiMon(ma: "DGM003"),
          ),
          maVP: QuyDinhNhaHang("QD003", "Không thanh toán đúng hạn", 20000),
        ),
        ChiTietViPham(
          ma: "CTVP004",
          hoaDon: HoaDon(
            ma: "HD004",
            nhanVien: NhanVien(
              ma: "NV004",
              ten: "Pham Thi D",
              SDT: "0901234570",
              CCCD: "123456792",
              tk: "ptd@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "QL002", ten: "Quản lý"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 16),
            tongTien: 100000,
            maDGM: DonGoiMon(ma: "DGM004"),
          ),
          maVP: QuyDinhNhaHang("QD004", "Hút thuốc trong khu vực cấm", 70000),
        ),
        ChiTietViPham(
          ma: "CTVP005",
          hoaDon: HoaDon(
            ma: "HD005",
            nhanVien: NhanVien(
              ma: "NV005",
              ten: "Hoang Van E",
              SDT: "0901234571",
              CCCD: "123456793",
              tk: "hve@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "TN002", ten: "Thu ngân"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 17),
            tongTien: 80000,
            maDGM: DonGoiMon(ma: "DGM005"),
          ),
          maVP: QuyDinhNhaHang("QD005", "Mang đồ ăn ngoài vào", 30000),
        ),
        ChiTietViPham(
          ma: "CTVP006",
          hoaDon: HoaDon(
            ma: "HD006",
            nhanVien: NhanVien(
              ma: "NV006",
              ten: "Nguyen Thi F",
              SDT: "0901234572",
              CCCD: "123456794",
              tk: "ntf@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "PV002", ten: "Phục vụ"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 17),
            tongTien: 120000,
            maDGM: DonGoiMon(ma: "DGM006"),
          ),
          maVP: QuyDinhNhaHang("QD006", "Phá hoại tài sản", 150000),
        ),
        ChiTietViPham(
          ma: "CTVP007",
          hoaDon: HoaDon(
            ma: "HD007",
            nhanVien: NhanVien(
              ma: "NV007",
              ten: "Tran Van G",
              SDT: "0901234573",
              CCCD: "123456795",
              tk: "tvg@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "QL003", ten: "Quản lý"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 18),
            tongTien: 135000,
            maDGM: DonGoiMon(ma: "DGM007"),
          ),
          maVP: QuyDinhNhaHang("QD007", "Không tuân thủ nội quy", 40000),
        ),
        ChiTietViPham(
          ma: "CTVP008",
          hoaDon: HoaDon(
            ma: "HD008",
            nhanVien: NhanVien(
              ma: "NV008",
              ten: "Le Thi H",
              SDT: "0901234574",
              CCCD: "123456796",
              tk: "lth@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "TN003", ten: "Thu ngân"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 18),
            tongTien: 180000,
            maDGM: DonGoiMon(ma: "DGM008"),
          ),
          maVP: QuyDinhNhaHang("QD008", "Đặt bàn không đến", 60000),
        ),
        ChiTietViPham(
          ma: "CTVP009",
          hoaDon: HoaDon(
            ma: "HD009",
            nhanVien: NhanVien(
              ma: "NV009",
              ten: "Pham Van I",
              SDT: "0901234575",
              CCCD: "123456797",
              tk: "pvi@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "PV003", ten: "Phục vụ"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 19),
            tongTien: 200000,
            maDGM: DonGoiMon(ma: "DGM009"),
          ),
          maVP: QuyDinhNhaHang("QD009", "Gây tiếng ồn lớn", 50000),
        ),
        ChiTietViPham(
          ma: "CTVP010",
          hoaDon: HoaDon(
            ma: "HD010",
            nhanVien: NhanVien(
              ma: "NV010",
              ten: "Hoang Thi K",
              SDT: "0901234576",
              CCCD: "123456798",
              tk: "htk@example.com",
              mk: "123",
              vaiTro: VaiTro(ma: "QL004", ten: "Quản lý"),
              anh: null,
            ),
            ngayThanhToan: DateTime(2025, 5, 19),
            tongTien: 300000,
            maDGM: DonGoiMon(ma: "DGM010"),
          ),
          maVP: QuyDinhNhaHang("QD010", "Không đeo khẩu trang", 20000),
        ),
      ];

      int count = 0;
      for (var chiTietViPham in chiTietViPhams) {
        bool exists = await documentExists('ChiTietViPham', chiTietViPham.ma!);
        if (!exists) {
          await chiTietViPhamCollection.doc(chiTietViPham.ma).set(chiTietViPham.toMap());
          count++;
        }
      }
      print("Đã đẩy $count dữ liệu mẫu mới cho ChiTietViPham!");
    } catch (e) {
      print("Lỗi khi tạo dữ liệu ChiTietViPham: $e");
    }
  }
  
  // Phương thức để kiểm tra kết nối Firebase
  Future<bool> checkFirebaseConnection() async {
    try {
      // Thử kết nối đến Firestore
      await FirebaseFirestore.instance.collection('test').get();
      print("Kết nối Firebase thành công!");
      return true;
    } catch (e) {
      print("Lỗi kết nối Firebase: $e");
      return false;
    }
  }
  
  // Phương thức để xóa tất cả dữ liệu (dùng cho mục đích test)
  Future<void> clearAllData() async {
    try {
      final collections = [
        'Ban', 'VaiTro', 'NhanVien', 'ThucDon', 'MonAn', 
        'DonGoiMon', 'ChiTietGoiMon', 'HoaDon', 
        'QuyDinhNhaHang', 'ChiTietViPham'
      ];
      
      for (var collection in collections) {
        final querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        print("Đã xóa dữ liệu collection $collection");
      }
      
      print("Đã xóa tất cả dữ liệu!");
    } catch (e) {
      print("Lỗi khi xóa dữ liệu: $e");
    }
  }
}
