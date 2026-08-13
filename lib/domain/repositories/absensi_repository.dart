import '../../data/models/absensi_model.dart';

abstract class AbsensiRepository {
  Future<List<AbsensiModel>> getAbsensiByTanggal(DateTime tanggal);
  Future<void> saveAbsensi(AbsensiModel absensi);
  Future<void> saveMultipleAbsensi(List<AbsensiModel> absensiList);
  Future<void> saveBulkAbsensi({
    required List<int> karyawanIds,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  });
}
