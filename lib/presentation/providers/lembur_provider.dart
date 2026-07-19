import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/lembur_model.dart';
import '../../data/models/karyawan_model.dart';
import '../../data/repositories/lembur_repository_impl.dart';
import '../../data/repositories/mock_repositories.dart';
import '../../domain/repositories/lembur_repository.dart';
import 'karyawan_provider.dart';
import 'absensi_provider.dart';
import 'dashboard_provider.dart';

final lemburRepositoryProvider = Provider<LemburRepository>((ref) {
  if (kIsWeb) {
    return LemburRepositoryMock();
  }
  final isarService = ref.watch(isarServiceProvider);
  return LemburRepositoryImpl(isarService);
});

class LemburNotifier extends StateNotifier<AsyncValue<List<LemburModel>>> {
  final LemburRepository _repository;
  final Ref _ref;
  final DateTime _tanggal;

  LemburNotifier(this._repository, this._ref, this._tanggal) : super(const AsyncValue.loading()) {
    loadLembur();
  }

  Future<void> loadLembur() async {
    try {
      final existingLembur = await _repository.getLemburByTanggal(_tanggal);
      
      final karyawanState = _ref.read(karyawanProvider);
      final activeEmployees = karyawanState.maybeWhen(
        data: (list) => list.where((k) => k.statusAktif).toList(),
        orElse: () => <KaryawanModel>[],
      );

      final dateOnly = DateTime(_tanggal.year, _tanggal.month, _tanggal.day);

      if (existingLembur.isEmpty && activeEmployees.isNotEmpty) {
        final List<LemburModel> defaultList = [];
        for (var karyawan in activeEmployees) {
          final lembur = LemburModel()
            ..tanggal = dateOnly
            ..jumlahJam = 0.0;
          lembur.karyawan.value = karyawan;
          defaultList.add(lembur);
        }
        state = AsyncValue.data(defaultList);
      } else {
        final List<LemburModel> mergedList = List.from(existingLembur);
        for (var karyawan in activeEmployees) {
          final hasRecord = existingLembur.any((l) => l.karyawan.value?.id == karyawan.id);
          if (!hasRecord) {
            final lembur = LemburModel()
              ..tanggal = dateOnly
              ..jumlahJam = 0.0;
            lembur.karyawan.value = karyawan;
            mergedList.add(lembur);
          }
        }
        state = AsyncValue.data(mergedList);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateHours(int employeeId, double hours) async {
    state.whenData((list) async {
      final updatedList = list.map((lembur) {
        if (lembur.karyawan.value?.id == employeeId) {
          final newLembur = LemburModel()
            ..id = lembur.id
            ..tanggal = lembur.tanggal
            ..jumlahJam = hours;
          newLembur.karyawan.value = lembur.karyawan.value;
          return newLembur;
        }
        return lembur;
      }).toList();
      state = AsyncValue.data(updatedList);
      
      // Auto-save immediately to database
      await _repository.saveMultipleLembur(updatedList);
      
      // Force dashboard statistics refresh
      _ref.invalidate(dashboardProvider);
    });
  }

  Future<void> save() async {
    final list = state.value;
    if (list != null && list.isNotEmpty) {
      await _repository.saveMultipleLembur(list);
      await loadLembur();
      _ref.invalidate(dashboardProvider);
    }
  }
}

final lemburProvider = StateNotifierProvider.family<LemburNotifier, AsyncValue<List<LemburModel>>, DateTime>((ref, tanggal) {
  final repo = ref.watch(lemburRepositoryProvider);
  return LemburNotifier(repo, ref, tanggal);
});
