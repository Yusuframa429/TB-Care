import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_services/core_services.dart';
import 'package:tb_care/main.dart';

/// [AksesibilitasSettingsPage] - Halaman pengaturan aksesibilitas.
class AksesibilitasSettingsPage extends StatefulWidget {
  const AksesibilitasSettingsPage({super.key});

  @override
  State<AksesibilitasSettingsPage> createState() =>
      _AksesibilitasSettingsPageState();
}

class _AksesibilitasSettingsPageState extends State<AksesibilitasSettingsPage> {
  final StorageService _storage = StorageService.instance;
  final String _boxName = 'settings_box';

  /// Faktor ukuran teks (1.0 = Normal, 1.2 = Besar, dst)
  double _textScale = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final scale = await _storage.get<double>(_boxName, 'text_scale_factor');
    if (mounted) {
      setState(() {
        _textScale = scale ?? 1.0;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSetting(double value) async {
    await _storage.put(_boxName, 'text_scale_factor', value);
    globalTextScaleNotifier.value = value;
  }

  String _getScaleLabel() {
    if (_textScale <= 0.8) return 'Kecil';
    if (_textScale <= 1.0) return 'Normal';
    if (_textScale <= 1.2) return 'Besar';
    return 'Ekstra Besar';
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
          'Aksesibilitas',
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
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ukuran Teks Aplikasi',
                    style: TextStyle(
                      fontSize: 14 * _textScale,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Contoh Ukuran Teks: ${_getScaleLabel()}',
                          style: TextStyle(
                            fontSize: 16 * _textScale,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Geser slider di bawah untuk mengatur ukuran teks agar lebih nyaman dibaca.',
                          style: TextStyle(
                            fontSize: 13 * _textScale,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text('A', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Slider(
                                value: _textScale,
                                min: 0.8,
                                max: 1.4,
                                divisions: 3,
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.primaryLight,
                                label: _getScaleLabel(),
                                onChanged: (val) {
                                  setState(() {
                                    _textScale = val;
                                  });
                                  _saveSetting(val);
                                },
                              ),
                            ),
                            const Text(
                              'A',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Catatan: Perubahan ukuran teks mungkin membutuhkan proses muat ulang aplikasi (restart) agar teraplikasi secara menyeluruh di seluruh halaman.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
