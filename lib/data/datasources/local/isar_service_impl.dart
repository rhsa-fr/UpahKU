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
  /// Satu instance untuk seluruh aplikasi.
  ///
  /// Isar mendaftarkan instance ke registry global *sebelum* collections
  /// di-attach. Kalau dua service dibuat terpisah, keduanya bisa saling
  /// menimpa registry dan menyisakan instance "zombie".
  static final IsarServiceImpl _singleton = IsarServiceImpl._();

  factory IsarServiceImpl() => _singleton;

  IsarServiceImpl._();

  static const String _dbName = 'upahku_db';

  Isar? _isar;
  Future<void>? _initFuture;

  @override
  Future<Isar> get db async {
    final Isar? current = _isar;
    if (current != null && _isHealthy(current)) return current;

    await init();

    final Isar? opened = _isar;
    if (opened == null || !opened.isOpen) {
      throw StateError(
        'Database lokal belum siap. Tutup lalu buka kembali aplikasi.',
      );
    }
    return opened;
  }

  @override
  Future<void> init() async {
    final Future<void>? inFlight = _initFuture;
    if (inFlight != null) {
      await inFlight;
      return;
    }

    final Future<void> future = _doInit();
    _initFuture = future;
    try {
      await future;
    } finally {
      if (identical(_initFuture, future)) _initFuture = null;
    }
  }

  /// Instance dianggap sehat kalau collections-nya benar-benar ter-attach.
  ///
  /// `Isar.getInstance` bisa mengembalikan instance yang sudah terdaftar tapi
  /// gagal menyelesaikan `attachCollections`. Memakainya akan melempar
  /// `LateInitializationError: Field '_collections' has not been initialized`
  /// pada setiap query.
  bool _isHealthy(Isar isar) {
    if (!isar.isOpen) return false;
    try {
      isar.collection<KaryawanModel>();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _doInit() async {
    final Isar? current = _isar;
    if (current != null && _isHealthy(current)) return;
    if (current != null) _isar = null;

    // Adopsi instance yang masih hidup (mis. setelah hot restart) hanya kalau
    // benar-benar sehat; kalau tidak, tutup supaya namanya lepas dari registry.
    final Isar? existing = Isar.getInstance(_dbName);
    if (existing != null) {
      if (_isHealthy(existing)) {
        _isar = existing;
        return;
      }
      try {
        await existing.close();
      } catch (e) {
        debugPrint('Gagal menutup instance Isar yang rusak: $e');
      }
    }

    String path = '';
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }

    final Isar opened = await Isar.open(
      [
        KaryawanModelSchema,
        AbsensiModelSchema,
        LemburModelSchema,
        TransaksiTambahanModelSchema,
        PenggajianModelSchema,
      ],
      name: _dbName,
      directory: path,
      inspector: kDebugMode && !kIsWeb, // ONLY enable inspector in debug mode
    );

    if (!_isHealthy(opened)) {
      // Jangan pernah pakai instance setengah jadi: semua query akan gagal.
      try {
        await opened.close();
      } catch (e) {
        debugPrint('Gagal menutup instance Isar yang tidak sehat: $e');
      }
      throw StateError(
        'Database lokal tidak bisa dibuka. Restart aplikasi lalu coba lagi.',
      );
    }

    _isar = opened;
  }

  @override
  Future<void> close() async {
    final Isar? current = _isar;
    _isar = null;
    if (current != null && current.isOpen) {
      await current.close();
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

    final backupFile = File(
      '$targetDir/upahku_backup_${DateTime.now().millisecondsSinceEpoch}.isar',
    );
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
    final currentDbFile = File('${dir.path}/$_dbName.isar');
    final lockFile = File('${dir.path}/$_dbName.isar.lock');

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
