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

    // Check if the 'upahku_db' Isar instance is already open globally (common during hot restarts)
    final existingInstance = Isar.getInstance('upahku_db');
    if (existingInstance != null && existingInstance.isOpen) {
      _isar = existingInstance;
      return;
    }

    String path = '';
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }

    _isar = await Isar.open(
      [
        KaryawanModelSchema,
        AbsensiModelSchema,
        LemburModelSchema,
        TransaksiTambahanModelSchema,
        PenggajianModelSchema,
      ],
      name: 'upahku_db',
      directory: path,
      inspector: kDebugMode && !kIsWeb, // ONLY enable inspector in debug mode
    );
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
    
    // Ensure the target directory exists.
    final targetDirectory = Directory(targetDir);
    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    final backupFile = File('$targetDir/upahku_backup_${DateTime.now().millisecondsSinceEpoch}.isar');
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
    // 2. Overwrite upahku_db.isar with backup
    // 3. Reinitialize
    await close();

    final dir = await getApplicationDocumentsDirectory();
    final currentDbFile = File('${dir.path}/upahku_db.isar');
    final lockFile = File('${dir.path}/upahku_db.isar.lock');
    
    // Overwrite upahku_db.isar
    if (await currentDbFile.exists()) {
      await currentDbFile.delete();
    }
    if (await lockFile.exists()) {
      await lockFile.delete();
    }
    
    await backupFile.copy(currentDbFile.path);
    
    await init();
    return true;
  }
}
