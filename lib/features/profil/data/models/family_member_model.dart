/// [FamilyMemberModel] - Model data untuk anggota keluarga.
class FamilyMemberModel {
  final String id;
  final String name;
  final String relationship;
  final int age;
  final bool isActive;
  final String status;
  final int hariPengobatan;
  final int kepatuhanPersen;
  final int konsultasi;

  FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.age,
    this.isActive = false,
    this.status = 'Pasien Aktif',
    this.hariPengobatan = 0,
    this.kepatuhanPersen = 100,
    this.konsultasi = 0,
  });

  /// Mendapatkan inisial nama (maksimal 2 karakter, contoh: "Budi Santoso" -> "BS").
  String get initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  /// Salin objek dengan beberapa field yang diubah.
  FamilyMemberModel copyWith({
    String? id,
    String? name,
    String? relationship,
    int? age,
    bool? isActive,
    String? status,
    int? hariPengobatan,
    int? kepatuhanPersen,
    int? konsultasi,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      age: age ?? this.age,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      hariPengobatan: hariPengobatan ?? this.hariPengobatan,
      kepatuhanPersen: kepatuhanPersen ?? this.kepatuhanPersen,
      konsultasi: konsultasi ?? this.konsultasi,
    );
  }

  /// Konversi dari JSON Map.
  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      age: json['age'] as int,
      isActive: json['isActive'] as bool? ?? false,
      status: json['status'] as String? ?? 'Pasien Aktif',
      hariPengobatan: json['hariPengobatan'] as int? ?? 0,
      kepatuhanPersen: json['kepatuhanPersen'] as int? ?? 100,
      konsultasi: json['konsultasi'] as int? ?? 0,
    );
  }

  /// Konversi ke JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'age': age,
      'isActive': isActive,
      'status': status,
      'hariPengobatan': hariPengobatan,
      'kepatuhanPersen': kepatuhanPersen,
      'konsultasi': konsultasi,
    };
  }
}
