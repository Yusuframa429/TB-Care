import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../features/beranda/presentation/pages/beranda_page.dart';
import '../../features/cek_ai/presentation/pages/cek_ai_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/obat/presentation/pages/obat_page.dart';
import '../../features/profil/presentation/pages/profil_page.dart';

/// [MainShell] - Widget utama yang membungkus seluruh halaman fitur
/// dan menyediakan bottom navigation bar.
///
/// Widget ini bertindak sebagai "shell" atau kerangka luar aplikasi.
/// Ia menyimpan daftar halaman ([_pages]) dan menampilkan halaman
/// sesuai indeks tab yang sedang aktif ([_currentIndex]).
///
/// Menggunakan [IndexedStack] agar state setiap halaman tetap
/// tersimpan saat berpindah tab (tidak di-rebuild dari awal).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Menyimpan indeks tab navbar yang sedang aktif.
  /// Default: 0 (Beranda).
  int _currentIndex = 0;

  /// Daftar halaman yang ditampilkan sesuai urutan item navbar.
  ///
  /// Urutan harus sesuai dengan urutan item di [TbCareBottomNavbar]:
  /// 0 = Beranda, 1 = Cek AI, 2 = Chat, 3 = Obat, 4 = Profil.
  final List<Widget> _pages = const [
    BerandaPage(),
    CekAiPage(),
    ChatPage(),
    ObatPage(),
    ProfilPage(),
  ];

  /// Callback yang dipanggil saat user menekan item navbar.
  ///
  /// Mengubah [_currentIndex] agar [IndexedStack] menampilkan
  /// halaman yang sesuai dengan tab yang dipilih.
  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// [IndexedStack] menampilkan satu child sesuai [_currentIndex],
      /// tetapi tetap mempertahankan state child lainnya di memori.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      /// Navbar custom dari package [core_ui].
      /// Ditempatkan di [bottomNavigationBar] agar menempel di bawah layar.
      bottomNavigationBar: TbCareBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
