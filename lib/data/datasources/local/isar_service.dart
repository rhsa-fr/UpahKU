import 'package:isar/isar.dart';

abstract class IsarService {
  Future<Isar> get db;
  Future<void> init();
  Future<void> close();
  Future<String> backupDb(String targetDir);
  Future<bool> restoreDb(String backupFilePath);
}
