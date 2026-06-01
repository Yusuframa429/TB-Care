import 'package:flutter/material.dart';
import '../domain/entities/artikel.dart';

// ╔══════════════════════════════════════════════════════════════════╗
// ║  PANDUAN MENAMBAH ARTIKEL BARU                                  ║
// ║                                                                  ║
// ║  1. Tambah item baru ke list [artikelList] di bawah.            ║
// ║  2. Isi semua field: judul, deskripsi, imageUrl, kategori,      ║
// ║     linkArtikel, tanggalPublikasi, waktuBacaMenit.              ║
// ║  3. Jika kategori BARU, tambahkan juga ke [kategoriStyles].    ║
// ║  4. Badge "Baru" muncul otomatis untuk artikel ≤ 7 hari.       ║
// ╚══════════════════════════════════════════════════════════════════╝

/// Style warna untuk badge kategori artikel.
class KategoriStyle {
  final Color color;
  final Color bgColor;
  const KategoriStyle({required this.color, required this.bgColor});
}

/// Daftar style kategori yang tersedia.
///
/// Untuk menambah kategori baru, cukup tambahkan entry baru di sini.
/// Filter chip akan otomatis muncul di halaman Edukasi.
final Map<String, KategoriStyle> kategoriStyles = {
  'Pencegahan': const KategoriStyle(
    color: Color(0xFF0D9488),
    bgColor: Color(0xFFCCFBF1),
  ),
  'Nutrisi': const KategoriStyle(
    color: Color(0xFF27AE60),
    bgColor: Color(0xFFE8F8F0),
  ),
  'Gaya Hidup': const KategoriStyle(
    color: Color(0xFF7C3AED),
    bgColor: Color(0xFFF3E8FF),
  ),
  'Obat': const KategoriStyle(
    color: Color(0xFF2563EB),
    bgColor: Color(0xFFDBEAFE),
  ),
};

/// Daftar artikel edukasi & berita.
///
/// Developer: Cukup tambah/hapus/edit item di list ini.
/// Halaman edukasi akan otomatis menampilkan data terbaru.
final List<Artikel> artikelList = [
  // ── Artikel 1 ─────────────────────────────────────────────
  Artikel(
    judul: 'Mengenal TBC: Gejala & Cara Pencegahan Dini',
    deskripsi:
        'Kenali tanda-tanda TBC sejak dini untuk penanganan yang tepat dan efektif di rumah',
    imageUrl:
        'https://images.alodokter.com/dk0z4ums3/image/upload/v1595912411/attached_image/tuberkulosis-0-alodokter.jpg',
    kategori: 'Pencegahan',
    linkArtikel: 'https://www.alodokter.com/tuberkulosis',
    tanggalPublikasi: DateTime(2026, 5, 18),
    waktuBacaMenit: 3,
  ),

  // ── Artikel 2 ─────────────────────────────────────────────
  Artikel(
    judul: 'Pola Makan Sehat Saat Pengobatan TBC',
    deskripsi:
        'Nutrisi yang tepat dapat membantu proses pemulihan dan meningkatkan efektivitas pengobatan',
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&h=400&fit=crop',
    kategori: 'Nutrisi',
    linkArtikel: 'https://tbindonesia.or.id/informasi/tentang-tbc/nutrisi-tbc/',
    tanggalPublikasi: DateTime(2026, 5, 15),
    waktuBacaMenit: 5,
  ),

  // ── Artikel 3 ─────────────────────────────────────────────
  Artikel(
    judul: 'Pentingnya Olahraga Ringan Selama Pengobatan',
    deskripsi:
        'Aktivitas fisik ringan dapat mempercepat pemulihan dan meningkatkan kualitas hidup pasien TBC',
    imageUrl:
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=400&fit=crop',
    kategori: 'Gaya Hidup',
    linkArtikel: 'https://tbindonesia.or.id/informasi/tentang-tbc/gaya-hidup/',
    tanggalPublikasi: DateTime(2026, 5, 10),
    waktuBacaMenit: 4,
  ),

  // ── Artikel 4 ─────────────────────────────────────────────
  Artikel(
    judul: 'Cara Minum Obat TBC yang Benar',
    deskripsi:
        'Panduan lengkap waktu, dosis, dan aturan minum obat TBC agar pengobatan berjalan optimal',
    imageUrl:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&h=400&fit=crop',
    kategori: 'Obat',
    linkArtikel: 'https://tbindonesia.or.id/informasi/tentang-tbc/obat-tbc/',
    tanggalPublikasi: DateTime(2026, 5, 5),
    waktuBacaMenit: 6,
  ),

  // ── Artikel 5 ─────────────────────────────────────────────
  Artikel(
    judul: 'Mengenal MDR-TB: TBC yang Kebal Obat',
    deskripsi:
        'Waspadai TBC resisten obat dan ketahui cara mencegahnya melalui kepatuhan pengobatan',
    imageUrl:
        'https://images.unsplash.com/photo-1584634731339-252c581abfc5?w=800&h=400&fit=crop',
    kategori: 'Pencegahan',
    linkArtikel: 'https://tbindonesia.or.id/informasi/tentang-tbc/mdr-tb/',
    tanggalPublikasi: DateTime(2026, 5, 17),
    waktuBacaMenit: 7,
  ),

  // ── Artikel 6 ─────────────────────────────────────────────
  Artikel(
    judul: 'Makanan yang Harus Dihindari Pasien TBC',
    deskripsi:
        'Beberapa jenis makanan dapat mengganggu penyerapan obat dan memperlambat proses penyembuhan',
    imageUrl:
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&h=400&fit=crop',
    kategori: 'Nutrisi',
    linkArtikel:
        'https://tbindonesia.or.id/informasi/tentang-tbc/pantangan-tbc/',
    tanggalPublikasi: DateTime(2026, 4, 28),
    waktuBacaMenit: 4,
  ),
];
