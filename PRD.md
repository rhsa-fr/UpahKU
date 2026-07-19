# PRODUCT REQUIREMENTS DOCUMENT (PRD)

# Sistem Penggajian Karyawan Harian Offline (Daily Payroll)

**STATUS: DRAFT SEMENTARA**

| | |
| --- | --- |
| **Nama Produk** | Sistem Penggajian Karyawan Harian Offline |
| **Versi Dokumen** | v0.1 |
| **Disusun oleh** | Pengembang |
| **Untuk** | Klien |
| **Tanggal** | 19 Juli 2026 |
| **Dokumen Terkait** | Hasil Diskusi Perancangan Sistem |

---

# 1. Ringkasan Produk (Overview)

Banyak usaha seperti proyek bangunan, bengkel, workshop, gudang, dan UMKM masih mencatat absensi serta menghitung gaji karyawan harian secara manual menggunakan buku atau Excel. Cara ini rentan menimbulkan kesalahan perhitungan hari kerja, lembur, bonus, potongan, dan memerlukan waktu lama saat membuat slip gaji.

Aplikasi yang akan dibangun adalah aplikasi Android **100% offline** yang hanya digunakan oleh **mandor**. Seluruh data diinput secara manual oleh mandor tanpa QR Code, fingerprint, GPS, server, maupun internet. Sistem mencakup pengelolaan karyawan, absensi harian, lembur, bonus, potongan, penggajian otomatis, slip gaji PDF, riwayat, serta backup dan restore data.

# 2. Tujuan & Sasaran

- Mempermudah pencatatan absensi harian.
- Mengotomatisasi perhitungan gaji.
- Mengurangi kesalahan perhitungan manual.
- Mempercepat pembuatan slip gaji.
- Menyimpan riwayat penggajian secara terpusat di perangkat.

# 3. Pengguna & Peran

- **Mandor:** Mengelola seluruh fitur aplikasi.

# 4. Ruang Lingkup

## 4.1 Termasuk (MVP)

- Dashboard.
- Manajemen karyawan.
- Absensi manual.
- Lembur.
- Bonus.
- Potongan.
- Penggajian otomatis.
- Slip gaji PDF.
- Riwayat penggajian.
- Backup & Restore.

## 4.2 Di Luar Lingkup Awal

- Multi pengguna.
- Sinkronisasi cloud.
- Integrasi WhatsApp.
- Integrasi QR Code.
- Fingerprint.
- GPS.

# 5. Asumsi & Batasan

- Android (Flutter).
- Database lokal (Isar).
- 100% offline.
- Tidak menggunakan server maupun API.
- Seluruh data diinput manual oleh mandor.
- Slip gaji dibuat dalam format PDF.

# 6. Kebutuhan Fungsional

## 6.1 Dashboard

| ID | Kebutuhan | Prioritas |
|---|---|---|
| DASH-1 | Menampilkan total karyawan aktif | Wajib |
| DASH-2 | Menampilkan hadir hari ini | Wajib |
| DASH-3 | Menampilkan tidak hadir hari ini | Wajib |
| DASH-4 | Menampilkan total lembur hari ini | Wajib |
| DASH-5 | Menampilkan estimasi total gaji | Penting |

## 6.2 Karyawan

| ID | Kebutuhan | Prioritas |
|---|---|---|
| EMP-1 | Tambah karyawan | Wajib |
| EMP-2 | Edit karyawan | Wajib |
| EMP-3 | Hapus karyawan | Wajib |
| EMP-4 | Atur upah harian | Wajib |
| EMP-5 | Atur tarif lembur | Wajib |

## 6.3 Absensi

| ID | Kebutuhan | Prioritas |
|---|---|---|
| ABS-1 | Input absensi manual | Wajib |
| ABS-2 | Status Hadir, Izin, Sakit, Alfa | Wajib |
| ABS-3 | Ubah absensi | Penting |

## 6.4 Lembur

| ID | Kebutuhan | Prioritas |
|---|---|---|
| OVT-1 | Input jam lembur | Wajib |
| OVT-2 | Hitung upah lembur otomatis | Wajib |

## 6.5 Bonus & Potongan

| ID | Kebutuhan | Prioritas |
|---|---|---|
| SAL-1 | Tambah bonus | Wajib |
| SAL-2 | Tambah potongan | Wajib |
| SAL-3 | Catat kasbon | Penting |

## 6.6 Penggajian

| ID | Kebutuhan | Prioritas |
|---|---|---|
| PAY-1 | Hitung gaji otomatis | Wajib |
| PAY-2 | Hitung lembur | Wajib |
| PAY-3 | Hitung bonus | Wajib |
| PAY-4 | Hitung potongan | Wajib |
| PAY-5 | Tampilkan total gaji bersih | Wajib |

## 6.7 Slip Gaji

| ID | Kebutuhan | Prioritas |
|---|---|---|
| SLP-1 | Generate PDF | Wajib |
| SLP-2 | Cetak slip | Wajib |
| SLP-3 | Simpan PDF | Wajib |

## 6.8 Backup

| ID | Kebutuhan | Prioritas |
|---|---|---|
| BAK-1 | Backup database | Wajib |
| BAK-2 | Restore database | Wajib |

# 7. Alur Pengguna

1. Mandor membuka aplikasi.
2. Mengelola data karyawan.
3. Menginput absensi harian.
4. Menginput lembur, bonus, dan potongan.
5. Memilih periode penggajian.
6. Sistem menghitung gaji otomatis.
7. Slip gaji dibuat dalam PDF.
8. Data tersimpan pada riwayat.

# 8. Model Data

| Entitas | Field Utama | Keterangan |
|---|---|---|
| karyawan | id,nama,jabatan,upah_harian,tarif_lembur,status | Data master |
| absensi | id,karyawan_id,tanggal,status | Kehadiran |
| lembur | id,karyawan_id,tanggal,jam | Lembur |
| bonus | id,karyawan_id,nominal,keterangan | Bonus |
| potongan | id,karyawan_id,nominal,keterangan | Potongan |
| penggajian | id,periode,total_gaji | Rekap |
| slip_gaji | id,penggajian_id,file_pdf | Arsip |

# 9. Non-Fungsional

- Responsif untuk Android.
- Waktu perhitungan cepat.
- Data tersimpan lokal.
- Backup manual.

# 10. Integrasi

Sistem berdiri sendiri dan tidak menggunakan layanan pihak ketiga.

# 11. Fitur Fase Lanjutan

- Sinkronisasi cloud.
- Multi pengguna.
- Dashboard web.
- WhatsApp.
- Ekspor Excel.

# 12. TBD

- Format nomor slip gaji.
- Logo perusahaan.
- Format backup.

# 13. Glosarium

- **Mandor:** Pengguna utama aplikasi.
- **Kasbon:** Pinjaman yang dipotong saat penggajian.
- **Slip Gaji:** Dokumen rincian penghasilan karyawan.

---
*Dokumen ini merupakan draft sementara dan dapat berubah sesuai kebutuhan proyek.*
