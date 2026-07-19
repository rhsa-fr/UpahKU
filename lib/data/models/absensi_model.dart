import 'package:isar/isar.dart';
import 'karyawan_model.dart';

part 'absensi_model.g.dart';

@collection
@Name("Absensi")
class AbsensiModel {
  Id id = Isar.autoIncrement;

  final karyawan = IsarLink<KaryawanModel>();

  @Index()
  late DateTime tanggal; // Format yyyy-MM-dd tanpa jam

  late String status; // 'Hadir', 'Izin', 'Sakit', 'Alfa'
}
