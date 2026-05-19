import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/jadwal_obat_card.dart';
import 'atur_jadwal_obat_page.dart';

/// [ObatPage] - Halaman manajemen jadwal obat TB Care.
///
/// Menampilkan daftar jadwal minum obat pengguna dalam bentuk card list.
/// User dapat menambah jadwal baru, mengedit, atau menghapus jadwal
/// yang sudah ada.
///
/// Saat ini menggunakan data dummy. Akan diganti dengan data
/// dari penyimpanan lokal (Hive) saat layer data sudah siap.
class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  /// Data dummy daftar jadwal obat.
  ///
  /// TODO: Ganti dengan data dari GetAllJadwal use case saat Hive siap.
  final List<Map<String, dynamic>> _daftarJadwal = [
    {
      'namaObat': 'Rifampicin',
      'dosis': '1 tablet / hari',
      'waktuMinum': ['08:00'],
      'frekuensi': 'Setiap hari',
      'kondisiMakan': 'Sebelum makan',
      'isAktif': true,
    },
    {
      'namaObat': 'Isoniazid',
      'dosis': '1 tablet / hari',
      'waktuMinum': ['08:00'],
      'frekuensi': 'Setiap hari',
      'kondisiMakan': 'Sebelum makan',
      'isAktif': true,
    },
    {
      'namaObat': 'Pyrazinamide',
      'dosis': '2 tablet / hari',
      'waktuMinum': ['08:00', '20:00'],
      'frekuensi': 'Setiap hari',
      'kondisiMakan': 'Saat makan',
      'isAktif': false,
    },
  ];

  /// Navigasi ke halaman form Atur Jadwal Obat.
  void _tambahJadwal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AturJadwalObatPage(),
      ),
    );
    // TODO: Setelah kembali, refresh daftar dari Hive.
  }

  /// Navigasi ke halaman form dalam mode edit.
  void _editJadwal(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AturJadwalObatPage(isEditMode: true),
      ),
    );
    // TODO: Kirimkan data jadwal yang akan diedit.
  }

  /// Konfirmasi dan hapus jadwal.
  void _hapusJadwal(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hapus Jadwal?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Jadwal obat "${_daftarJadwal[index]['namaObat']}" akan dihapus permanen.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _daftarJadwal.removeAt(index));
              // TODO: Panggil DeleteJadwal use case saat Hive siap.
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          /// Header halaman.
          _buildHeader(),

          /// Konten: list jadwal atau empty state.
          Expanded(
            child: _daftarJadwal.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: _daftarJadwal.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final jadwal = _daftarJadwal[index];
                      return JadwalObatCard(
                        namaObat: jadwal['namaObat'] as String,
                        dosis: jadwal['dosis'] as String,
                        waktuMinum:
                            List<String>.from(jadwal['waktuMinum'] as List),
                        frekuensi: jadwal['frekuensi'] as String,
                        kondisiMakan: jadwal['kondisiMakan'] as String,
                        isAktif: jadwal['isAktif'] as bool,
                        onEdit: () => _editJadwal(index),
                        onDelete: () => _hapusJadwal(index),
                      );
                    },
                  ),
          ),
        ],
      ),

      /// FAB untuk menambah jadwal baru.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahJadwal,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Jadwal',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Header hijau dengan judul dan ringkasan jadwal aktif.
  Widget _buildHeader() {
    final jadwalAktif = _daftarJadwal.where((j) => j['isAktif'] == true).length;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Jadwal Obat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildHeaderStat(
                    label: 'Total Jadwal',
                    value: '${_daftarJadwal.length}',
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderStat(
                    label: 'Aktif',
                    value: '$jadwalAktif',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget statistik kecil di dalam header.
  Widget _buildHeaderStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  /// Tampilan kosong saat belum ada jadwal.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medication_outlined,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Jadwal Obat',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan jadwal minum obat Anda\nagar tidak terlewat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

