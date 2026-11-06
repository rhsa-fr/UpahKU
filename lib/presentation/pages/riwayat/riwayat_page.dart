import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/penggajian_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/penggajian_model.dart';
import '../../widgets/ds/ds_app_header.dart';
import '../../widgets/ds/design_system.dart';
import '../penggajian/hitung_gaji_page.dart';
import '../penggajian/detail_gaji_page.dart';

class RiwayatPage extends ConsumerWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PenggajianModel>> state = ref.watch(penggajianHistoryProvider);
    final List<PenggajianModel> list = state.valueOrNull ?? const <PenggajianModel>[];

    return DsPage(
      header: DsAppHeader(
        title: 'UpahKu',
        subtitle: 'Riwayat & Arsip Gaji',
        trailing: IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Muat ulang',
          onPressed: () => ref.read(penggajianHistoryProvider.notifier).loadHistory(),
        ),
        onAvatarTap: () {},
      ),
      refresh: () => ref.read(penggajianHistoryProvider.notifier).loadHistory(),
      slivers: [
        _CalculateBanner(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const HitungGajiPage()),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Arsip Pembayaran',
                style: AppTypography.headlineMd.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            DsPill(label: '${list.length} Slip', tone: DsTone.neutral),
          ],
        ),
        _ArchiveSummary(list: list),
        state.when(
          data: (List<PenggajianModel> rows) => rows.isEmpty
              ? DsEmptyState(
                  icon: Icons.history_toggle_off_rounded,
                  title: 'Belum ada riwayat penggajian',
                  subtitle: 'Hitung gaji kolektif lalu simpan slipnya di sini.',
                  action: FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const HitungGajiPage()),
                    ),
                    icon: const Icon(Icons.calculate_rounded, size: 18),
                    label: const Text('Hitung Gaji'),
                  ),
                )
              : Column(
                  children: [
                    for (final PenggajianModel p in rows) ...[
                      _HistoryCard(
                        model: p,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => DetailGajiPage(penggajian: p)),
                        ),
                        onDelete: () => _confirmDelete(context, ref, p),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
          loading: () => const SizedBox(height: 200, child: DsLoading()),
          error: (Object err, StackTrace _) => DsErrorView(
            message: '$err',
            onRetry: () => ref.read(penggajianHistoryProvider.notifier).loadHistory(),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, PenggajianModel p) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Hapus Riwayat Gaji'),
        content: Text(
          'Hapus slip gaji ${p.karyawan.value?.nama ?? ''} periode '
          '${DateFormatter.formatShort(p.periodeMulai)} - '
          '${DateFormatter.formatShort(p.periodeSelesai)}? Tindakan ini permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () {
              ref.read(penggajianHistoryProvider.notifier).deletePayrollRun(p.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Riwayat gaji berhasil dihapus.')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _CalculateBanner extends StatelessWidget {
  const _CalculateBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return DsCard(
      color: s.surfaceContainerLow,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: s.primary, borderRadius: AppRadius.rMd),
            child: Icon(Icons.calculate_rounded, color: s.onPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proses Penggajian',
                  style: AppTypography.titleMd.copyWith(
                    color: s.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hitung gaji kolektif lalu arsipkan slipnya.',
                  style: AppTypography.bodyMd.copyWith(color: s.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: s.primary),
        ],
      ),
    );
  }
}

class _ArchiveSummary extends StatelessWidget {
  const _ArchiveSummary({required this.list});

  final List<PenggajianModel> list;

  @override
  Widget build(BuildContext context) {
    double total = 0;
    double lembur = 0;
    for (final PenggajianModel p in list) {
      total += p.totalGajiBersih;
      lembur += p.totalJamLembur;
    }

    return DsCard(
      child: Row(
        children: [
          Expanded(
            child: DsStatTile(
              label: 'Total Dibayar',
              value: CurrencyFormatter.compact(total),
              valueColor: AppColors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DsStatTile(
              label: 'Total Lembur',
              value: lembur.toStringAsFixed(1),
              unit: 'Jam',
              valueColor: AppColors.warning,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DsStatTile(
              label: 'Rata-rata',
              value: list.isEmpty
                  ? 'Rp 0'
                  : CurrencyFormatter.compact(total / list.length),
              valueColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.model, required this.onTap, required this.onDelete});

  final PenggajianModel model;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final karyawan = model.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();

    return DsCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: s.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.picture_as_pdf_rounded, size: 20, color: s.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  karyawan.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMd.copyWith(
                    color: s.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Periode ${DateFormatter.formatPeriode(model.periodeMulai, model.periodeSelesai)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    DsPill(
                      label: '${model.totalHadir} hari kerja',
                      tone: DsTone.neutral,
                      dense: true,
                    ),
                    const SizedBox(width: 6),
                    DsPill(
                      label: '${model.totalJamLembur.toStringAsFixed(1)} jml',
                      tone: DsTone.warning,
                      dense: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(model.totalGajiBersih),
                style: AppTypography.titleMd.copyWith(
                  color: s.primary,
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabular,
                ),
              ),
              Text(
                DateFormatter.formatShort(model.tanggalGajian),
                style: AppTypography.labelMd.copyWith(color: s.outline, fontSize: 11),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, size: 20, color: s.outline),
            tooltip: 'Hapus',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
