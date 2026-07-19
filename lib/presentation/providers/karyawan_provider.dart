import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/isar_service.dart';
import '../../data/datasources/local/isar_service_impl.dart';
import '../../data/repositories/karyawan_repository_impl.dart';
import '../../data/repositories/mock_repositories.dart';
import '../../domain/repositories/karyawan_repository.dart';
import '../../data/models/karyawan_model.dart';
import 'dashboard_provider.dart';

// 1. Provider for IsarService
final isarServiceProvider = Provider<IsarService>((ref) {
  final service = IsarServiceImpl();
  ref.onDispose(() => service.close());
  return service;
});

// 2. Provider for KaryawanRepository
final karyawanRepositoryProvider = Provider<KaryawanRepository>((ref) {
  if (kIsWeb) {
    return KaryawanRepositoryMock();
  }
  final isarService = ref.watch(isarServiceProvider);
  return KaryawanRepositoryImpl(isarService);
});

// 3. StateNotifierProvider for managing Karyawan list
class KaryawanNotifier extends StateNotifier<AsyncValue<List<KaryawanModel>>> {
  final KaryawanRepository _repository;
  final Ref _ref;

  KaryawanNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    loadKaryawan();
  }

  Future<void> loadKaryawan() async {
    try {
      final list = await _repository.getKaryawanAll();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addKaryawan({
    required String nama,
    required String jabatan,
    required double upahHarian,
    required double tarifLembur,
  }) async {
    state = const AsyncValue.loading();
    try {
      final karyawan = KaryawanModel()
        ..nama = nama
        ..jabatan = jabatan
        ..upahHarian = upahHarian
        ..tarifLembur = tarifLembur
        ..statusAktif = true
        ..createdAt = DateTime.now();

      await _repository.saveKaryawan(karyawan);
      await loadKaryawan();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateKaryawan(KaryawanModel karyawan) async {
    state = const AsyncValue.loading();
    try {
      await _repository.saveKaryawan(karyawan);
      await loadKaryawan();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteKaryawan(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteKaryawan(id);
      await loadKaryawan();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final karyawanProvider = StateNotifierProvider<KaryawanNotifier, AsyncValue<List<KaryawanModel>>>((ref) {
  final repo = ref.watch(karyawanRepositoryProvider);
  return KaryawanNotifier(repo, ref);
});
