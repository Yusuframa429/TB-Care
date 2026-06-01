import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/obat/domain/entities/jadwal_obat.dart';

/// [NotificationService] - Service singleton untuk lokal notifikasi pengingat
/// minum obat menggunakan `flutter_local_notifications` + `timezone`.
///
/// ### Alur:
/// 1. Panggil [init] sekali di `main.dart` (sebelum `runApp`).
/// 2. Panggil [scheduleForJadwal] setiap kali jadwal obat disimpan/diubah
///    (dari [ObatRepository.simpanJadwal]).
/// 3. Panggil [cancelForJadwal] setiap kali jadwal obat dihapus
///    (dari [ObatRepository.hapusJadwal]).
///
/// Setiap jadwal akan membuat N notifikasi berulang harian (N = jumlah
/// waktu minum). ID notifikasi diturunkan dari `jadwal.id` + indeks waktu
/// agar unik dan bisa dibatalkan per-jadwal.
class NotificationService {
  // ── Singleton ────────────────────────────────────────────────
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ── Init ─────────────────────────────────────────────────────

  /// Inisialisasi plugin notifikasi dan timezone.
  ///
  /// - Menginisialisasi data timezone (untuk `zonedSchedule`).
  /// - Mengatur lokasi timezone lokal (default: Asia/Jakarta).
  /// - Mengatur settings inisialisasi Android & iOS.
  /// - Meminta permission (Android 13+ dan iOS).
  Future<void> init() async {
    if (_initialized) return;

    // 1. Inisialisasi data timezone (wajib untuk zonedSchedule).
    tz_data.initializeTimeZones();
    _setLocalTimezone();

    // 2. Settings inisialisasi Android.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // 3. Settings inisialisasi iOS (optional, jika platform iOS ada).
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 4. Inisialisasi plugin.
    await _plugin.initialize(
      initSettings,
      // payload handler saat notifikasi diketuk (untuk navigasi nanti).
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 5. Minta permission untuk Android 13+.
    await _requestPermissions();

    _initialized = true;
  }

  /// Mendeteksi dan menyetel timezone lokal.
  /// Default ke Asia/Jakarta untuk pengguna Indonesia.
  void _setLocalTimezone() {
    try {
      /// Coba deteksi dari offset UTC perangkat.
      final offset = DateTime.now().timeZoneOffset;
      String locationName;

      if (offset == const Duration(hours: 7)) {
        locationName = 'Asia/Jakarta'; // WIB
      } else if (offset == const Duration(hours: 8)) {
        locationName = 'Asia/Makassar'; // WITA
      } else if (offset == const Duration(hours: 9)) {
        locationName = 'Asia/Jayapura'; // WIT
      } else {
        // Fallback: gunakan nama timezone dari offset.
        // Contoh: UTC+7 → 'Etc/GMT-7' (tanda dibalik untuk Etc/GMT).
        final totalMinutes = offset.inMinutes;
        final hour = totalMinutes ~/ 60;
        final sign = hour >= 0 ? '-' : '+'; // Etc/GMT reversed sign
        locationName = 'Etc/GMT$sign${hour.abs()}';
      }

      tz.setLocalLocation(tz.getLocation(locationName));
    } catch (_) {
      // Fallback aman.
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }
  }

  /// Meminta permission notifikasi.
  Future<void> _requestPermissions() async {
    // Android 13+ (API 33+) butuh runtime permission.
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    // iOS permission.
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // ── Scheduling ───────────────────────────────────────────────

  /// Menjadwalkan notifikasi berulang harian untuk satu [jadwal].
  ///
  /// Untuk setiap waktu di [JadwalObat.waktuMinum], dibuat satu notifikasi
  /// berulang dengan [DateTimeComponents.time] agar muncul setiap hari
  /// pada jam yang sama.
  ///
  /// Hanya menjadwalkan jika [JadwalObat.isNotifikasiAktif] bernilai `true`.
  Future<void> scheduleForJadwal(JadwalObat jadwal) async {
    if (!_initialized) {
      // Jika service belum di-init, lewati dengan aman.
      return;
    }

    if (!jadwal.isNotifikasiAktif) {
      // Jika notifikasi non-aktif, batalkan yang sudah ada (jika ada).
      await cancelForJadwal(jadwal.id);
      return;
    }

    // Buat satu notifikasi per waktu minum.
    for (int i = 0; i < jadwal.waktuMinum.length; i++) {
      final timeStr = jadwal.waktuMinum[i];
      final parts = timeStr.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final int id = _notificationId(jadwal.id, i);
      final String title = 'Waktunya Minum Obat: ${jadwal.namaObat}';
      final String body = _buildBody(jadwal);

      final details = _buildNotificationDetails(jadwal);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(hour, minute),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // ── Cancellation ─────────────────────────────────────────────

  /// Membatalkan semua notifikasi yang terkait dengan [jadwalId].
  ///
  /// Membatalkan hingga 20 kemungkinan notifikasi per jadwal
  /// (cukup untuk jumlah waktu minum yang wajar).
  Future<void> cancelForJadwal(String jadwalId) async {
    for (int i = 0; i < 20; i++) {
      await _plugin.cancel(_notificationId(jadwalId, i));
    }
  }

  /// Membatalkan seluruh notifikasi yang pernah dijadwalkan.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Helpers ──────────────────────────────────────────────────

  /// Membangun body notifikasi sesuai format yang diminta:
  /// "Dosis: [JumlahDosis] [SatuanDosis] ([KondisiMakan]). [Catatan]"
  String _buildBody(JadwalObat jadwal) {
    final buffer = StringBuffer();
    buffer.write(
      'Dosis: ${jadwal.jumlahDosis} ${jadwal.satuanDosis} (${jadwal.kondisiMakan})',
    );
    if (jadwal.catatan != null && jadwal.catatan!.trim().isNotEmpty) {
      buffer.write('. ${jadwal.catatan!.trim()}');
    }
    return buffer.toString();
  }

  /// Membangun [NotificationDetails] dengan menyesuaikan pengaturan
  /// getar ([isGetar]) dan suara ([isSuara]) dari entity.
  NotificationDetails _buildNotificationDetails(JadwalObat jadwal) {
    final androidDetails = AndroidNotificationDetails(
      'obat_channel', // channel ID
      'Pengingat Obat', // channel name
      channelDescription: 'Notifikasi pengingat minum obat harian',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      // Kustomisasi getar & suara sesuai preferensi user.
      enableVibration: jadwal.isGetar,
      playSound: jadwal.isSuara,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: jadwal.isSuara,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  /// Menghitung ID notifikasi unik dari [jadwalId] dan [index].
  ///
  /// Menggunakan [Object.hash] yang menghasilkan int 32-bit,
  /// lalu di-mask dengan `0x7FFFFFFF` untuk memastikan positif.
  int _notificationId(String jadwalId, int index) {
    return Object.hash(jadwalId, index) & 0x7FFFFFFF;
  }

  /// Menghitung [TZDateTime] berikutnya untuk [hour]:[minute].
  ///
  /// Jika waktu hari ini sudah lewat, hitung untuk besok.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final location = tz.local;
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Handler saat user mengetuk notifikasi.
  /// Bisa dikembangkan untuk navigasi ke halaman obat.
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigasi ke halaman detail obat.
    // Payload bisa digunakan untuk membawa data.
    debugPrint('🔔 Notifikasi ditekan: payload=${response.payload}');
  }
}
