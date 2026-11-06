import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaksi_tambahan_model.dart';
import '../../data/models/karyawan_model.dart';
import '../../data/repositories/transaksi_tambahan_repository_impl.dart';
import '../../data/repositories/mock_repositories.dart';
import '../../domain/repositories/transaksi_tambahan_repository.dart';
import 'karyawan_provider.dart';
import 'dashboard_provider.dart';

final transaksiTambahanRepositoryProvider = Provider<TransaksiTambahanRepository>((ref) {
  if (kIsWeb) {
    return TransaksiTambahanRepositoryMock();
  }
  final isarService = ref.watch(isarServiceProvider);
  return TransaksiTambahanRepositoryImpl(isarService);
});

class TransaksiTambahanNotifier extends StateNotifier<AsyncValue<List<TransaksiTambahanModel>>> {
  final TransaksiTambahanRepository _repository;
  final Ref _ref;
  final DateTime _tanggal;

  TransaksiTambahanNotifier(this._repository, this._ref, this._tanggal) : super(const AsyncValue.loading()) {
    loadTransaksi();
  }

  Future<void> loadTransaksi() async {
    try {
      final list = await _repository.getTransaksiByTanggal(_tanggal);
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTransaksi({
    required KaryawanModel karyawan,
    required double nominal,
    required String tipe,
    required String keterangan,
  }) async {
    state = const AsyncValue.loading();
    try {
      final tx = TransaksiTambahanModel()
        ..tanggal = DateTime(_tanggal.year, _tanggal.month, _tanggal.day)
        ..nominal = nominal
        ..tipe = tipe
        ..keterangan = keterangan;
      tx.karyawan.value = karyawan;
      
      await _repository.saveTransaksi(tx);
      await loadTransaksi();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTransaksi(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTransaksi(id);
      await loadTransaksi();
      _ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final transaksiTambahanProvider = StateNotifierProvider.family<
    TransaksiTambahanNotifier, AsyncValue<List<TransaksiTambahanModel>>, DateTime>((ref, tanggal) {
  final repo = ref.watch(transaksiTambahanRepositoryProvider);
  return TransaksiTambahanNotifier(repo, ref, tanggal);
});
