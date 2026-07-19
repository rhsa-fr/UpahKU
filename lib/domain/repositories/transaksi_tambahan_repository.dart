import '../../data/models/transaksi_tambahan_model.dart';

abstract class TransaksiTambahanRepository {
  Future<List<TransaksiTambahanModel>> getTransaksiByTanggal(DateTime tanggal);
  Future<List<TransaksiTambahanModel>> getTransaksiByPeriode(DateTime start, DateTime end);
  Future<List<TransaksiTambahanModel>> getTransaksiByKaryawanAndPeriode(int karyawanId, DateTime start, DateTime end);
  Future<void> saveTransaksi(TransaksiTambahanModel transaksi);
  Future<void> deleteTransaksi(int id);
}
