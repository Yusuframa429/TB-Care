import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../domain/entities/jadwal_obat.dart';
import '../../data/obat_repository.dart';
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
        if (_repo.getRiwayatStatus(dateKey, waktu)) {
          diminum++;
        }
      }
    }

    _total30Hari = total;
    _diminum30Hari = diminum;
    _persen30Hari = total == 0 ? 0 : (diminum * 100 ~/ total);
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Color _warnaSesi(String waktu) {
    final hour = int.tryParse(waktu.split(':')[0]) ?? 0;
    if (hour < 12) return AppColors.primary;
    if (hour < 17) return AppColors.info;
    return AppColors.warning;
  }

  String _namaSesi(String waktu) {
    final hour = int.tryParse(waktu.split(':')[0]) ?? 0;
    if (hour < 12) return 'Pagi';
    if (hour < 17) return 'Siang';
    return 'Malam';
  }

  Future<void> _editJadwal() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AturJadwalObatPage(isEditMode: true),
      ),
    );
    if (result == true && mounted) {
      final updatedList = _repo.getJadwalList();
      final updated = updatedList.where((j) => j.id == _jadwal.id).firstOrNull;
      if (updated != null) {
        setState(() => _jadwal = updated);
        _hitungStatistik();
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildSectionLabel('Waktu Minum'),
            const SizedBox(height: 10),
            _buildWaktuCard(),
            const SizedBox(height: 20),
            _buildSectionLabel('Informasi Umum'),
            const SizedBox(height: 10),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildSectionLabel('Pengaturan Pengingat'),
            const SizedBox(height: 10),
            _buildPengingatCard(),
            if (_jadwal.catatan != null && _jadwal.catatan!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionLabel('Catatan'),
              const SizedBox(height: 10),
              _buildCatatanCard(),
            ],
            const SizedBox(height: 20),
            _buildSectionLabel('Kepatuhan 30 Hari Terakhir'),
            const SizedBox(height: 10),
            _buildStatistikCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Detail Obat',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ),
      centerTitle: false,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.medication_rounded, color: AppColors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _jadwal.namaObat,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white, height: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_jadwal.jumlahDosis} ${_jadwal.satuanDosis}',
                  style: TextStyle(fontSize: 14, color: AppColors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _jadwal.isNotifikasiAktif ? 'Aktif' : 'Nonaktif',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaktuCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ..._jadwal.waktuMinum.asMap().entries.map((entry) {
            final i = entry.key;
            final waktu = entry.value;
            final isLast = i == _jadwal.waktuMinum.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _warnaSesi(waktu).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.access_time_filled_rounded, color: _warnaSesi(waktu), size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(waktu, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          Text(_namaSesi(waktu), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.repeat_rounded, iconColor: AppColors.primary, label: 'Frekuensi', value: _jadwal.frekuensi ?? 'Setiap hari'),
          const Divider(height: 20, color: AppColors.border),
          _InfoRow(icon: Icons.restaurant_rounded, iconColor: AppColors.warning, label: 'Kondisi Makan', value: _jadwal.kondisiMakan),
        ],
      ),
    );
  }

  Widget _buildPengingatCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _ToggleRow(icon: Icons.notifications_rounded, iconColor: AppColors.primary, label: 'Notifikasi', value: _jadwal.isNotifikasiAktif),
          if (_jadwal.isNotifikasiAktif) ...[
            const Divider(height: 20, color: AppColors.border),
            _ToggleRow(icon: Icons.vibration_rounded, iconColor: AppColors.warning, label: 'Getar (Vibration)', value: _jadwal.isGetar),
            const Divider(height: 20, color: AppColors.border),
            _ToggleRow(icon: Icons.volume_up_rounded, iconColor: AppColors.info, label: 'Suara (Sound)', value: _jadwal.isSuara),
          ],
        ],
      ),
    );
  }

  Widget _buildCatatanCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notes_rounded, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_jadwal.catatan!, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistikCard() {
    final persen = _persen30Hari;
    final label = persen >= 90 ? 'Baik Sekali' : persen >= 75 ? 'Baik' : persen >= 50 ? 'Cukup' : 'Perlu Ditingkatkan';
    final warna = persen >= 90 ? AppColors.primary : persen >= 75 ? AppColors.info : persen >= 50 ? AppColors.warning : AppColors.danger;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: persen / 100,
                    strokeWidth: 5,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(warna),
                  ),
                ),
                Text('$persen%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: warna)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: warna)),
                const SizedBox(height: 4),
                Text('$_diminum30Hari dari $_total30Hari dosis diminum', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _editJadwal,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Jadwal'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _hapusJadwal,
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Hapus'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;

  const _ToggleRow({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: value ? AppColors.primary : AppColors.border, borderRadius: BorderRadius.circular(6)),
          child: value ? const Icon(Icons.check, size: 14, color: AppColors.white) : null,
        ),
      ],
    );
  }
}
