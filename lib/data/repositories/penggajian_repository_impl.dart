import 'package:isar/isar.dart';
import '../../domain/repositories/penggajian_repository.dart';
import '../datasources/local/isar_service.dart';
import '../models/penggajian_model.dart';

class PenggajianRepositoryImpl implements PenggajianRepository {
  final IsarService _isarService;

  PenggajianRepositoryImpl(this._isarService);

  @override
  Future<List<PenggajianModel>> getPenggajianAll() async {
    final isar = await _isarService.db;
    final list = await isar.penggajianModels
        .where()
        .sortByTanggalGajianDesc()
        .findAll();

    for (var p in list) {
      await p.karyawan.load();
    }
    return list;
  }

  @override
  Future<List<PenggajianModel>> getPenggajianByPeriode(DateTime start, DateTime end) async {
    final isar = await _isarService.db;
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final list = await isar.penggajianModels
        .filter()
        .periodeMulaiEqualTo(startOnly)
        .and()
        .periodeSelesaiEqualTo(endOnly)
        .findAll();

    for (var p in list) {
      await p.karyawan.load();
    }
    return list;
  }

  @override
  Future<void> saveMultiplePenggajian(List<PenggajianModel> list) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      for (var p in list) {
        await isar.penggajianModels.put(p);
        await p.karyawan.save();
      }
    });
  }

  @override
  Future<void> deletePenggajian(int id) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.penggajianModels.delete(id);
    });
  }
}
