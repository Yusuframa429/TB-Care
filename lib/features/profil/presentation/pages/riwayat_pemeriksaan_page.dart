import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/riwayat_filter_chips.dart';
import '../widgets/riwayat_card.dart';

/// [RiwayatPemeriksaanPage] - Halaman riwayat pemeriksaan pengguna.
///
/// Menampilkan daftar riwayat pemeriksaan (AI Check dan Konsultasi)
/// dalam bentuk card list dengan filter chip untuk memilah jenis
/// pemeriksaan. Diakses dari menu "Riwayat Pemeriksaan" di halaman Profil.
///
/// Saat ini menggunakan data statis/dummy.
class RiwayatPemeriksaanPage extends StatefulWidget {
  const RiwayatPemeriksaanPage({super.key});

  @override
  State<RiwayatPemeriksaanPage> createState() =>
      _RiwayatPemeriksaanPageState();
}

class _RiwayatPemeriksaanPageState extends State<RiwayatPemeriksaanPage> {
  /// Filter yang sedang aktif.
  /// Nilai: 'Semua', 'AI Check', 'Konsultasi'.
  String _activeFilter = 'Semua';

  /// Data dummy riwayat pemeriksaan.
  final List<Map<String, dynamic>> _allRiwayat = const [
    {
      'type': 'AI Check',
      'date': '23 Apr 2026',
      'status': 'SEDANG',
      'description': '3/6 gejala terdeteksi',
      'actionLabel': 'Lihat Detail',
    },
    {
      'type': 'Konsultasi',
      'date': '20 Apr 2026',
      'status': 'Selesai',
      'description': 'Dr. Ahmad Fauzi',
      'actionLabel': 'Lihat Rekaman',
    },
    {
      'type': 'AI Check',
      'date': '5 Apr 2026',
      'status': 'RENDAH',
      'description': '1/6 gejala terdeteksi',
      'actionLabel': 'Lihat Detail',
    },
    {
      'type': 'Konsultasi',
      'date': '28 Mar 2026',
      'status': 'Selesai',
      'description': 'Dr. Siti Nurhaliza',
      'actionLabel': 'Lihat Rekaman',
    },
    {
      'type': 'AI Check',
      'date': '10 Mar 2026',
      'status': 'RENDAH',
      'description': '0/6 gejala terdeteksi',
      'actionLabel': 'Lihat Detail',
    },
  ];

  /// Mengembalikan list riwayat yang sudah difilter berdasarkan
  /// [_activeFilter].
  List<Map<String, dynamic>> get _filteredRiwayat {
    if (_activeFilter == 'Semua') return _allRiwayat;
    return _allRiwayat
        .where((item) => item['type'] == _activeFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Pemeriksaan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          /// Filter chips (Semua, AI Check, Konsultasi).
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 16,
            ),
            child: RiwayatFilterChips(
              activeFilter: _activeFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _activeFilter = filter;
                });
              },
            ),
          ),

          /// Daftar riwayat pemeriksaan.
          Expanded(
            child: _filteredRiwayat.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: _filteredRiwayat.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filteredRiwayat[index];
                      return RiwayatCard(
                        type: item['type'] as String,
                        date: item['date'] as String,
                        status: item['status'] as String,
                        description: item['description'] as String,
                        actionLabel: item['actionLabel'] as String,
                        onActionTap: () {
                          // TODO: Navigasi ke detail pemeriksaan.
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// State kosong ketika tidak ada riwayat yang sesuai filter.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat pemeriksaan',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
