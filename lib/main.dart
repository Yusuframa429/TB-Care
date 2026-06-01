import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_services/core_services.dart';

import 'app/main_shell.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/obat/data/obat_repository.dart';

/// Notifier global untuk mengatur ukuran teks secara langsung (real-time) di seluruh aplikasi.
final ValueNotifier<double> globalTextScaleNotifier = ValueNotifier<double>(1.0);

/// Entry point aplikasi TB Care.
///
/// Fungsi [main] adalah titik masuk pertama yang dijalankan oleh
/// Flutter engine. Dari sini, seluruh widget tree aplikasi dibangun.
///
/// ⚡ Inisialisasi dilakukan secara berurutan:
/// 1. [WidgetsFlutterBinding.ensureInitialized] — binding Flutter engine.
/// 2. [StorageService] — penyimpanan lokal (SharedPreferences).
/// 3. [EnvService] — load variabel lingkungan dari `.env`.
/// 4. [ServiceLocator] — registrasi global services (AI, Network, dll).
/// 5. [NotificationService] — setup notifikasi lokal & scheduling.
/// 6. [ObatRepository] — muat data jadwal obat.
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // ── Inisialisasi Service Core ─────────────────────────────────
    await StorageService.instance.init();
    await EnvService.instance.init();

    // Registrasi Global Services ke ServiceLocator
    final sl = ServiceLocator.instance;
    sl.register<StorageService>(StorageService.instance);
    sl.register<EnvService>(EnvService.instance);
    sl.register<AIClient>(AIClient.instance);
    sl.register<NetworkService>(NetworkService());

    // ── Inisialisasi Fitur Notifikasi & Jadwal Obat ───────────────
    await NotificationService.instance.init();
    await ObatRepository.instance.init();

    // ── Ambil Pengaturan Aksesibilitas Terakhir ───────────────────
    final savedScale = await StorageService.instance.get<double>('settings_box', 'text_scale_factor');
    if (savedScale != null) {
      globalTextScaleNotifier.value = savedScale;
    }
    // ── Cek Sesi Login ───────────────────────────────────────────
    final String? currentUser = await StorageService.instance.get<String>('auth_box', 'current_user');
    final bool isLoggedIn = currentUser != null;

    runApp(TbCareApp(isLoggedIn: isLoggedIn));
  } catch (e, stacktrace) {
    debugPrint("FATAL ERROR IN MAIN: $e");
    debugPrint(stacktrace.toString());
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Text(
                'Aplikasi Gagal Dimuat:\n$e\n\n$stacktrace',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// [TbCareApp] - Widget root aplikasi TB Care.
///
/// Mengkonfigurasi [MaterialApp] dengan:
/// - Tema global dari [AppTheme.lightTheme] (didefinisikan di package core_ui).
/// - Halaman awal [MainShell] yang berisi navbar dan halaman-halaman fitur.
///
/// Widget ini bersifat [StatelessWidget] karena tidak memiliki
/// state internal yang berubah.
class TbCareApp extends StatelessWidget {
  final bool isLoggedIn;
  const TbCareApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: globalTextScaleNotifier,
      builder: (context, textScale, child) {
        return MaterialApp(
          title: 'TB Care',
          debugShowCheckedModeBanner: false,

          /// Menggunakan tema yang sudah dikonfigurasi di core_ui
          /// agar desain konsisten di seluruh aplikasi.
          theme: AppTheme.lightTheme,

          /// Meng-override ukuran teks dasar untuk seluruh aplikasi
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textScale),
              ),
              child: widget!,
            );
          },

          /// navbar dan halaman fitur di dalamnya.
          home: isLoggedIn ? const MainShell() : const LoginPage(),
        );
      },
    );
  }
}
