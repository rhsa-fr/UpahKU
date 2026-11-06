import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/ds/design_system.dart';
import '../../widgets/ds/ds_app_header.dart';
import '../riwayat/riwayat_page.dart';
import '../settings/settings_page.dart';

/// Menu lengkap + pengaturan. Ini "rumah" untuk fitur yang tidak muat di 4 tab.
class LainnyaPage extends ConsumerWidget {
  const LainnyaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final SettingsData settings = ref.watch(settingsProvider);
    final ThemeMode mode = ref.watch(themeModeProvider);

    return DsPage(
      header: DsAppHeader(
        title: 'UpahKu',
        subtitle: 'Menu & Pengaturan',
        onAvatarTap: () => _push(context, const SettingsPage()),
      ),
      slivers: [
        _ProfileCard(namaUsaha: settings.namaUsaha, alamat: settings.alamatUsaha),
        Row(
          children: [
            Expanded(
              child: Text(
                'Semua fitur',
                style: AppTypography.headlineMd.copyWith(color: s.onSurface),
              ),
            ),
            DsPill(label: '8 Menu', tone: DsTone.neutral),
          ],
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.92,
          children: [
            _MenuTile(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Slip PDF',
              tone: s.onSurface,
              onTap: () => _push(context, const RiwayatPage()),
            ),
            _MenuTile(
              icon: Icons.save_outlined,
              label: 'Backup',
              tone: s.onSurface,
              onTap: () => _push(context, const SettingsPage()),
            ),
            _MenuTile(
              icon: Icons.upload_file_outlined,
              label: 'Impor',
              tone: s.onSurface,
              onTap: () => _push(context, const SettingsPage()),
            ),
            _MenuTile(
              icon: Icons.palette_outlined,
              label: 'Tema',
              tone: s.onSurface,
              onTap: () => _showThemeSheet(context, ref),
            ),
            _MenuTile(
              icon: Icons.person_outline_rounded,
              label: 'Profil',
              tone: s.onSurface,
              onTap: () => _push(context, const SettingsPage()),
            ),
            _MenuTile(
              icon: Icons.menu_book_outlined,
              label: 'Panduan',
              tone: s.onSurface,
              onTap: () => _showGuide(context),
            ),
            _MenuTile(
              icon: Icons.shield_outlined,
              label: 'Tentang',
              tone: s.onSurface,
              onTap: () => _showAbout(context),
            ),
            _MenuTile(
              icon: Icons.wifi_off_rounded,
              label: 'Offline',
              tone: s.onSurface,
              onTap: () => _showOffline(context),
            ),
          ],
        ),
        Text(
          'Tema',
          style: AppTypography.headlineMd.copyWith(color: s.onSurface),
        ),
        DsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih tampilan aplikasi',
                style: AppTypography.bodyMd.copyWith(color: s.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Terang'),
                      icon: Icon(Icons.light_mode_outlined, size: 16),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Gelap'),
                      icon: Icon(Icons.dark_mode_outlined, size: 16),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('Sistem'),
                      icon: Icon(Icons.brightness_auto_outlined, size: 16),
                    ),
                  ],
                  selected: <ThemeMode>{mode},
                  onSelectionChanged: (Set<ThemeMode> value) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value.first);
                  },
                ),
              ),
            ],
          ),
        ),
        DsActionTile(
          icon: Icons.save_outlined,
          tone: DsTone.neutral,
          title: 'Ekspor database',
          subtitle: 'Simpan atau kirim file .isar',
          onTap: () => _push(context, const SettingsPage()),
        ),
        DsActionTile(
          icon: Icons.upload_file_outlined,
          tone: DsTone.neutral,
          title: 'Impor database',
          subtitle: 'Pulihkan data dari file backup',
          onTap: () => _push(context, const SettingsPage()),
        ),
        DsActionTile(
          icon: Icons.menu_book_outlined,
          tone: DsTone.neutral,
          title: 'Panduan',
          subtitle: '6 fitur utama UpahKu',
          onTap: () => _showGuide(context),
        ),
        DsActionTile(
          icon: Icons.info_outline_rounded,
          tone: DsTone.neutral,
          title: 'Tentang',
          subtitle: 'UpahKu v1.0.0 · data lokal',
          onTap: () => _showAbout(context),
        ),
        Center(
          child: Text(
            'Semua data tersimpan di perangkat · tanpa server',
            style: AppTypography.labelMd.copyWith(
              color: s.onSurfaceVariant,
              fontSize: 10.5,
            ),
          ),
        ),
      ],
    );
  }

  static void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  static void _showThemeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext ctx) {
        final ThemeMode current = ref.read(themeModeProvider);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (ThemeMode, String, IconData) option in <(ThemeMode, String, IconData)>[
                (ThemeMode.light, 'Terang', Icons.light_mode_outlined),
                (ThemeMode.dark, 'Gelap', Icons.dark_mode_outlined),
                (ThemeMode.system, 'Sistem', Icons.brightness_auto_outlined),
              ])
                ListTile(
                  leading: Icon(option.$3),
                  title: Text(option.$2),
                  trailing: current == option.$1 ? const Icon(Icons.check_rounded) : null,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(option.$1);
                    Navigator.of(ctx).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  static void _showGuide(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Panduan UpahKu'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GuideRow(icon: Icons.badge_outlined, text: 'Data karyawan & upah harian'),
            _GuideRow(icon: Icons.fact_check_outlined, text: 'Absensi harian: Hadir, Izin, Sakit, Alfa'),
            _GuideRow(icon: Icons.schedule_outlined, text: 'Lembur per orang, otomatis masuk hitungan'),
            _GuideRow(icon: Icons.add_card_outlined, text: 'Bonus, potongan, dan kasbon'),
            _GuideRow(icon: Icons.picture_as_pdf_outlined, text: 'Slip gaji PDF siap dibagikan'),
            _GuideRow(icon: Icons.save_outlined, text: 'Backup & impor database .isar'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Tutup')),
        ],
      ),
    );
  }

  static void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'UpahKu',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Payroll harian offline untuk UMKM Indonesia.',
      children: const [
        SizedBox(height: 8),
        Text('Semua data tersimpan di perangkat. Tidak ada server, tidak ada akun.'),
      ],
    );
  }

  static void _showOffline(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Mode offline'),
        content: const Text(
          'UpahKu berjalan 100% tanpa internet. Data karyawan, absensi, lembur, dan slip gaji disimpan di database lokal perangkat.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Mengerti')),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.namaUsaha, required this.alamat});

  final String namaUsaha;
  final String alamat;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final String initials = namaUsaha.isEmpty
        ? 'UK'
        : namaUsaha
            .split(' ')
            .where((String e) => e.isNotEmpty)
            .take(2)
            .map((String e) => e[0])
            .join()
            .toUpperCase();

    return DsCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: s.primary,
              borderRadius: AppRadius.rMd,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: AppTypography.titleMd.copyWith(
                color: s.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaUsaha.isEmpty ? 'UpahKu' : namaUsaha,
                  style: AppTypography.titleMd.copyWith(
                    color: s.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  alamat.isEmpty ? 'Data lokal · tanpa server' : alamat,
                  style: AppTypography.labelMd.copyWith(
                    color: s.onSurfaceVariant,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          DsPill(label: 'Owner', tone: DsTone.secondary, dense: true),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.tone,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return Material(
      color: s.surfaceContainerLowest,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            border: Border.all(color: s.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 21, color: tone),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.labelMd.copyWith(
                  color: s.onSurface,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
