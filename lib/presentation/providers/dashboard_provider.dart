import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'karyawan_provider.dart';
import '../../data/models/karyawan_model.dart';
import '../../data/models/absensi_model.dart';
import '../../data/models/lembur_model.dart';
import '../../data/models/penggajian_model.dart';
import '../../data/repositories/mock_repositories.dart';

class DashboardData {
  final int totalKaryawanAktif;
  final int hadirHariIni;
  final int tidakHadirHariIni;
  final double lemburHariIni;
  final double estimasiGajiBulanIni;

  DashboardData({
    required this.totalKaryawanAktif,
    required this.hadirHariIni,
    required this.tidakHadirHariIni,
    required this.lemburHariIni,
    required this.estimasiGajiBulanIni,
  });
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final today = DateTime.now();
  final dateOnly = DateTime(today.year, today.month, today.day);

  int activeCount = 0;
  int hadirCount = 0;
  int tidakHadirCount = 0;
  double totalLemburHours = 0.0;
  double totalPayrollAmount = 0.0;

  if (kIsWeb) {
    activeCount = InMemoryDb.karyawanList.where((k) => k.statusAktif).length;

    final absensiList = InMemoryDb.absensiList.where((a) {
      final aDate = DateTime(a.tanggal.year, a.tanggal.month, a.tanggal.day);
      return aDate.isAtSameMomentAs(dateOnly);
    }).toList();

    for (var a in absensiList) {
      final isKaryawanAktif = a.karyawan.value?.statusAktif ?? 
          InMemoryDb.karyawanList.firstWhere((k) => k.id == a.karyawan.value?.id, orElse: () => KaryawanModel()).statusAktif;
      if (isKaryawanAktif) {
        if (a.status == 'Hadir') {
          hadirCount++;
        } else {
          tidakHadirCount++;
        }
      }
    }

    final lemburList = InMemoryDb.lemburList.where((l) {
      final lDate = DateTime(l.tanggal.year, l.tanggal.month, l.tanggal.day);
      return lDate.isAtSameMomentAs(dateOnly);
    }).toList();

    for (var l in lemburList) {
      totalLemburHours += l.jumlahJam;
    }

    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 0, 23, 59, 59);

    final payrolls = InMemoryDb.penggajianList.where((p) {
      return p.tanggalGajian.isAfter(firstDayOfMonth.subtract(const Duration(seconds: 1))) &&
          p.tanggalGajian.isBefore(lastDayOfMonth.add(const Duration(seconds: 1)));
    }).toList();

    for (var p in payrolls) {
      totalPayrollAmount += p.totalGajiBersih;
    }
  } else {
    final isarService = ref.watch(isarServiceProvider);
    final isar = await isarService.db;

    activeCount = await isar.karyawanModels.filter().statusAktifEqualTo(true).count();

    final absensiList = await isar.absensiModels.filter().tanggalEqualTo(dateOnly).findAll();

    for (var a in absensiList) {
      await a.karyawan.load();
      if (a.karyawan.value?.statusAktif ?? false) {
        if (a.status == 'Hadir') {
          hadirCount++;
        } else {
          tidakHadirCount++;
        }
      }
    }

    final lemburList = await isar.lemburModels.filter().tanggalEqualTo(dateOnly).findAll();
    for (var l in lemburList) {
      totalLemburHours += l.jumlahJam;
    }

    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 0, 23, 59, 59);

    final payrolls = await isar.penggajianModels
        .filter()
        .tanggalGajianBetween(firstDayOfMonth, lastDayOfMonth)
        .findAll();

    for (var p in payrolls) {
      totalPayrollAmount += p.totalGajiBersih;
    }
  }

  final unreportedCount = (activeCount - (hadirCount + tidakHadirCount)).clamp(0, activeCount);
  final actualTidakHadir = tidakHadirCount + unreportedCount;

  return DashboardData(
    totalKaryawanAktif: activeCount,
    hadirHariIni: hadirCount,
    tidakHadirHariIni: actualTidakHadir,
    lemburHariIni: totalLemburHours,
    estimasiGajiBulanIni: totalPayrollAmount,
  );
});
