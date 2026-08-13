import 'package:isar/isar.dart';
import '../../domain/repositories/karyawan_repository.dart';
import '../../domain/repositories/absensi_repository.dart';
import '../../domain/repositories/lembur_repository.dart';
import '../../domain/repositories/transaksi_tambahan_repository.dart';
import '../../domain/repositories/penggajian_repository.dart';
import '../models/karyawan_model.dart';
import '../models/absensi_model.dart';
import '../models/lembur_model.dart';
import '../models/transaksi_tambahan_model.dart';
import '../models/penggajian_model.dart';

class InMemoryDb {
  static final List<KaryawanModel> karyawanList = [];
  static final List<AbsensiModel> absensiList = [];
  static final List<LemburModel> lemburList = [];
  static final List<TransaksiTambahanModel> transaksiList = [];
  static final List<PenggajianModel> penggajianList = [];
}

class KaryawanRepositoryMock implements KaryawanRepository {
  @override
  Future<List<KaryawanModel>> getKaryawanAll() async {
    final list = List<KaryawanModel>.from(InMemoryDb.karyawanList);
    list.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    return list;
  }

  @override
  Future<List<KaryawanModel>> getKaryawanAktif() async {
    final list = InMemoryDb.karyawanList.where((k) => k.statusAktif).toList();
    list.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    return list;
  }

