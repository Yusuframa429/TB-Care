import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/riwayat_filter_chips.dart';
import '../widgets/riwayat_card.dart';

import '../../data/models/riwayat_pemeriksaan_model.dart';
import '../../data/repositories/riwayat_pemeriksaan_repository.dart';
import '../../../cek_ai/presentation/pages/hasil_pemeriksaan_page.dart';

/// [RiwayatPemeriksaanPage] - Halaman riwayat pemeriksaan pengguna.
///
/// Menampilkan daftar riwayat pemeriksaan (AI Check dan Konsultasi)
/// dalam bentuk card list dengan filter chip untuk memilah jenis
/// pemeriksaan. Diakses dari menu "Riwayat Pemeriksaan" di halaman Profil.
///
/// Data dimuat secara dinamis dari database lokal (SharedPreferences).
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

  /// Daftar riwayat pemeriksaan dari database lokal.
  List<RiwayatPemeriksaanModel> _allRiwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  /// Muat data riwayat pemeriksaan secara asinkron.
  Future<void> _loadRiwayat() async {
    setState(() {
      _isLoading = true;
    });

    final list = await RiwayatPemeriksaanRepository.instance.getRiwayatList();

    setState(() {
      _allRiwayat = list;
      _isLoading = false;
    });
  }

  /// Mengembalikan list riwayat yang sudah difilter berdasarkan
  /// [_activeFilter].
  List<RiwayatPemeriksaanModel> get _filteredRiwayat {
    if (_activeFilter == 'Semua') return _allRiwayat;
    return _allRiwayat
        .where((item) => item.type == _activeFilter)
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : _filteredRiwayat.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadRiwayat,
                        color: AppColors.primary,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount: _filteredRiwayat.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _filteredRiwayat[index];
                            return RiwayatCard(
                              type: item.type,
                              date: item.formattedDate,
                              status: item.status,
                              description: item.description,
                              actionLabel: item.actionLabel,
                              onActionTap: () {
                                if (item.type == 'AI Check') {
                                  // Rekonstruksi hasil skrining AI ke entitas asli
                                  final result = item.toScreeningResult();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HasilPemeriksaanPage(result: result),
                                    ),
                                  );
                                } else if (item.type == 'Konsultasi') {
                                  // Berikan feedback konsultasi dokter
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Detail rekaman konsultasi dengan ${item.description}'),
                                      backgroundColor: AppColors.primary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
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
