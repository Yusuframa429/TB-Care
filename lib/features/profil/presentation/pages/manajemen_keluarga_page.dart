import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../data/models/family_member_model.dart';
import '../../data/repositories/family_repository.dart';

/// [ManajemenKeluargaPage] - Halaman untuk mengelola anggota keluarga dan
/// melakukan pergantian user aktif (User Switching).
class ManajemenKeluargaPage extends StatefulWidget {
  const ManajemenKeluargaPage({super.key});

  @override
  State<ManajemenKeluargaPage> createState() => _ManajemenKeluargaPageState();
}

class _ManajemenKeluargaPageState extends State<ManajemenKeluargaPage> {
  List<FamilyMemberModel> _allMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Memuat data anggota keluarga dari repository.
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final list = await FamilyRepository.instance.getMemberList();

    setState(() {
      _allMembers = list;
      _isLoading = false;
    });
  }

  /// Pemicu pergantian user aktif.
  Future<void> _switchUser(String id) async {
    await FamilyRepository.instance.setActiveMember(id);
    await _loadData();

    if (!mounted) return;

    // Tampilkan snackbar konfirmasi pergantian user
    final activeMember = _allMembers.firstWhere((m) => m.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil aktif berganti ke: ${activeMember.name}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Handler menghapus anggota keluarga.
  Future<void> _deleteMember(FamilyMemberModel member) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Anggota?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${member.name} dari daftar anggota keluarga Anda?',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FamilyRepository.instance.deleteMember(member.id);
      await _loadData();
    }
  }

  /// Menampilkan Form BottomSheet untuk menambah anggota baru.
  void _showAddMemberBottomSheet() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String relationship = 'Anak';
    int age = 0;

    final relationshipOptions = [
      'Ibu',
      'Ayah',
      'Adik',
      'Kakak',
      'Anak',
      'Suami',
      'Istri',
      'Lainnya',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tambah Anggota Keluarga',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tambahkan anggota keluarga untuk pemantauan bersama',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Input Nama
                      const Text(
                        'Nama Anggota',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama anggota',
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                        onChanged: (value) => name = value,
                      ),
                      const SizedBox(height: 16),

                      // Input Hubungan & Usia (Dua Kolom)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown Hubungan
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hubungan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: relationship,
                                      isExpanded: true,
                                      dropdownColor: AppColors.white,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.textSecondary,
                                      ),
                                      items: relationshipOptions
                                          .map(
                                            (opt) => DropdownMenuItem(
                                              value: opt,
                                              child: Text(
                                                opt,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setModalState(() {
                                            relationship = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Input Usia
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Usia (Tahun)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Contoh: 25',
                                    filled: true,
                                    fillColor: AppColors.background,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Usia wajib diisi';
                                    }
                                    final ageParsed = int.tryParse(value);
                                    if (ageParsed == null || ageParsed <= 0) {
                                      return 'Usia tidak valid';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    age = int.tryParse(value) ?? 0;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final newMember = FamilyMemberModel(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                name: name,
                                relationship: relationship,
                                age: age,
                                isActive: false,
                                // Random data stats untuk mempercantik data dummy baru
                                status: 'Pasien Aktif',
                                hariPengobatan: 0,
                                kepatuhanPersen: 100,
                                konsultasi: 0,
                              );

                              await FamilyRepository.instance.addMember(
                                newMember,
                              );
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              _loadData();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Simpan Anggota',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // Pisahkan user utama ("Saya") dengan anggota keluarga lainnya
    final ownerIndex = _allMembers.indexWhere((m) => m.id == 'owner');
    final FamilyMemberModel? owner = ownerIndex != -1
        ? _allMembers[ownerIndex]
        : null;
    final otherMembers = _allMembers.where((m) => m.id != 'owner').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Manajemen Keluarga',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Keterangan Subtitle
            const Text(
              'Kelola anggota keluarga untuk pemantauan kesehatan bersama',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            /// Bagian 1: Akun Utama ("Saya")
            if (owner != null) ...[
              InkWell(
                onTap: () => _switchUser(owner.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: owner.isActive
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border,
                      width: owner.isActive ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar BS
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A884), // Hijau toska yang cantik
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          owner.initials,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Info detail
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saya (${owner.name})',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Pemilik akun',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge Aktif
                      if (owner.isActive) _buildActiveBadge(),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            /// Bagian 2: Anggota Keluarga
            const Text(
              'ANGGOTA KELUARGA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            if (otherMembers.isEmpty) ...[
              // Tampilan jika anggota keluarga kosong
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada anggota keluarga terdaftar.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tambahkan anggota untuk memantau kesehatan mereka.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              // List Anggota Keluarga
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: otherMembers.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: AppColors.border,
                    ),
                    itemBuilder: (context, index) {
                      final member = otherMembers[index];
                      return InkWell(
                        onTap: () => _switchUser(member.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              // Avatar Bulat Slate Blue
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(
                                    0xFF5E6E82,
                                  ), // Slate Blue premium
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  member.initials,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Detail Nama & Relasi
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${member.relationship} · ${member.age} tahun',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Tanda Aktif / Arrow
                              if (member.isActive) ...[
                                _buildActiveBadge(),
                                const SizedBox(width: 8),
                              ] else ...[
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                              ],
                              // Tombol Hapus (Trash Soft Pink)
                              InkWell(
                                onTap: () => _deleteMember(member),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    color: AppColors.dangerLight,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.danger,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            /// Tombol Tambah Anggota
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _showAddMemberBottomSheet,
                icon: const Icon(Icons.add, color: AppColors.primary, size: 20),
                label: const Text(
                  'Tambah Anggota',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun Badge "● Aktif" berwarna hijau cantik
  Widget _buildActiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Color(0xFF27AE60), size: 8),
          SizedBox(width: 6),
          Text(
            'Aktif',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF27AE60),
            ),
          ),
        ],
      ),
    );
  }
}
