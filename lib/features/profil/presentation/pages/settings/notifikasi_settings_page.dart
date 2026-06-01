import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_services/core_services.dart';

/// [NotifikasiSettingsPage] - Halaman pengaturan notifikasi.
class NotifikasiSettingsPage extends StatefulWidget {
  const NotifikasiSettingsPage({super.key});

  @override
  State<NotifikasiSettingsPage> createState() => _NotifikasiSettingsPageState();
}

class _NotifikasiSettingsPageState extends State<NotifikasiSettingsPage> {
  final StorageService _storage = StorageService.instance;
  final String _boxName = 'settings_box';

  bool _pengingatObat = true;
  bool _jadwalPemeriksaan = true;
  bool _tipsKesehatan = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final obat = await _storage.get<bool>(_boxName, 'notif_pengingat_obat');
    final pemeriksaan = await _storage.get<bool>(
      _boxName,
      'notif_jadwal_pemeriksaan',
    );
    final tips = await _storage.get<bool>(_boxName, 'notif_tips_kesehatan');

    if (mounted) {
      setState(() {
        // Default bernilai true jika belum pernah disimpan (kecuali tips)
        _pengingatObat = obat ?? true;
        _jadwalPemeriksaan = pemeriksaan ?? true;
        _tipsKesehatan = tips ?? false;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    await _storage.put(_boxName, key, value);
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
          'Notifikasi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionLabel('PENGINGAT MEDIS'),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          activeTrackColor: AppColors.primaryLight,
                          activeThumbColor: AppColors.primary,
                          title: const Text(
                            'Pengingat Minum Obat',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            'Terima notifikasi sesuai jadwal minum obat Anda',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          value: _pengingatObat,
                          onChanged: (val) {
                            setState(() {
                              _pengingatObat = val;
                            });
                            _saveSetting('notif_pengingat_obat', val);
                            // TODO: Implementasi logika mematikan jadwal notifikasi di OS
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          activeTrackColor: AppColors.primaryLight,
                          activeThumbColor: AppColors.primary,
                          title: const Text(
                            'Jadwal Pemeriksaan',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            'Pengingat H-1 sebelum jadwal kunjungan dokter',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          value: _jadwalPemeriksaan,
                          onChanged: (val) {
                            setState(() {
                              _jadwalPemeriksaan = val;
                            });
                            _saveSetting('notif_jadwal_pemeriksaan', val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionLabel('INFORMASI & TIPS'),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile(
                      activeTrackColor: AppColors.primaryLight,
                      activeThumbColor: AppColors.primary,
                      title: const Text(
                        'Tips Kesehatan & Artikel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        'Terima artikel harian tentang pemulihan TBC',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      value: _tipsKesehatan,
                      onChanged: (val) {
                        setState(() {
                          _tipsKesehatan = val;
                        });
                        _saveSetting('notif_tips_kesehatan', val);
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
