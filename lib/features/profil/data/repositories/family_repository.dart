import 'dart:convert';
import 'package:core_services/core_services.dart';

import '../models/family_member_model.dart';

/// [FamilyRepository] - Repository untuk mengelola data anggota keluarga & status aktif user.
class FamilyRepository {
  // ── Singleton ──────────────────────────────────────────────
  static final FamilyRepository instance = FamilyRepository._();
  FamilyRepository._();

  // ── Storage Keys ───────────────────────────────────────────
  static const String _boxName = 'hive_family_management';
  static const String _keyMemberList = 'family_member_list';

  // ── Services ───────────────────────────────────────────────
  final StorageService _storage = StorageService.instance;

  // ── In-Memory Cache ────────────────────────────────────────
  List<FamilyMemberModel> _members = [];
  bool _initialized = false;

  /// Dapatkan list anggota keluarga secara langsung.
  List<FamilyMemberModel> get members => List.unmodifiable(_members);

  /// Inisialisasi repository. Memuat data dari Hive lokal atau membuat data default.
  Future<void> init() async {
    if (_initialized) return;

    final membersStr = await _storage.get<String>(_boxName, _keyMemberList);
    if (membersStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(membersStr) as List;
        _members = decoded
            .map((item) => FamilyMemberModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _loadDefaultData();
      }
    } else {
      await _loadDefaultData();
    }

    _initialized = true;
  }

  /// Memuat data bawaan/default sesuai dengan mockup.
  Future<void> _loadDefaultData() async {
    _members = [
      FamilyMemberModel(
        id: 'owner',
        name: 'Budi Santoso',
        relationship: 'Saya',
        age: 45,
        isActive: true,
        status: 'Pasien Aktif',
        hariPengobatan: 14,
        kepatuhanPersen: 96,
        konsultasi: 3,
      ),
      FamilyMemberModel(
        id: 'ibu',
        name: 'Ibu',
        relationship: 'Ibu',
        age: 65,
        isActive: false,
        status: 'Dalam Pengawasan',
        hariPengobatan: 28,
        kepatuhanPersen: 100,
        konsultasi: 1,
      ),
      FamilyMemberModel(
        id: 'adik',
        name: 'Adik',
        relationship: 'Adik',
        age: 22,
        isActive: false,
        status: 'Sehat/Pencegahan',
        hariPengobatan: 0,
        kepatuhanPersen: 100,
        konsultasi: 0,
      ),
    ];
    await _saveToStorage();
  }

  /// Simpan list anggota ke penyimpanan lokal.
  Future<void> _saveToStorage() async {
    final String encoded = jsonEncode(_members.map((item) => item.toJson()).toList());
    await _storage.put(_boxName, _keyMemberList, encoded);
  }

  /// Mendapatkan seluruh daftar anggota keluarga.
  Future<List<FamilyMemberModel>> getMemberList() async {
    await init();
    return _members;
  }

  /// Mendapatkan anggota keluarga yang sedang aktif saat ini.
  Future<FamilyMemberModel> getActiveMember() async {
    await init();
    return _members.firstWhere(
      (m) => m.isActive,
      orElse: () => _members.first,
    );
  }

  /// Mengubah pengguna aktif berdasarkan [id].
  Future<void> setActiveMember(String id) async {
    await init();
    _members = _members.map((m) {
      return m.copyWith(isActive: m.id == id);
    }).toList();
    await _saveToStorage();
  }

  /// Menambahkan anggota keluarga baru.
  Future<void> addMember(FamilyMemberModel member) async {
    await init();
    _members.add(member);
    await _saveToStorage();
  }

  /// Menghapus anggota keluarga berdasarkan [id].
  Future<void> deleteMember(String id) async {
    await init();
    
    // Jika anggota yang dihapus sedang aktif, pindahkan status aktif ke owner
    final wasActive = _members.any((m) => m.id == id && m.isActive);
    
    _members.removeWhere((m) => m.id == id);

    if (wasActive && _members.isNotEmpty) {
      await setActiveMember('owner');
    } else {
      await _saveToStorage();
    }
  }
}
