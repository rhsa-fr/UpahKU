import '../../data/models/lembur_model.dart';

abstract class LemburRepository {
  Future<List<LemburModel>> getLemburByTanggal(DateTime tanggal);
  Future<void> saveLembur(LemburModel lembur);
  Future<void> saveMultipleLembur(List<LemburModel> lemburList);
}
