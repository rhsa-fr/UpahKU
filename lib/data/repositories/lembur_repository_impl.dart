import 'package:isar/isar.dart';
import '../../domain/repositories/lembur_repository.dart';
import '../datasources/local/isar_service.dart';
import '../models/lembur_model.dart';

class LemburRepositoryImpl implements LemburRepository {
  final IsarService _isarService;

  LemburRepositoryImpl(this._isarService);

  @override
  Future<List<LemburModel>> getLemburByTanggal(DateTime tanggal) async {
    final isar = await _isarService.db;
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    
    final list = await isar.lemburModels
        .filter()
        .tanggalEqualTo(dateOnly)
        .findAll();

    for (var lembur in list) {
      await lembur.karyawan.load();
    }
    return list;
  }

  @override
  Future<void> saveLembur(LemburModel lembur) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.lemburModels.put(lembur);
      await lembur.karyawan.save();
    });
  }

  @override
  Future<void> saveMultipleLembur(List<LemburModel> lemburList) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      for (var lembur in lemburList) {
        await isar.lemburModels.put(lembur);
        await lembur.karyawan.save();
      }
    });
  }
}
