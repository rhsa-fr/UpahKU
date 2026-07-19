import 'package:isar/isar.dart';
import '../../domain/repositories/absensi_repository.dart';
import '../datasources/local/isar_service.dart';
import '../models/absensi_model.dart';

class AbsensiRepositoryImpl implements AbsensiRepository {
  final IsarService _isarService;

  AbsensiRepositoryImpl(this._isarService);

  @override
  Future<List<AbsensiModel>> getAbsensiByTanggal(DateTime tanggal) async {
    final isar = await _isarService.db;
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    
    final list = await isar.absensiModels
        .filter()
        .tanggalEqualTo(dateOnly)
        .findAll();

    for (var absensi in list) {
      await absensi.karyawan.load();
    }
    return list;
  }

  @override
  Future<void> saveAbsensi(AbsensiModel absensi) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.absensiModels.put(absensi);
      await absensi.karyawan.save();
    });
  }

  @override
  Future<void> saveMultipleAbsensi(List<AbsensiModel> absensiList) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      for (var absensi in absensiList) {
        await isar.absensiModels.put(absensi);
        await absensi.karyawan.save();
      }
    });
  }
}
