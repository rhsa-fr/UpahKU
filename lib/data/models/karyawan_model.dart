import 'package:isar/isar.dart';

part 'karyawan_model.g.dart';

@collection
@Name("Karyawan")
class KaryawanModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String nama;

  late String jabatan;
  late double upahHarian;
  late double tarifLembur;
  late bool statusAktif; // true: aktif, false: non-aktif (di-PHK/keluar)
  
  late DateTime createdAt;
}
