import 'package:isar/isar.dart';
import 'karyawan_model.dart';

part 'lembur_model.g.dart';

@collection
@Name("Lembur")
class LemburModel {
  Id id = Isar.autoIncrement;

  final karyawan = IsarLink<KaryawanModel>();

  @Index()
  late DateTime tanggal; // Format yyyy-MM-dd tanpa jam

  late double jumlahJam;
}
