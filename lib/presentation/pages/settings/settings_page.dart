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
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../widgets/ds/design_system.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaUsaha;
  late final TextEditingController _alamatUsaha;

  @override
  void initState() {
    super.initState();
    final SettingsData settings = ref.read(settingsProvider);
    _namaUsaha = TextEditingController(text: settings.namaUsaha);
    _alamatUsaha = TextEditingController(text: settings.alamatUsaha);
  }

  @override
  void dispose() {
    _namaUsaha.dispose();
    _alamatUsaha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SettingsData>(settingsProvider, (SettingsData? _, SettingsData next) {
      _namaUsaha.text = next.namaUsaha;
      _alamatUsaha.text = next.alamatUsaha;
    });

    final ColorScheme s = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: s.surface,
      appBar: AppBar(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Pengaturan',
          style: AppTypography.headlineMd.copyWith(color: s.onSurface),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.margin,
          AppSpacing.sm,
          AppSpacing.margin,
          AppSpacing.xl,
        ),
        children: [
          DsCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'PROFIL USAHA',
                    style: AppTypography.labelMd.copyWith(
                      color: s.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Dipakai sebagai header slip gaji PDF.',
                    style: AppTypography.bodyMd.copyWith(color: s.outline),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _namaUsaha,
                    decoration: const InputDecoration(
                      labelText: 'Nama Usaha',
                      prefixIcon: Icon(Icons.storefront_rounded),
                    ),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Nama usaha wajib diisi' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _alamatUsaha,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Usaha',
                      prefixIcon: Icon(Icons.location_on_rounded),
                    ),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Alamat usaha wajib diisi' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: const Text('Simpan Profil'),
                  ),
                ],
              ),
            ),
          ),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TAMPILAN APLIKASI',
                  style: AppTypography.labelMd.copyWith(
                    color: s.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: s.primary,
                    selectedForegroundColor: s.onPrimary,
                  ),
                  segments: const [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_rounded, size: 18),
                      label: Text('Terang'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_rounded, size: 18),
                      label: Text('Gelap'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      icon: Icon(Icons.settings_suggest_rounded, size: 18),
                      label: Text('Sistem'),
                    ),
                  ],
                  selected: {ref.watch(themeModeProvider)},
                  onSelectionChanged: (Set<ThemeMode> sel) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(sel.first),
                ),
              ],
            ),
          ),
          if (!kIsWeb)
            DsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'BACKUP & RESTORE',
                    style: AppTypography.labelMd.copyWith(
                      color: s.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Semua data tersimpan lokal. Backup berkala agar aman.',
                    style: AppTypography.bodyMd.copyWith(color: s.outline),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DsActionTile(
                    icon: Icons.cloud_upload_rounded,
                    tone: DsTone.info,
                    title: 'Ekspor Database',
                    subtitle: 'Simpan atau kirim file .isar',
                    onTap: _backupDatabase,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DsActionTile(
                    icon: Icons.cloud_download_rounded,
                    tone: DsTone.success,
                    title: 'Impor Database',
                    subtitle: 'Pulihkan data dari file backup',
                    onTap: _restoreDatabase,
                  ),
                ],
              ),
            ),
          DsInset(
            child: Row(
              children: [
                Icon(Icons.offline_bolt_rounded, size: 18, color: s.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'UpahKu berjalan 100% offline. Tidak ada data yang dikirim ke internet.',
                    style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(settingsProvider.notifier).saveSettings(
          namaUsaha: _namaUsaha.text.trim(),
          alamatUsaha: _alamatUsaha.text.trim(),
        );
    _toast('Profil usaha berhasil disimpan.', AppColors.success);
  }

  void _toast(String message, [Color? bg]) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bg ?? Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }

  Future<void> _backupDatabase() async {
    final Color error = Theme.of(context).colorScheme.error;
    try {
      final isarService = ref.read(isarServiceProvider);
      final String tempDir = (await getTemporaryDirectory()).path;
      final String backupPath = await isarService.backupDb(tempDir);
      await Share.shareXFiles(
        <XFile>[XFile(backupPath)],
        text: 'Backup Database UpahKu',
      );
    } catch (e) {
      _toast('Gagal melakukan backup: $e', error);
    }
  }

  Future<void> _restoreDatabase() async {
    final ColorScheme s = Theme.of(context).colorScheme;
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      final String? path = result?.files.single.path;
      if (path == null) return;

      if (!path.endsWith('.isar')) {
        _toast('Format berkas tidak valid. Pilih berkas .isar.', s.error);
        return;
      }

      if (!mounted) return;
      final bool confirmed = await showDialog<bool>(
            context: context,
            builder: (BuildContext ctx) => AlertDialog(
              title: const Text('Pulihkan Data (Restore)?'),
              content: const Text(
                'Seluruh data saat ini akan dihapus dan digantikan oleh data dari '
                'berkas cadangan ini. Tindakan ini tidak dapat dibatalkan.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                    foregroundColor: Theme.of(ctx).colorScheme.onError,
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Impor & Ganti'),
                ),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;

      final success = await ref.read(isarServiceProvider).restoreDb(path);
      if (success && mounted) {
        ref.invalidate(karyawanProvider);
        ref.invalidate(penggajianHistoryProvider);
        ref.invalidate(dashboardProvider);
        _toast('Data database berhasil dipulihkan.', AppColors.success);
      }
    } catch (e) {
      _toast('Gagal memulihkan database: $e', s.error);
    }
  }
}
