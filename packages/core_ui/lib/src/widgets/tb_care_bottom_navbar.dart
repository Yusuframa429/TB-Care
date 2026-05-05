import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

/// [NavbarItem] - Model data untuk setiap item pada bottom navigation bar.
///
/// Berisi informasi ikon (aktif & tidak aktif) serta label teks
/// yang akan ditampilkan di bawah ikon.
class NavbarItem {
  /// Ikon yang ditampilkan saat item ini dalam keadaan aktif (terpilih).
  final IconData activeIcon;

  /// Ikon yang ditampilkan saat item ini dalam keadaan tidak aktif.
  final IconData inactiveIcon;

  /// Teks label yang muncul di bawah ikon.
  final String label;

  const NavbarItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

/// [TbCareBottomNavbar] - Widget custom bottom navigation bar untuk TB Care.
///
/// Widget ini menampilkan navbar dengan 5 menu utama sesuai desain:
/// Beranda, Cek AI, Chat, Obat, dan Profil.
///
/// Item yang sedang aktif ditandai dengan latar belakang berbentuk pill
/// berwarna hijau muda dan ikon/teks berwarna hijau.
///
/// Parameter:
/// - [currentIndex]: Indeks tab yang sedang aktif (0-4).
/// - [onTap]: Callback yang dipanggil ketika salah satu item ditekan.
///
/// Contoh penggunaan:
/// ```dart
/// TbCareBottomNavbar(
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
/// )
/// ```
class TbCareBottomNavbar extends StatelessWidget {
  /// Indeks item navbar yang sedang aktif saat ini (mulai dari 0).
  final int currentIndex;

  /// Callback fungsi yang akan dipanggil ketika user menekan salah satu item.
  /// Mengembalikan [int] berupa indeks item yang ditekan.
  final ValueChanged<int> onTap;

  const TbCareBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Daftar item navbar sesuai dengan desain UI TB Care.
  ///
  /// Urutan: Beranda, Cek AI, Chat, Obat, Profil.
  /// Menggunakan ikon dari FontAwesome agar tampilan lebih representatif
  /// (misalnya stetoskop untuk Cek AI, kapsul untuk Obat).
  static const List<NavbarItem> _items = [
    NavbarItem(
      activeIcon: FontAwesomeIcons.house,
      inactiveIcon: FontAwesomeIcons.house,
      label: 'Beranda',
    ),
    NavbarItem(
      activeIcon: FontAwesomeIcons.stethoscope,
      inactiveIcon: FontAwesomeIcons.stethoscope,
      label: 'Cek AI',
    ),
    NavbarItem(
      activeIcon: FontAwesomeIcons.commentDots,
      inactiveIcon: FontAwesomeIcons.commentDots,
      label: 'Chat',
    ),
    NavbarItem(
      activeIcon: FontAwesomeIcons.capsules,
      inactiveIcon: FontAwesomeIcons.capsules,
      label: 'Obat',
    ),
    NavbarItem(
      activeIcon: FontAwesomeIcons.user,
      inactiveIcon: FontAwesomeIcons.user,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      /// Dekorasi container navbar: background putih dengan shadow halus di atas
      /// dan border-radius melengkung di sudut atas agar terlihat modern.
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              return _buildNavItem(index);
            }),
          ),
        ),
      ),
    );
  }

  /// Membangun satu item navbar berdasarkan [index].
  ///
  /// Jika item sedang aktif ([isActive] = true), maka akan ditampilkan
  /// dengan background pill hijau muda dan teks/ikon berwarna hijau.
  /// Jika tidak aktif, ikon dan teks ditampilkan dalam warna abu-abu.
  Widget _buildNavItem(int index) {
    final item = _items[index];
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          /// Hanya item aktif yang mendapat latar belakang pill hijau muda.
          color: isActive ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              isActive ? item.activeIcon : item.inactiveIcon,
              size: 20,
              color: isActive ? AppColors.navbarActive : AppColors.navbarInactive,
            ),
            /// Label teks hanya ditampilkan saat item sedang aktif,
            /// memberikan efek expand/collapse yang elegan.
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: const TextStyle(
                  color: AppColors.navbarActive,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
