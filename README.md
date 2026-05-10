# TB Care

Aplikasi Flutter untuk pemantauan dan kepedulian Tuberkulosis (TB). Proyek ini dibangun menggunakan arsitektur **Modular / Monorepo** agar kode lebih rapi, terukur, dan mudah dikolaborasikan oleh tim.

## 📦 Struktur Proyek (Monorepo)

Proyek ini menggunakan **Melos** dan fitur bawaan *Dart Workspaces* untuk mengelola multi-package. Struktur utamanya meliputi:

- `/` (Root): Aplikasi utama `tb_care` yang menyatukan semua fitur.
- `/packages/core_ui`: Package khusus untuk komponen UI visual (tombol, input, warna, tema) yang dapat digunakan ulang.
- `/packages/core_services`: Package khusus untuk logika bisnis, integrasi API, database lokal, dan layanan lainnya.

## ✨ Fitur Utama (Core Features)

1. **Beranda & Edukasi**: Dashboard utama menampilkan status kesehatan, pengingat obat, kepatuhan, serta artikel edukasi TBC terpercaya.
2. **Profil Pengguna**: Manajemen data akun, riwayat pemeriksaan, status kesehatan keluarga, dan pengaturan privasi bersertifikat aman.
3. **Cek AI (Expert System TBC)**: 
   - Modul skrining TBC berbasis kecerdasan buatan (Logika Sistem Pakar).
   - Chatbot interaktif untuk mengumpulkan 10 parameter klinis (Gejala, Komorbid, Durasi).
   - Diimplementasikan dengan pola **Clean Architecture** (memisahkan `domain` logic dan `presentation` UI).
   - Menghasilkan tingkat risiko akurat beserta rekomendasi pemeriksaan ke Fasyankes terdekat.

## 🚀 Panduan Memulai (Getting Started)

Karena proyek ini dikonfigurasi dengan FVM (Flutter Version Management) dan Melos, ikuti langkah berikut untuk setup di komputer Anda:

### 1. Prasyarat
Pastikan Anda sudah menginstal alat berikut di komputer Anda:
- [FVM](https://fvm.app/docs/getting_started/installation) untuk manajemen versi Flutter.

### 2. Setup & Sinkronisasi
Buka terminal di dalam folder proyek ini, lalu jalankan perintah berikut:

```bash
# 1. Unduh/gunakan versi Flutter yang sesuai dengan konfigurasi tim
fvm install
fvm use

# 2. Sinkronisasikan semua dependensi package di seluruh workspace
fvm flutter pub get
fvm dart run melos bs
```

### 3. Jalankan Aplikasi
Setelah proses sinkronisasi (bootstrap) selesai, Anda dapat menjalankan aplikasi seperti biasa:

```bash
fvm flutter run
```

## 📝 Aturan Kontribusi & Changelog

Tim proyek ini dianjurkan menggunakan format **Conventional Commits** setiap kali melakukan perubahan (contoh: `feat: tambah halaman login`, `fix: perbaiki tombol error`, `docs: perbarui readme`).

Hal ini bertujuan agar ke depannya Melos dapat men-generate dokumentasi `CHANGELOG.md` secara otomatis setiap kali ada rilis versi baru.
