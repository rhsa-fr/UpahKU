<p align="center">
  <img src="assets/images/logo.png" alt="UpahKu Logo" width="120" />
</p>

<h1 align="center">UpahKu — Penggajian Harian Offline</h1>

<p align="center">
  <strong>Solusi Manajemen Absensi, Lembur, & Penggajian Harian UMKM Berbasis Offline-First</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-0F1F3D?style=for-the-badge&logo=android&logoColor=10B981" alt="Platform Android" />
  <img src="https://img.shields.io/badge/Database-Offline_First-10B981?style=for-the-badge&logo=sqlite&logoColor=white" alt="Offline First" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="MIT License" />
</p>

---

## 🚀 Mengapa Memilih UpahKu?

Mengelola penggajian harian secara manual menggunakan kertas atau spreadsheet seringkali memicu kesalahan hitung, membutuhkan waktu lama, dan rawan kehilangan data. **UpahKu** hadir memberikan pengalaman manajemen penggajian yang cepat, presisi, dan profesional langsung dari perangkat Android Anda.

---

## ✨ Fitur Unggulan Aplikasi

### ⚡ 1. Pencatatan Absensi & Lembur Serba Otomatis (Auto-Save)
* **Status Kehadiran Presisi**: Catat status *Hadir (H)*, *Izin (I)*, *Sakit (S)*, atau *Alpa (A)* dalam satu sentuhan.
* **Counter Lembur Fleksibel**: Hitung jam lembur dengan tombol kelipatan `0.5 jam` yang sangat intuitif.
* **Auto-Save Real-Time**: Tidak ada lagi kehilangan data akibat lupa menekan tombol simpan — setiap entri tersimpan secara instan di database lokal.

### 🧮 2. Engine Perhitungan Gaji Otomatis & Akurat
* **Kalkulasi Serba Otomatis**: Menghitung komponen gaji secara real-time:
  $$\text{Gaji Bersih} = (\text{Hadir} \times \text{Tarif Harian}) + (\text{Jam Lembur} \times \text{Tarif Lembur}) + \text{Bonus} - \text{Potongan} - \text{Kasbon}$$
* **Format Mata Uang Rupiah**: Nominal otomatis terformat rapi dengan pemisah ribuan (contoh: `Rp 1.500.000`).

### 📄 3. Cetak & Bagikan Slip Gaji PDF Instan
* **Generasi PDF Otomatis**: Hasilkan Slip Gaji PDF ukuran A5 yang rapi, lengkap dengan header nama usaha, rincian komponen gaji, dan area tanda tangan.
* **Kirim via WhatsApp**: Bagikan slip gaji langsung ke aplikasi WhatsApp karyawan hanya dengan satu ketukan.

### 🔒 4. 100% Offline-First & Privasi Data Terjamin
* **Tanpa Koneksi Internet**: Aplikasi tetap beroperasi 100% lancar di daerah tanpa sinyal internet.
* **Privasi Maksimal**: Data keuangan dan karyawan tersimpan secara lokal di perangkat Anda — tidak dikirim ke server pihak ketiga mana pun.
* **Fitur Ekspor & Impor (Backup/Restore)**: Cadangkan seluruh data aplikasi ke file `.isar` untuk dipindahkan ke HP lain secara aman.

---

## 📱 Alur Kerja Bisnis Aplikasi

```text
┌───────────────────────────┐
│     Master Karyawan       │
│ (Nama, Jabatan, Upah/Hari)│
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│   Input Harian Auto-Save  │
├─────────────┬─────────────┤
│ Absensi (H/I/S/A)         │
│ Lembur (Per 0.5 Jam)      │
│ Bonus & Potongan / Kasbon │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│ Form Periode Penggajian   │
│   (Hitung Otomatis Gaji)  │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│   Slip Gaji PDF A5        │
│ (Cetak / Share WhatsApp)  │
└─────────────┬─────────────┘
```

---

## 🎨 Desain & Kenyamanan Pengguna

* **Material 3 Design System**: Tampilan antarmuka modern yang bersih, cepat, dan nyaman digunakan dalam waktu lama.
* **Mode Gelap Adaptif (Dark Mode)**: Mendukung preferensi Tema Gelap / Terang / Otomatis Sistem untuk menghemat daya baterai.
* **Tipografi Modern (Outfit)**: Menggunakan font geometris yang jernih dan mudah dibaca oleh semua kalangan usia.

---

## 📜 Lisensi

Proyek ini dirilis di bawah lisensi **[MIT License](LICENSE)**. Anda bebas menggunakannya untuk kebutuhan bisnis, komersial, maupun personal.

---

## 📲 Unduh Aplikasi

> [!TIP]
> **[📥 Download UpahKu Production Release APK (v1.0.0)](https://github.com/rhsa-fr/UpahKU/releases/download/v1.0.0/app-release.apk)**

<p align="center">
  <strong>UpahKu — Penggajian Harian Offline</strong>
</p>