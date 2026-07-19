import '../../data/models/karyawan_model.dart';

abstract class KaryawanRepository {
  Future<List<KaryawanModel>> getKaryawanAll();
  Future<List<KaryawanModel>> getKaryawanAktif();
  Future<KaryawanModel?> getKaryawanById(int id);
  Future<void> saveKaryawan(KaryawanModel karyawan);
  Future<void> deleteKaryawan(int id);
}
