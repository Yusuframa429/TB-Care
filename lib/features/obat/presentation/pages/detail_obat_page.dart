import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../domain/entities/jadwal_obat.dart';
import '../../data/obat_repository.dart';
import '../widgets/detail_header_card.dart';
import '../widgets/detail_waktu_card.dart';
import '../widgets/detail_info_card.dart';
import '../widgets/detail_pengingat_card.dart';
import '../widgets/detail_catatan_card.dart';
import '../widgets/detail_statistik_card.dart';
import '../widgets/detail_action_buttons.dart';
import 'atur_jadwal_obat_page.dart';

/// [DetailObatPage] - Halaman detail lengkap satu jadwal obat.
class DetailObatPage extends StatefulWidget {
  final JadwalObat jadwal;

  const DetailObatPage({super.key, required this.jadwal});

  @override
  State<DetailObatPage> createState() => _DetailObatPageState();
}

class _DetailObatPageState extends State<DetailObatPage> {
  late JadwalObat _jadwal;
  final ObatRepository _repo = ObatRepository.instance;
  int _persen30Hari = 0;
  int _diminum30Hari = 0;
  int _total30Hari = 0;

  @override
  void initState() {
    super.initState();
    _jadwal = widget.jadwal;
    _hitungStatistik();
  }

  void _hitungStatistik() {
    final now = DateTime.now();
    int total = 0;
    int diminum = 0;
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = _dateKey(date);
      for (final waktu in _jadwal.waktuMinum) {
        total++;
        if (_repo.getRiwayatStatus(dateKey, waktu)) diminum++;
      }
    }
    _total30Hari = total;
    _diminum30Hari = diminum;
    _persen30Hari = total == 0 ? 0 : (diminum * 100 ~/ total);
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _editJadwal() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AturJadwalObatPage(isEditMode: true),
      ),
    );
    if (result == true && mounted) {
      final updated = _repo
          .getJadwalList()
          .where((j) => j.id == _jadwal.id)
          .firstOrNull;
      if (updated != null) {
        setState(() {
          _jadwal = updated;
          _hitungStatistik();
        });
      }
    }
  }

  Future<void> _hapusJadwal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Jadwal'),
        content: Text(
          'Yakin ingin menghapus jadwal "${_jadwal.namaObat}"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _repo.hapusJadwal(_jadwal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_jadwal.namaObat} berhasil dihapus'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    }
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
          'Detail Obat',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            DetailHeaderCard(
              namaObat: _jadwal.namaObat,
              dosisLabel: '${_jadwal.jumlahDosis} ${_jadwal.satuanDosis}',
              isNotifikasiAktif: _jadwal.isNotifikasiAktif,
            ),
            const SizedBox(height: 16),
            _sectionLabel('Waktu Minum'),
            const SizedBox(height: 10),
            DetailWaktuCard(waktuMinum: _jadwal.waktuMinum),
            const SizedBox(height: 20),
            _sectionLabel('Informasi Umum'),
            const SizedBox(height: 10),
            DetailInfoCard(
              frekuensi: _jadwal.frekuensi ?? 'Setiap hari',
              kondisiMakan: _jadwal.kondisiMakan,
            ),
            const SizedBox(height: 20),
            _sectionLabel('Pengaturan Pengingat'),
            const SizedBox(height: 10),
            DetailPengingatCard(
              isNotifikasiAktif: _jadwal.isNotifikasiAktif,
              isGetar: _jadwal.isGetar,
              isSuara: _jadwal.isSuara,
            ),
            if (_jadwal.catatan != null && _jadwal.catatan!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _sectionLabel('Catatan'),
              const SizedBox(height: 10),
              DetailCatatanCard(catatan: _jadwal.catatan!),
            ],
            const SizedBox(height: 20),
            _sectionLabel('Kepatuhan 30 Hari Terakhir'),
            const SizedBox(height: 10),
            DetailStatistikCard(
              persen: _persen30Hari,
              diminum: _diminum30Hari,
              total: _total30Hari,
            ),
            const SizedBox(height: 24),
            DetailActionButtons(onEdit: _editJadwal, onDelete: _hapusJadwal),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
