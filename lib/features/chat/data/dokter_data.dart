/// [Dokter] - Model data untuk informasi dokter.
///
/// Menyimpan informasi dokter spesialis yang tersedia
/// untuk konsultasi via WhatsApp.
class Dokter {
  /// Nama lengkap dokter beserta gelar.
  final String nama;

  /// Inisial nama untuk avatar (misal: "SR", "AF").
  final String inisial;

  /// Spesialisasi dokter (misal: "Paru & Pernapasan").
  final String spesialisasi;

  /// Rating dokter (skala 1.0 - 5.0).
  final double rating;

  /// Teks ketersediaan (misal: "Tersedia sekarang", "Tersedia 14:00").
  final String ketersediaan;

  /// Apakah dokter sedang online/tersedia saat ini.
  final bool isOnline;

  /// Nomor WhatsApp dokter (format internasional tanpa +).
  final String nomorWhatsApp;

  const Dokter({
    required this.nama,
    required this.inisial,
    required this.spesialisasi,
    required this.rating,
    required this.ketersediaan,
    required this.isOnline,
    required this.nomorWhatsApp,
  });
}

/// Daftar dokter yang tersedia untuk konsultasi.
///
/// Data statis sesuai desain UI. Pada implementasi produksi,
/// data ini akan diambil dari API backend.
const List<Dokter> daftarDokter = [
  Dokter(
    nama: 'Dr. Fajrul Fatih, Sp.P',
    inisial: 'FF',
    spesialisasi: 'Paru & Pernapasan',
    rating: 4.9,
    ketersediaan: 'Tersedia sekarang',
    isOnline: true,
    nomorWhatsApp: '6282143588735',
  ),
  Dokter(
    nama: 'Dr. Ahmad Fauzi, Sp.P',
    inisial: 'AF',
    spesialisasi: 'Paru — TBC Specialist',
    rating: 4.8,
    ketersediaan: 'Tersedia 14:00',
    isOnline: true,
    nomorWhatsApp: '628987654321',
  ),
];
