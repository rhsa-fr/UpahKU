import '../../data/models/absensi_model.dart';

abstract class AbsensiRepository {
  Future<List<AbsensiModel>> getAbsensiByTanggal(DateTime tanggal);
  Future<void> saveAbsensi(AbsensiModel absensi);
  Future<void> saveMultipleAbsensi(List<AbsensiModel> absensiList);
}
