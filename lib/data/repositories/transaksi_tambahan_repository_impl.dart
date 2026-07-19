import 'package:isar/isar.dart';
import '../../domain/repositories/transaksi_tambahan_repository.dart';
import '../datasources/local/isar_service.dart';
import '../models/transaksi_tambahan_model.dart';
import '../models/karyawan_model.dart';

class TransaksiTambahanRepositoryImpl implements TransaksiTambahanRepository {
  final IsarService _isarService;

  TransaksiTambahanRepositoryImpl(this._isarService);

  @override
  Future<List<TransaksiTambahanModel>> getTransaksiByTanggal(DateTime tanggal) async {
    final isar = await _isarService.db;
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    
    final list = await isar.transaksiTambahanModels
        .filter()
        .tanggalEqualTo(dateOnly)
        .findAll();

    for (var tx in list) {
      await tx.karyawan.load();
    }
    return list;
  }

  @override
  Future<List<TransaksiTambahanModel>> getTransaksiByPeriode(DateTime start, DateTime end) async {
    final isar = await _isarService.db;
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day, 23, 59, 59);
    
    final list = await isar.transaksiTambahanModels
        .filter()
        .tanggalBetween(startOnly, endOnly)
        .findAll();

    for (var tx in list) {
      await tx.karyawan.load();
    }
    return list;
  }

  @override
  Future<List<TransaksiTambahanModel>> getTransaksiByKaryawanAndPeriode(int karyawanId, DateTime start, DateTime end) async {
    final isar = await _isarService.db;
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day, 23, 59, 59);
    
    final list = await isar.transaksiTambahanModels
        .filter()
        .karyawan((q) => q.idEqualTo(karyawanId))
        .tanggalBetween(startOnly, endOnly)
        .findAll();

    for (var tx in list) {
      await tx.karyawan.load();
    }
    return list;
  }

  @override
  Future<void> saveTransaksi(TransaksiTambahanModel transaksi) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.transaksiTambahanModels.put(transaksi);
      await transaksi.karyawan.save();
    });
  }

  @override
  Future<void> deleteTransaksi(int id) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.transaksiTambahanModels.delete(id);
    });
  }
}
