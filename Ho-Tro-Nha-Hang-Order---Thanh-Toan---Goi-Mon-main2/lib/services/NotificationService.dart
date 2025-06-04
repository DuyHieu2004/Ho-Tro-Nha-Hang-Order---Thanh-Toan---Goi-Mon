import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/DonDatCho.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Khởi tạo timezone
    tz.initializeTimeZones();

    // Khởi tạo Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Khởi tạo iOS settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Khởi tạo settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Khởi tạo plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        // Xử lý khi người dùng nhấn vào thông báo
      },
    );

    // Yêu cầu quyền thông báo trên Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
  }

  // Lên lịch thông báo cho đơn đặt chỗ trước 30 phút
  Future<void> scheduleReservationNotification(DonDatCho donDatCho) async {
    if (donDatCho.ngayDat == null) return;

    // Tính thời gian thông báo (trước 30 phút)
    final scheduledTime = tz.TZDateTime.from(
      donDatCho.ngayDat!.subtract(const Duration(minutes: 30)),
      tz.local,
    );

    // Kiểm tra nếu thời gian thông báo đã qua
    final now = tz.TZDateTime.now(tz.local);
    if (scheduledTime.isBefore(now)) return;

    // Tạo chi tiết thông báo cho Android
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'reservation_channel',
          'Đơn đặt chỗ',
          channelDescription: 'Thông báo về đơn đặt chỗ',
          importance: Importance.max,
          priority: Priority.high,
        );

    // Tạo chi tiết thông báo cho iOS
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    // Tạo chi tiết thông báo
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // Lên lịch thông báo
    await flutterLocalNotificationsPlugin.zonedSchedule(
      donDatCho.ma.hashCode, // ID thông báo
      'Sắp có khách đặt chỗ',
      'Khách hàng ${donDatCho.tenKhachHang} sẽ đến trong 30 phút nữa. SĐT: ${donDatCho.soDienThoai}',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Hủy thông báo
  Future<void> cancelReservationNotification(String donDatChoId) async {
    await flutterLocalNotificationsPlugin.cancel(donDatChoId.hashCode);
  }
}
