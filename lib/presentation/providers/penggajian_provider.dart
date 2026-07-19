import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/penggajian_model.dart';
import '../../data/models/karyawan_model.dart';
import '../../data/models/absensi_model.dart';
import '../../data/models/lembur_model.dart';
import '../../data/models/transaksi_tambahan_model.dart';
import '../../data/repositories/penggajian_repository_impl.dart';
import '../../data/repositories/mock_repositories.dart';
import '../../domain/repositories/penggajian_repository.dart';
import 'karyawan_provider.dart';
import 'dashboard_provider.dart';

final penggajianRepositoryProvider = Provider<PenggajianRepository>((ref) {
  if (kIsWeb) {
    return PenggajianRepositoryMock();
  }
  final isarService = ref.watch(isarServiceProvider);
  return PenggajianRepositoryImpl(isarService);
});

class PenggajianHistoryNotifier extends StateNotifier<AsyncValue<List<PenggajianModel>>> {
  final PenggajianRepository _repository;
  final Ref _ref;

  PenggajianHistoryNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final list = await _repository.getPenggajianAll();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> savePayrollRun(List<PenggajianModel> list) async {
    state = const AsyncValue.loading();
    try {
      await _repository.saveMultiplePenggajian(list);
      await loadHistory();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deletePayrollRun(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePenggajian(id);
      await loadHistory();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final penggajianHistoryProvider = StateNotifierProvider<PenggajianHistoryNotifier, AsyncValue<List<PenggajianModel>>>((ref) {
  final repo = ref.watch(penggajianRepositoryProvider);
  return PenggajianHistoryNotifier(repo, ref);
});

final hitungGajiProvider = FutureProvider.family<List<PenggajianModel>, ({DateTime start, DateTime end})>((ref, arg) async {
  final isarService = ref.watch(isarServiceProvider);
  final isar = kIsWeb ? null : await isarService.db;

  final startOnly = DateTime(arg.start.year, arg.start.month, arg.start.day);
  final endOnly = DateTime(arg.end.year, arg.end.month, arg.end.day, 23, 59, 59);

  final List<KaryawanModel> employees;
  if (kIsWeb) {
    employees = InMemoryDb.karyawanList;
  } else {
    employees = await isar!.karyawanModels.where().findAll();
  }
  
  final List<PenggajianModel> results = [];

  for (var employee in employees) {
    final List<AbsensiModel> attendanceList;
    final List<LemburModel> lemburList;
    final List<TransaksiTambahanModel> transactionsList;

    if (kIsWeb) {
      attendanceList = InMemoryDb.absensiList.where((a) {
        return a.karyawan.value?.id == employee.id &&
            a.tanggal.isAfter(startOnly.subtract(const Duration(seconds: 1))) &&
            a.tanggal.isBefore(endOnly.add(const Duration(seconds: 1)));
      }).toList();

      lemburList = InMemoryDb.lemburList.where((l) {
        return l.karyawan.value?.id == employee.id &&
            l.tanggal.isAfter(startOnly.subtract(const Duration(seconds: 1))) &&
            l.tanggal.isBefore(endOnly.add(const Duration(seconds: 1)));
      }).toList();

      transactionsList = InMemoryDb.transaksiList.where((t) {
        return t.karyawan.value?.id == employee.id &&
            t.tanggal.isAfter(startOnly.subtract(const Duration(seconds: 1))) &&
            t.tanggal.isBefore(endOnly.add(const Duration(seconds: 1)));
      }).toList();
    } else {
      attendanceList = await isar!.absensiModels
          .filter()
          .karyawan((q) => q.idEqualTo(employee.id))
          .tanggalBetween(startOnly, endOnly)
          .findAll();

      lemburList = await isar!.lemburModels
          .filter()
          .karyawan((q) => q.idEqualTo(employee.id))
          .tanggalBetween(startOnly, endOnly)
          .findAll();

      transactionsList = await isar!.transaksiTambahanModels
          .filter()
          .karyawan((q) => q.idEqualTo(employee.id))
          .tanggalBetween(startOnly, endOnly)
          .findAll();
    }

    if (!employee.statusAktif && attendanceList.isEmpty && lemburList.isEmpty && transactionsList.isEmpty) {
      continue;
    }

    int totalHadir = 0;
    int totalIzin = 0;
    int totalSakit = 0;
    int totalAlfa = 0;

    for (var a in attendanceList) {
      if (a.status == 'Hadir') totalHadir++;
      else if (a.status == 'Izin') totalIzin++;
      else if (a.status == 'Sakit') totalSakit++;
      else if (a.status == 'Alfa') totalAlfa++;
    }

    double totalJamLembur = 0.0;
    for (var l in lemburList) {
      totalJamLembur += l.jumlahJam;
    }

    double totalBonus = 0.0;
    double totalPotongan = 0.0;
    double totalKasbon = 0.0;

    for (var tx in transactionsList) {
      if (tx.tipe == 'Bonus') {
        totalBonus += tx.nominal;
      } else if (tx.tipe == 'Potongan') {
        totalPotongan += tx.nominal;
      } else if (tx.tipe == 'Kasbon') {
        totalKasbon += tx.nominal;
      }
    }

    final upahHarianSaatItu = employee.upahHarian;
    final tarifLemburSaatItu = employee.tarifLembur;

    final totalUpahKerja = totalHadir * upahHarianSaatItu;
    final totalUpahLembur = totalJamLembur * tarifLemburSaatItu;
    
    final totalGajiBersih = totalUpahKerja + totalUpahLembur + totalBonus - totalPotongan - totalKasbon;

    final p = PenggajianModel()
      ..tanggalGajian = DateTime.now()
      ..periodeMulai = startOnly
      ..periodeSelesai = DateTime(arg.end.year, arg.end.month, arg.end.day)
      ..totalHadir = totalHadir
      ..totalIzin = totalIzin
      ..totalSakit = totalSakit
      ..totalAlfa = totalAlfa
      ..totalJamLembur = totalJamLembur
      ..upahHarianSaatItu = upahHarianSaatItu
      ..tarifLemburSaatItu = tarifLemburSaatItu
      ..totalUpahKerja = totalUpahKerja
      ..totalUpahLembur = totalUpahLembur
      ..totalBonus = totalBonus
      ..totalPotongan = totalPotongan
      ..totalKasbon = totalKasbon
      ..totalGajiBersih = totalGajiBersih;
    
    p.karyawan.value = employee;
    results.add(p);
  }

  return results;
});
