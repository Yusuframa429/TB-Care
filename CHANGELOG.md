# Changelog

Semua perubahan penting pada proyek TB Care akan didokumentasikan di file ini.

Format pencatatan ini didasarkan pada standar [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), dan proyek ini menganut [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added (Ditambahkan)
- **Fitur Beranda (Home):** Header dinamis, statistik kesehatan, kartu pengingat obat, kepatuhan obat, section edukasi, dan "Tahukah Anda?".
- **Fitur Profil:** Tampilan halaman profil lengkap dengan header data pengguna (avatar, status, stats), kartu darurat (Emergency SOS), menu pengaturan & privasi, dan informasi "AI Certified" by Kemenkes RI.
- **Fitur Cek AI (Expert System TBC):**
  - Antarmuka *Chat-based* AI Asisten menggunakan `StatefulWidget`.
  - Implementasi **Clean Architecture** (Domain: *Entities*, *Use Cases*; Data: *Data Sources*; Presentation: *UI Widgets*).
  - Skrining TBC berbasis 10 pertanyaan medis berbobot (Gejala Utama, Gejala Sekunder, Faktor Risiko, Durasi).
  - *Safety Rules / Algoritma Keamanan* klinis (mendeteksi Trias Klasik TBC, Komorbid HIV/DM).
  - Klasifikasi risiko otomatis (Rendah, Sedang, Tinggi) dan rujukan *Fasyankes* / chat dengan dokter spesialis.
  - Halaman `HasilPemeriksaanPage` interaktif yang merangkum level risiko dan gejala terdeteksi.
- Inisialisasi proyek Flutter utama `tb_care`.
- Setup arsitektur Modular/Monorepo menggunakan pustaka **Melos** dan Dart Workspaces.
- Pembuatan package `packages/core_ui` untuk menyimpan seluruh komponen antarmuka yang dapat digunakan berulang (reusable UI).
- Pembuatan package `packages/core_services` untuk mengelola proses bisnis, servis API, dan manajemen state.
- Konfigurasi **FVM** untuk menyelaraskan versi SDK Flutter (v3.24.4 / Dart v3.5) di seluruh anggota tim.
- Pembaruan file `.gitignore` standar untuk mengecualikan cache sistem, hasil build, dan konfigurasi lokal IDE.
- Pembaruan `README.md` dengan instruksi setup Monorepo (fvm + melos bootstrap).

### Changed (Diubah)
- Memindahkan pengelolaan *dependencies* ke format Dart Workspaces agar package internal saling terhubung tanpa publish ke pub.dev.
