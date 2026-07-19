import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/absensi_model.dart';
import '../../data/models/karyawan_model.dart';
import '../../data/repositories/absensi_repository_impl.dart';
import '../../data/repositories/mock_repositories.dart';
import '../../domain/repositories/absensi_repository.dart';
import 'karyawan_provider.dart';
import 'dashboard_provider.dart';

final absensiRepositoryProvider = Provider<AbsensiRepository>((ref) {
  if (kIsWeb) {
    return AbsensiRepositoryMock();
  }
  final isarService = ref.watch(isarServiceProvider);
  return AbsensiRepositoryImpl(isarService);
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class AbsensiNotifier extends StateNotifier<AsyncValue<List<AbsensiModel>>> {
  final AbsensiRepository _repository;
  final Ref _ref;
  final DateTime _tanggal;

  AbsensiNotifier(this._repository, this._ref, this._tanggal) : super(const AsyncValue.loading()) {
    loadAbsensi();
  }

  Future<void> loadAbsensi() async {
    try {
      final existingAbsensi = await _repository.getAbsensiByTanggal(_tanggal);
      
      final karyawanState = _ref.read(karyawanProvider);
      final activeEmployees = karyawanState.maybeWhen(
        data: (list) => list.where((k) => k.statusAktif).toList(),
        orElse: () => <KaryawanModel>[],
      );

      final dateOnly = DateTime(_tanggal.year, _tanggal.month, _tanggal.day);

      if (existingAbsensi.isEmpty && activeEmployees.isNotEmpty) {
        final List<AbsensiModel> defaultList = [];
        for (var karyawan in activeEmployees) {
          final absensi = AbsensiModel()
            ..tanggal = dateOnly
            ..status = 'Hadir';
          absensi.karyawan.value = karyawan;
          defaultList.add(absensi);
        }
        state = AsyncValue.data(defaultList);
      } else {
        final List<AbsensiModel> mergedList = List.from(existingAbsensi);
        for (var karyawan in activeEmployees) {
          final hasRecord = existingAbsensi.any((a) => a.karyawan.value?.id == karyawan.id);
          if (!hasRecord) {
            final absensi = AbsensiModel()
              ..tanggal = dateOnly
              ..status = 'Hadir';
            absensi.karyawan.value = karyawan;
            mergedList.add(absensi);
          }
        }
        state = AsyncValue.data(mergedList);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateStatus(int employeeId, String newStatus) async {
    state.whenData((list) async {
      final updatedList = list.map((absensi) {
        if (absensi.karyawan.value?.id == employeeId) {
          final newAbs = AbsensiModel()
            ..id = absensi.id
            ..tanggal = absensi.tanggal
            ..status = newStatus;
          newAbs.karyawan.value = absensi.karyawan.value;
          return newAbs;
        }
        return absensi;
      }).toList();
      state = AsyncValue.data(updatedList);
      
      // Auto-save immediately to database
      await _repository.saveMultipleAbsensi(updatedList);
      
      // Force dashboard statistics refresh
      _ref.invalidate(dashboardProvider);
    });
  }

  Future<void> save() async {
    final list = state.value;
    if (list != null && list.isNotEmpty) {
      await _repository.saveMultipleAbsensi(list);
      await loadAbsensi();
      _ref.invalidate(dashboardProvider);
    }
  }
}

final absensiProvider = StateNotifierProvider.family<AbsensiNotifier, AsyncValue<List<AbsensiModel>>, DateTime>((ref, tanggal) {
  final repo = ref.watch(absensiRepositoryProvider);
  return AbsensiNotifier(repo, ref, tanggal);
});
