import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [NotifikasiSettingsPage] - Halaman pengaturan notifikasi.
class NotifikasiSettingsPage extends StatefulWidget {
  const NotifikasiSettingsPage({super.key});

  @override
  State<NotifikasiSettingsPage> createState() => _NotifikasiSettingsPageState();
}

class _NotifikasiSettingsPageState extends State<NotifikasiSettingsPage> {
  // State sederhana untuk switch (sementara belum terhubung ke database lokal)
  bool _pengingatObat = true;
  bool _jadwalPemeriksaan = true;
  bool _tipsKesehatan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionLabel('PENGINGAT MEDIS'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    title: const Text(
                      'Pengingat Minum Obat',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Text(
                      'Terima notifikasi sesuai jadwal minum obat Anda',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    value: _pengingatObat,
                    onChanged: (val) {
                      setState(() {
                        _pengingatObat = val;
                      });
                      // TODO: Implementasi logika mematikan jadwal notifikasi
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    title: const Text(
                      'Jadwal Pemeriksaan',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Text(
                      'Pengingat H-1 sebelum jadwal kunjungan dokter',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    value: _jadwalPemeriksaan,
                    onChanged: (val) {
                      setState(() {
                        _jadwalPemeriksaan = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('INFORMASI & TIPS'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                activeColor: AppColors.primary,
                title: const Text(
                  'Tips Kesehatan & Artikel',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: Text(
                  'Terima artikel harian tentang pemulihan TBC',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                value: _tipsKesehatan,
                onChanged: (val) {
                  setState(() {
                    _tipsKesehatan = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
