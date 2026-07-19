import 'package:isar/isar.dart';
import 'karyawan_model.dart';

part 'transaksi_tambahan_model.g.dart';

@collection
@Name("TransaksiTambahan")
class TransaksiTambahanModel {
  Id id = Isar.autoIncrement;

  final karyawan = IsarLink<KaryawanModel>();

  @Index()
  late DateTime tanggal; // Format yyyy-MM-dd tanpa jam

  late double nominal;
  
  late String tipe; // 'Bonus', 'Potongan', 'Kasbon'
  
  late String keterangan;
}
