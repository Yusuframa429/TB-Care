import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_ui/core_ui.dart';

import '../../data/obat_repository.dart';
import '../../domain/entities/jadwal_obat.dart';

import '../widgets/waktu_minum_selector.dart';
import '../widgets/frekuensi_dropdown.dart';
import '../widgets/pengingat_toggle_group.dart';

/// [AturJadwalObatPage] - Halaman form untuk membuat atau mengedit jadwal obat.
///
/// Halaman ini menampilkan form lengkap sesuai desain Figma:
/// - Nama obat (wajib)
/// - Dosis (jumlah + satuan)
/// - Waktu minum (wajib) — dengan time picker dan kondisi makan
/// - Frekuensi
/// - Pengaturan pengingat (notifikasi, getar, suara)
/// - Catatan opsional
/// - Tombol "Simpan Jadwal"
///
/// Saat ini tampilan saja (data belum terhubung ke penyimpanan lokal).
///
/// Parameter:
/// - [isEditMode]: Jika `true`, form tampil dalam mode edit dengan data awal.
class AturJadwalObatPage extends StatefulWidget {
  /// Mode edit (true = sedang mengedit jadwal yang ada).
  final bool isEditMode;

  const AturJadwalObatPage({super.key, this.isEditMode = false});

  @override
  State<AturJadwalObatPage> createState() => _AturJadwalObatPageState();
}

class _AturJadwalObatPageState extends State<AturJadwalObatPage> {
  // --- Form key ---
  final _formKey = GlobalKey<FormState>();

  // --- Controllers ---
  final _namaObatController = TextEditingController();
  final _jumlahDosisController = TextEditingController();
  final _catatanController = TextEditingController();

  // --- State form ---
  String _satuanDosis = 'tablet';
  final List<TimeOfDay> _waktuMinumList = [];
  String _kondisiMakan = 'Sebelum makan';
  String _frekuensi = 'Setiap hari';

  // --- State pengingat ---
  bool _isNotifikasiAktif = true;
  bool _isGetar = true;
  bool _isSuara = false;

  /// Daftar pilihan satuan dosis.
  static const List<String> _satuanOptions = [
    'tablet',
    'kapsul',
    'ml',
    'sendok',
    'sachet',
  ];

  @override
  void dispose() {
    _namaObatController.dispose();
    _jumlahDosisController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  /// Dipanggil saat tombol "Simpan Jadwal" ditekan.
  /// Validasi form, simpan ke repository, lalu kembali ke halaman sebelumnya.
  Future<void> _simpanJadwal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_waktuMinumList.isEmpty) {
      _showErrorSnackbar('Tambahkan minimal satu waktu minum obat.');
      return;
    }

    // Konversi TimeOfDay list ke format string "HH:mm".
    final waktuStrings = _waktuMinumList.map((t) {
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }).toList();

    final jadwal = JadwalObat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      namaObat: _namaObatController.text.trim(),
      jumlahDosis: int.tryParse(_jumlahDosisController.text) ?? 1,
      satuanDosis: _satuanDosis,
      waktuMinum: waktuStrings,
      kondisiMakan: _kondisiMakan,
      frekuensi: _frekuensi,
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
      // ⚡ Kirim preferensi notifikasi dari toggle user.
      isNotifikasiAktif: _isNotifikasiAktif,
      isGetar: _isGetar,
      isSuara: _isSuara,
    );

    await ObatRepository.instance.simpanJadwal(jadwal);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Jadwal obat berhasil disimpan!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context, true);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            /// Field: Nama Obat (wajib).
            _buildFieldLabel('Nama Obat', isRequired: true),
            const SizedBox(height: 8),
            _buildNamaObatField(),
            const SizedBox(height: 20),

            /// Field: Dosis.
            _buildFieldLabel('Dosis'),
            const SizedBox(height: 8),
            _buildDosisRow(),
            const SizedBox(height: 20),

            /// Field: Waktu Minum (wajib).
            _buildFieldLabel('Waktu Minum', isRequired: true),
            const SizedBox(height: 8),
            WaktuMinumSelector(
              waktuList: _waktuMinumList,
              kondisiMakan: _kondisiMakan,
              onWaktuAdded: (time) {
                setState(() => _waktuMinumList.add(time));
              },
              onWaktuRemoved: (index) {
                setState(() => _waktuMinumList.removeAt(index));
              },
              onKondisiChanged: (kondisi) {
                setState(() => _kondisiMakan = kondisi);
              },
            ),
            const SizedBox(height: 20),

            /// Field: Frekuensi.
            _buildFieldLabel('Frekuensi'),
            const SizedBox(height: 8),
            FrekuensiDropdown(
              value: _frekuensi,
              onChanged: (val) {
                if (val != null) setState(() => _frekuensi = val);
              },
            ),
            const SizedBox(height: 20),

            /// Field: Pengingat.
            _buildFieldLabel('Pengingat'),
            const SizedBox(height: 8),
            PengingatToggleGroup(
              isNotifikasiAktif: _isNotifikasiAktif,
              isGetar: _isGetar,
              isSuara: _isSuara,
              onNotifikasiChanged: (val) =>
                  setState(() => _isNotifikasiAktif = val),
              onGetarChanged: (val) => setState(() => _isGetar = val),
              onSuaraChanged: (val) => setState(() => _isSuara = val),
            ),
            const SizedBox(height: 20),

            /// Field: Catatan (opsional).
            _buildFieldLabel('Catatan', isOptional: true),
            const SizedBox(height: 8),
            _buildCatatanField(),
            const SizedBox(height: 32),

            /// Tombol Simpan Jadwal.
            _buildSimpanButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// AppBar dengan tombol kembali dan judul.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.isEditMode ? 'Edit Jadwal Obat' : 'Atur Jadwal Obat',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: false,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    );
  }

  /// Label field dengan tanda wajib (*) atau opsional.
  Widget _buildFieldLabel(
    String label, {
    bool isRequired = false,
    bool isOptional = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
            ),
          ),
        ],
        if (isOptional) ...[
          const SizedBox(width: 6),
          Text(
            '(opsional)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  /// TextFormField untuk nama obat.
  Widget _buildNamaObatField() {
    return TextFormField(
      controller: _namaObatController,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: _buildInputDecoration(hintText: 'Contoh: Rifampicin'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama obat tidak boleh kosong';
        }
        return null;
      },
    );
  }

  /// Baris dosis: input jumlah + dropdown satuan.
  Widget _buildDosisRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Input jumlah dosis.
        Expanded(
          child: TextFormField(
            controller: _jumlahDosisController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: _buildInputDecoration(hintText: 'Jumlah'),
          ),
        ),
        const SizedBox(width: 12),

        /// Dropdown satuan dosis.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _satuanDosis,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              onChanged: (val) {
                if (val != null) setState(() => _satuanDosis = val);
              },
              items: _satuanOptions
                  .map(
                    (s) => DropdownMenuItem<String>(value: s, child: Text(s)),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// TextFormField untuk catatan opsional (multi-line).
  Widget _buildCatatanField() {
    return TextFormField(
      controller: _catatanController,
      maxLines: 4,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: _buildInputDecoration(hintText: 'Tambahkan catatan...'),
    );
  }

  /// Tombol utama "Simpan Jadwal".
  Widget _buildSimpanButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _simpanJadwal,
        icon: const Icon(Icons.save_rounded, size: 20),
        label: const Text(
          'Simpan Jadwal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  /// Dekorasi input field yang konsisten.
  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    );
  }
}
