import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/penggajian_model.dart';
import '../../providers/penggajian_provider.dart';
import '../../widgets/ds/design_system.dart';
import '../../widgets/ds/ds_app_header.dart';
import '../penggajian/detail_gaji_page.dart';
import '../penggajian/hitung_gaji_page.dart';
import '../riwayat/riwayat_page.dart';
import '../settings/settings_page.dart';

/// Gaji hub: dua pintu (proses & arsip) plus ringkasan.
/// Menggantikan tab lama yang labelnya "Penggajian" tapi isinya Riwayat.
class GajiHubPage extends ConsumerWidget {
  const GajiHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final AsyncValue<List<PenggajianModel>> state = ref.watch(penggajianHistoryProvider);
    final List<PenggajianModel> list = state.valueOrNull ?? const <PenggajianModel>[];
    final double total = list.fold<double>(0, (a, b) => a + b.totalGajiBersih);
    final List<PenggajianModel> recent = list.take(3).toList();

    return DsPage(
      header: DsAppHeader(
        title: 'UpahKu',
        subtitle: 'Gaji & Arsip',
        onAvatarTap: () => _push(context, const SettingsPage()),
      ),
      refresh: () => ref.read(penggajianHistoryProvider.notifier).loadHistory(),
      slivers: [
        DsCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          color: s.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL DIBAYAR',
                style: AppTypography.labelMd.copyWith(
                  color: s.onPrimary.withValues(alpha: 0.68),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                CurrencyFormatter.format(total),
                style: AppTypography.displayLg.copyWith(
                  fontSize: 34,
                  height: 1.05,
                  color: s.onPrimary,
                  fontFeatures: AppTypography.tabular,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _HeroMeta(icon: Icons.receipt_long_rounded, label: '${list.length} slip', color: s.onPrimary),
                  const SizedBox(width: AppSpacing.lg),
                  _HeroMeta(icon: Icons.history_rounded, label: '${recent.length} periode terakhir', color: s.onPrimary),
                ],
              ),
            ],
          ),
        ),
        _ActionCard(
          icon: Icons.calculate_rounded,
          title: 'Proses penggajian',
          subtitle: 'Pilih periode, hitung kolektif, lalu simpan & bayar.',
          tone: s.secondary,
          onTap: () => _push(context, const HitungGajiPage()),
        ),
        _ActionCard(
          icon: Icons.inventory_2_outlined,
          title: 'Riwayat & arsip',
          subtitle: 'Buka slip PDF, cetak ulang, atau hapus periode lama.',
          tone: s.tertiary,
          onTap: () => _push(context, const RiwayatPage()),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Arsip terakhir',
                style: AppTypography.headlineMd.copyWith(color: s.onSurface),
              ),
            ),
            DsPill(label: '${list.length} Slip', tone: DsTone.neutral),
          ],
        ),
        if (recent.isEmpty)
          DsEmptyState(
            icon: Icons.history_toggle_off_rounded,
            title: 'Belum ada arsip',
            subtitle: 'Hitung gaji kolektif lalu simpan slipnya di sini.',
            action: FilledButton.icon(
              onPressed: () => _push(context, const HitungGajiPage()),
              icon: const Icon(Icons.calculate_rounded, size: 18),
              label: const Text('Hitung Gaji'),
            ),
          )
        else
          ...recent.map(
            (PenggajianModel p) => _ArchiveRow(
              penggajian: p,
              onTap: () => _push(context, DetailGajiPage(penggajian: p)),
            ),
          ),
      ],
    );
  }

  static void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.withValues(alpha: 0.72)),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: color.withValues(alpha: 0.78),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return Material(
      color: s.surfaceContainerLowest,
      borderRadius: AppRadius.rLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rLg,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rLg,
            border: Border.all(color: s.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.14),
                  borderRadius: AppRadius.rMd,
                ),
                child: Icon(icon, size: 22, color: tone),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleMd.copyWith(color: s.onSurface, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: AppTypography.bodyMd.copyWith(color: s.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: s.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveRow extends StatelessWidget {
  const _ArchiveRow({required this.penggajian, required this.onTap});

  final PenggajianModel penggajian;
  final VoidCallback onTap;

  static String _initials(String name) {
    final List<String> parts = name
        .replaceAll('H. ', '')
        .split(' ')
        .where((String e) => e.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final String nama = penggajian.karyawan.value?.nama ?? 'Karyawan';
    final String periode =
        '${DateFormatter.formatShort(penggajian.periodeMulai)} — ${DateFormatter.formatShort(penggajian.periodeSelesai)}';

    return Material(
      color: s.surfaceContainerLowest,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            border: Border.all(color: s.outlineVariant),
          ),
          child: Row(
            children: [
              DsAvatar(initials: _initials(nama), size: 34),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: AppTypography.bodyMd.copyWith(color: s.onSurface, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(periode, style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant, fontSize: 10.5)),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(penggajian.totalGajiBersih),
                style: AppTypography.labelLg.copyWith(
                  color: s.onSurface,
                  fontFeatures: AppTypography.tabular,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, size: 18, color: s.outline),
            ],
          ),
        ),
      ),
    );
  }
}
