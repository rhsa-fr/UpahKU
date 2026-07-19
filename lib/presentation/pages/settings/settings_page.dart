import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/karyawan_provider.dart';
import '../../providers/penggajian_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaUsahaController;
  late TextEditingController _alamatUsahaController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _namaUsahaController = TextEditingController(text: settings.namaUsaha);
    _alamatUsahaController = TextEditingController(text: settings.alamatUsaha);
  }

  @override
  void dispose() {
    _namaUsahaController.dispose();
    _alamatUsahaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SettingsData>(settingsProvider, (previous, next) {
      _namaUsahaController.text = next.namaUsaha;
      _alamatUsahaController.text = next.alamatUsaha;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Profil Usaha
            Text(
              'Profil Usaha (Header Slip Gaji)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaUsahaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Usaha',
                      prefixIcon: Icon(Icons.storefront_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Nama usaha wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatUsahaController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Usaha',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Alamat usaha wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Simpan Profil'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            // Section: Tema / Tampilan
            Text(
              'Tampilan Aplikasi (Tema)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mode Tema',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined, size: 18),
                          label: Text('Terang', style: TextStyle(fontSize: 12)),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined, size: 18),
                          label: Text('Gelap', style: TextStyle(fontSize: 12)),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          icon: Icon(Icons.settings_suggest_outlined, size: 18),
                          label: Text('Sistem', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      selected: {ref.watch(themeModeProvider)},
                      onSelectionChanged: (Set<ThemeMode> newSelection) {
                        ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            if (!kIsWeb) ...[
              const SizedBox(height: 16),
              // Section 2: Backup & Restore
              Text(
                'Ekspor & Impor Data (Backup & Restore)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Semua data disimpan secara lokal. Lakukan backup berkala ke penyimpanan luar atau bagikan file cadangan agar data aman.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                      title: const Text('Ekspor Database (Backup)'),
                      subtitle: const Text('Simpan atau kirim file database (.isar)'),
                      onTap: _backupDatabase,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.cloud_download_outlined, color: Colors.green),
                      title: const Text('Impor Database (Restore)'),
                      subtitle: const Text('Pulihkan data dari file database backup'),
                      onTap: _restoreDatabase,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    
    ref.read(settingsProvider.notifier).saveSettings(
          namaUsaha: _namaUsahaController.text.trim(),
          alamatUsaha: _alamatUsahaController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil usaha berhasil disimpan.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _backupDatabase() async {
    try {
      final isarService = ref.read(isarServiceProvider);
      // We will backup the database file to the temporary directory
      final tempDir = await getTemporaryDirectory();
      final backupPath = await isarService.backupDb(tempDir.path);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(backupPath)],
        text: 'Backup Database UpahKu',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal melakukan backup: $e')),
        );
      }
    }
  }

  void _restoreDatabase() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Isar files are custom format, pick any file
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        
        if (!path.endsWith('.isar')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Format berkas tidak valid. Harap pilih berkas .isar.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Show confirmation dialog before restoring
        if (!mounted) return;
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Pulihkan Data (Restore)?'),
            content: const Text(
              'Peringatan: Seluruh data saat ini akan dihapus dan digantikan oleh data dari berkas cadangan ini. Apakah Anda yakin?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Impor & Ganti'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final isarService = ref.read(isarServiceProvider);
          final success = await isarService.restoreDb(path);

          if (success && mounted) {
            // Refresh all providers so the UI is updated immediately
            ref.invalidate(karyawanProvider);
            ref.invalidate(penggajianHistoryProvider);
            ref.invalidate(dashboardProvider);
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data database berhasil dipulihkan.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memulihkan database: $e')),
        );
      }
    }
  }
}
