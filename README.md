# TB Care

Aplikasi Flutter untuk pemantauan dan kepedulian Tuberkulosis (TB). Proyek ini dibangun menggunakan arsitektur **Modular / Monorepo** agar kode lebih rapi, terukur, dan mudah dikolaborasikan oleh tim.

## 📦 Struktur Proyek (Monorepo)

Proyek ini menggunakan **Melos** dan fitur bawaan *Dart Workspaces* untuk mengelola multi-package. Struktur utamanya meliputi:

- `/` (Root): Aplikasi utama `tb_care` yang menyatukan semua fitur (`lib/features`).
- `/packages/core_ui`: Package khusus untuk komponen UI visual (tombol, input, warna, tema) yang dapat digunakan ulang.
- `/packages/core_services`: Package khusus untuk logika bisnis, integrasi API, database lokal (Hive), dan layanan lainnya (Notifikasi).

## ✨ Fitur Utama (Core Features)

1.  **Autentikasi**: Sistem Login dan Register untuk mengamankan data pemantauan pengguna.
2.  **Beranda & Edukasi**: Dashboard utama menampilkan status kesehatan, ringkasan pengingat obat, dan artikel edukasi TBC yang terpercaya.
3.  **Manajemen Obat (Adherence Tracking)**:
    *   Pengaturan jadwal minum obat (OAT) yang fleksibel.
    *   Pelacakan kepatuhan harian dengan statistik, riwayat, dan sistem *streak*.
    *   Sistem poin dan pencapaian (Gamifikasi) untuk memotivasi pasien dalam proses kesembuhan.
4.  **Chat & Konsultasi**:
    *   **Tanya AI**: Chatbot interaktif berbasis **Google Gemini API** untuk menjawab pertanyaan seputar TBC secara instan.
    *   **Konsultasi Dokter**: Daftar dokter spesialis paru yang tersedia untuk konsultasi lebih lanjut via WhatsApp.
5.  **Cek AI (Expert System TBC)**:
    *   Modul skrining TBC berbasis kecerdasan buatan (Logika Sistem Pakar).
    *   Chatbot interaktif untuk mengumpulkan parameter klinis (Gejala, Komorbid, Durasi).
    *   Diimplementasikan dengan pola **Clean Architecture** (memisahkan `domain` logic dan `presentation` UI).
    *   Memberikan tingkat risiko serta rekomendasi pemeriksaan ke Fasyankes terdekat.
6.  **Profil & Keluarga**:
    *   Manajemen data akun dan riwayat pemeriksaan.
    *   **Manajemen Keluarga**: Fitur untuk menambahkan dan memantau status kesehatan anggota keluarga dalam satu aplikasi.

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter (Dart)
- **Monorepo Management**: Melos
- **Version Management**: FVM (Flutter Version Management)
- **AI Integration**: Google Generative AI (Gemini)
- **Local Database**: Hive & Shared Preferences
- **Notifications**: Flutter Local Notifications
- **Architecture**: Modular & Clean Architecture (pada modul tertentu)

## 🚀 Panduan Memulai (Getting Started)

Karena proyek ini dikonfigurasi dengan FVM dan Melos, ikuti langkah berikut untuk setup di komputer Anda:

### 1. Prasyarat
Pastikan Anda sudah menginstal alat berikut:
- [FVM](https://fvm.app/docs/getting_started/installation) untuk manajemen versi Flutter.

### 2. Setup & Sinkronisasi
Buka terminal di dalam folder proyek ini, lalu jalankan:

```bash
# 1. Unduh/gunakan versi Flutter yang sesuai
fvm install
fvm use

# 2. Sinkronisasikan semua dependensi package
fvm flutter pub get
fvm dart run melos bs
```

### 3. Konfigurasi Environment
Salin file `.env.example` menjadi `.env` dan masukkan API Key yang diperlukan (misal: Google Gemini API Key).

### 4. Jalankan Aplikasi
```bash
fvm flutter run
```

## 📝 Aturan Kontribusi & Changelog

Tim proyek ini dianjurkan menggunakan format **Conventional Commits** (contoh: `feat:`, `fix:`, `docs:`, `refactor:`). Melos akan otomatis men-generate `CHANGELOG.md` berdasarkan pesan commit tersebut.

