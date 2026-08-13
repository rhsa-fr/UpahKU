import 'package:isar/isar.dart';
import '../../domain/repositories/absensi_repository.dart';
import '../datasources/local/isar_service.dart';
import '../models/absensi_model.dart';
import '../models/karyawan_model.dart';

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

  @override
  Future<void> saveBulkAbsensi({
    required List<int> karyawanIds,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    final isar = await _isarService.db;
    
    // Normalize dates to remove time parts
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    
    final daysDiff = end.difference(start).inDays;
    
    await isar.writeTxn(() async {
      for (int i = 0; i <= daysDiff; i++) {
        final currentDate = start.add(Duration(days: i));
        
        // Fetch all existing absensi for this date
        final existingList = await isar.absensiModels
            .filter()
            .tanggalEqualTo(currentDate)
            .findAll();
            
        // Load employee links for comparison
        for (var e in existingList) {
          await e.karyawan.load();
        }
        
        for (var karyawanId in karyawanIds) {
          // Check if there is already an absensi record for this employee on this date
          final match = existingList.firstWhere(
            (e) => e.karyawan.value?.id == karyawanId,
            orElse: () => AbsensiModel(),
          );
          
          if (match.id != Isar.autoIncrement && match.id != 0) {
            // Update existing record
            match.status = status;
            await isar.absensiModels.put(match);
          } else {
            // Create new record
            final karyawanObj = await isar.karyawanModels.get(karyawanId);
            if (karyawanObj != null) {
              final newAbsensi = AbsensiModel()
                ..tanggal = currentDate
                ..status = status;
              newAbsensi.karyawan.value = karyawanObj;
              await isar.absensiModels.put(newAbsensi);
              await newAbsensi.karyawan.save();
            }
          }
        }
      }
    });
  }
}
