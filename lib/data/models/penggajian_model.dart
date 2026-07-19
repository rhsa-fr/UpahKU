import 'package:isar/isar.dart';
import 'karyawan_model.dart';

part 'penggajian_model.g.dart';

@collection
@Name("Penggajian")
class PenggajianModel {
  Id id = Isar.autoIncrement;

  final karyawan = IsarLink<KaryawanModel>();

  late DateTime tanggalGajian;
  late DateTime periodeMulai;
  late DateTime periodeSelesai;

  // Kehadiran & Lembur Rekap
  late int totalHadir;
  late int totalIzin;
  late int totalSakit;
  late int totalAlfa;
  late double totalJamLembur;

  // Tarif saat proses penggajian dilakukan
  late double upahHarianSaatItu;
  late double tarifLemburSaatItu;

  // Rincian Nilai
  late double totalUpahKerja;  // totalHadir * upahHarianSaatItu
  late double totalUpahLembur; // totalJamLembur * tarifLemburSaatItu
  late double totalBonus;
  late double totalPotongan;
  late double totalKasbon;
  late double totalGajiBersih;

  String? pathPdf; // Path file PDF slip gaji lokal jika disimpan
}
