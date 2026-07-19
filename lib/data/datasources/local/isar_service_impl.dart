import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'isar_service.dart';
import '../../models/karyawan_model.dart';
import '../../models/absensi_model.dart';
import '../../models/lembur_model.dart';
import '../../models/transaksi_tambahan_model.dart';
import '../../models/penggajian_model.dart';

class IsarServiceImpl implements IsarService {
  Isar? _isar;
  Future<void>? _initFuture;

  @override
  Future<Isar> get db async {
    if (_isar == null || !_isar!.isOpen) {
      await init();
    }
    return _isar!;
  }

  @override
  Future<void> init() async {
    if (_initFuture != null) {
      await _initFuture;
      return;
    }

    _initFuture = _doInit();
    try {
      await _initFuture;
    } finally {
      _initFuture = null;
    }
  }

  Future<void> _doInit() async {
    if (_isar != null && _isar!.isOpen) return;

    // Check if the default Isar instance is already open globally (common during hot restarts)
    final existingInstance = Isar.getInstance();
    if (existingInstance != null && existingInstance.isOpen) {
      _isar = existingInstance;
      return;
    }

    String path = '';
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }

    try {
      _isar = await Isar.open(
        [
          KaryawanModelSchema,
          AbsensiModelSchema,
          LemburModelSchema,
          TransaksiTambahanModelSchema,
          PenggajianModelSchema,
        ],
        directory: path,
        inspector: !kIsWeb,
      );
    } catch (e) {
      // If Isar.open failed (e.g. because it was opened concurrently), check if it's open now
      final fallbackInstance = Isar.getInstance();
      if (fallbackInstance != null && fallbackInstance.isOpen) {
        _isar = fallbackInstance;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  @override
  Future<String> backupDb(String targetDir) async {
    final isarDb = await db;
    
    // Isar default database file name is 'default.isar' unless specified otherwise in Isar.open.
    // Ensure the target directory exists.
    final targetDirectory = Directory(targetDir);
    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    final backupFile = File('$targetDir/dailypayroll_backup_${DateTime.now().millisecondsSinceEpoch}.isar');
    if (await backupFile.exists()) {
      await backupFile.delete();
    }
    
    // copyToFile copies the Isar file to target path
    await isarDb.copyToFile(backupFile.path);
    return backupFile.path;
  }

  @override
  Future<bool> restoreDb(String backupFilePath) async {
    final backupFile = File(backupFilePath);
    if (!await backupFile.exists()) return false;

    // To restore:
    // 1. Close current Isar
    // 2. Overwrite default.isar with backup
    // 3. Reinitialize
    await close();

    final dir = await getApplicationDocumentsDirectory();
    final currentDbFile = File('${dir.path}/default.isar');
    
    // Overwrite default.isar
    if (await currentDbFile.exists()) {
      await currentDbFile.delete();
    }
    
    await backupFile.copy(currentDbFile.path);
    
    await init();
    return true;
  }
}
