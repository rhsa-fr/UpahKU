import 'package:isar/isar.dart';
import '../../domain/repositories/karyawan_repository.dart';
import '../datasources/local/isar_service.dart';
import '../models/karyawan_model.dart';

class KaryawanRepositoryImpl implements KaryawanRepository {
  final IsarService _isarService;

  KaryawanRepositoryImpl(this._isarService);

  @override
  Future<List<KaryawanModel>> getKaryawanAll() async {
    final isar = await _isarService.db;
    return isar.karyawanModels.where().sortByNama().findAll();
  }

  @override
  Future<List<KaryawanModel>> getKaryawanAktif() async {
    final isar = await _isarService.db;
    return isar.karyawanModels.filter().statusAktifEqualTo(true).sortByNama().findAll();
  }

  @override
  Future<KaryawanModel?> getKaryawanById(int id) async {
    final isar = await _isarService.db;
    return isar.karyawanModels.get(id);
  }

  @override
  Future<void> saveKaryawan(KaryawanModel karyawan) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.karyawanModels.put(karyawan);
    });
  }

  @override
  Future<void> deleteKaryawan(int id) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.karyawanModels.delete(id);
    });
  }
}
