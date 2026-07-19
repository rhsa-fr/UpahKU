import '../../data/models/penggajian_model.dart';

abstract class PenggajianRepository {
  Future<List<PenggajianModel>> getPenggajianAll();
  Future<List<PenggajianModel>> getPenggajianByPeriode(DateTime start, DateTime end);
  Future<void> saveMultiplePenggajian(List<PenggajianModel> list);
  Future<void> deletePenggajian(int id);
}