  @override
  Future<KaryawanModel?> getKaryawanById(int id) async {
    try {
      return InMemoryDb.karyawanList.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveKaryawan(KaryawanModel karyawan) async {
    if (karyawan.id == Isar.autoIncrement || karyawan.id == 0) {
      karyawan.id = InMemoryDb.karyawanList.length + 1;
      InMemoryDb.karyawanList.add(karyawan);
    } else {
      final index = InMemoryDb.karyawanList.indexWhere((k) => k.id == karyawan.id);
      if (index != -1) {
        InMemoryDb.karyawanList[index] = karyawan;
      }
    }
  }

  @override
  Future<void> deleteKaryawan(int id) async {
    InMemoryDb.karyawanList.removeWhere((k) => k.id == id);
  }
}

class AbsensiRepositoryMock implements AbsensiRepository {
  @override
  Future<List<AbsensiModel>> getAbsensiByTanggal(DateTime tanggal) async {
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    return InMemoryDb.absensiList.where((a) {
      final aDate = DateTime(a.tanggal.year, a.tanggal.month, a.tanggal.day);
      return aDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }

  @override
  Future<void> saveAbsensi(AbsensiModel absensi) async {
    if (absensi.id == Isar.autoIncrement || absensi.id == 0) {
      absensi.id = InMemoryDb.absensiList.length + 1;
      InMemoryDb.absensiList.add(absensi);
    } else {
      final index = InMemoryDb.absensiList.indexWhere((a) => a.id == absensi.id);
      if (index != -1) {
        InMemoryDb.absensiList[index] = absensi;
      }
    }
  }

  @override
  Future<void> saveMultipleAbsensi(List<AbsensiModel> absensiList) async {
    for (var a in absensiList) {
      await saveAbsensi(a);
    }
  }

  @override
  Future<void> saveBulkAbsensi({
    required List<int> karyawanIds,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final daysDiff = end.difference(start).inDays;

    for (int i = 0; i <= daysDiff; i++) {
      final currentDate = start.add(Duration(days: i));
      for (var karyawanId in karyawanIds) {
        final karyawanObj = InMemoryDb.karyawanList.firstWhere(
          (k) => k.id == karyawanId,
          orElse: () => KaryawanModel()..id = karyawanId,
        );

        final index = InMemoryDb.absensiList.indexWhere(
          (a) => a.karyawan.value?.id == karyawanId && 
                 DateTime(a.tanggal.year, a.tanggal.month, a.tanggal.day).isAtSameMomentAs(currentDate),
        );

        if (index != -1) {
          InMemoryDb.absensiList[index].status = status;
        } else {
          final newAbs = AbsensiModel()
            ..id = InMemoryDb.absensiList.length + 1
            ..tanggal = currentDate
            ..status = status;
          newAbs.karyawan.value = karyawanObj;
          InMemoryDb.absensiList.add(newAbs);
        }
      }
    }
  }
}

class LemburRepositoryMock implements LemburRepository {
  @override
  Future<List<LemburModel>> getLemburByTanggal(DateTime tanggal) async {
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    return InMemoryDb.lemburList.where((l) {
      final lDate = DateTime(l.tanggal.year, l.tanggal.month, l.tanggal.day);
      return lDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }

  @override
  Future<void> saveLembur(LemburModel lembur) async {
    if (lembur.id == Isar.autoIncrement || lembur.id == 0) {
      lembur.id = InMemoryDb.lemburList.length + 1;
      InMemoryDb.lemburList.add(lembur);
    } else {
      final index = InMemoryDb.lemburList.indexWhere((l) => l.id == lembur.id);
      if (index != -1) {
        InMemoryDb.lemburList[index] = lembur;
      }
    }
  }

  @override
  Future<void> saveMultipleLembur(List<LemburModel> lemburList) async {
    for (var l in lemburList) {
      await saveLembur(l);
    }
  }
}

class TransaksiTambahanRepositoryMock implements TransaksiTambahanRepository {
  @override
  Future<List<TransaksiTambahanModel>> getTransaksiByTanggal(DateTime tanggal) async {
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    return InMemoryDb.transaksiList.where((t) {
      final tDate = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
      return tDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }

  @override
  Future<List<TransaksiTambahanModel>> getTransaksiByPeriode(DateTime start, DateTime end) async {
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return InMemoryDb.transaksiList.where((t) {
      return t.tanggal.isAfter(startOnly.subtract(const Duration(seconds: 1))) &&
          t.tanggal.isBefore(endOnly.add(const Duration(seconds: 1)));
    }).toList();
  }

  @override
  Future<List<TransaksiTambahanModel>> getTransaksiByKaryawanAndPeriode(int karyawanId, DateTime start, DateTime end) async {
    final list = await getTransaksiByPeriode(start, end);
    return list.where((t) => t.karyawan.value?.id == karyawanId).toList();
  }

  @override
  Future<void> saveTransaksi(TransaksiTambahanModel transaksi) async {
    if (transaksi.id == Isar.autoIncrement || transaksi.id == 0) {
      transaksi.id = InMemoryDb.transaksiList.length + 1;
      InMemoryDb.transaksiList.add(transaksi);
    } else {
      final index = InMemoryDb.transaksiList.indexWhere((t) => t.id == transaksi.id);
      if (index != -1) {
        InMemoryDb.transaksiList[index] = transaksi;
      }
    }
  }

  @override
  Future<void> deleteTransaksi(int id) async {
    InMemoryDb.transaksiList.removeWhere((t) => t.id == id);
  }
}

class PenggajianRepositoryMock implements PenggajianRepository {
  @override
  Future<List<PenggajianModel>> getPenggajianAll() async {
    final list = List<PenggajianModel>.from(InMemoryDb.penggajianList);
    list.sort((a, b) => b.tanggalGajian.compareTo(a.tanggalGajian));
    return list;
  }

  @override
  Future<List<PenggajianModel>> getPenggajianByPeriode(DateTime start, DateTime end) async {
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return InMemoryDb.penggajianList.where((p) {
      return p.periodeMulai.isAtSameMomentAs(startOnly) &&
          p.periodeSelesai.isAtSameMomentAs(endOnly);
    }).toList();
  }

  @override
  Future<void> saveMultiplePenggajian(List<PenggajianModel> list) async {
    for (var p in list) {
      if (p.id == Isar.autoIncrement || p.id == 0) {
        p.id = InMemoryDb.penggajianList.length + 1;
        InMemoryDb.penggajianList.add(p);
      } else {
        final index = InMemoryDb.penggajianList.indexWhere((item) => item.id == p.id);
        if (index != -1) {
          InMemoryDb.penggajianList[index] = p;
        }
      }
    }
  }

  @override
  Future<void> deletePenggajian(int id) async {
    InMemoryDb.penggajianList.removeWhere((p) => p.id == id);
  }
}
