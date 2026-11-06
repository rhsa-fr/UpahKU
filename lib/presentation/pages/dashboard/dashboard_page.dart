import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../settings/settings_page.dart';
import '../karyawan/karyawan_list_page.dart';
import '../riwayat/riwayat_page.dart';
import '../../widgets/ds/ds_app_header.dart';
import '../../widgets/ds/design_system.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DashboardData> state = ref.watch(dashboardProvider);

    return DsPage(
      header: DsAppHeader(
        title: 'UpahKu',
        subtitle: 'Ringkasan Payroll Harian',
        onAvatarTap: () => _open(context, const SettingsPage()),
      ),
      refresh: () => ref.refresh(dashboardProvider.future),
      slivers: [
        _HeroCard(),
        _StatusSection(
          state: state,
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        state.maybeWhen(
          data: (d) => _ExpenseCard(total: d.estimasiGajiBulanIni),
          orElse: () => const SizedBox.shrink(),
        ),
        const _QuickLinks(),
      ],
    );
  }

  static void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return DsCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.panel,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Penggajian Harian',
                  style: AppTypography.headlineMd.copyWith(color: AppColors.paper),
                ),
                const SizedBox(height: 4),
                Text(
                  'Catat absensi, hitung lembur, dan terbitkan slip gaji '
                  'tanpa koneksi internet.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.paper.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DsPill(
                  label: '100% Offline • Data tersimpan di HP',
                  tone: DsTone.secondary,
                  icon: Icons.offline_bolt_rounded,
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.paper.withValues(alpha: 0.16),
              borderRadius: AppRadius.rLg,
            ),
            child: const Icon(Icons.payments_rounded, size: 28, color: AppColors.paper),
          ),
        ],
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({required this.state, required this.onRetry});

  final AsyncValue<DashboardData> state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DsSectionHeader(
          title: 'Status Hari Ini',
          icon: Icons.insights_rounded,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        state.when(
          data: (d) => _BentoStats(data: d),
          loading: () => const SizedBox(
            height: 168,
            child: DsLoading(label: 'Menghitung statistik...'),
          ),
          error: (err, _) => DsErrorView(message: '$err', onRetry: onRetry),
        ),
      ],
    );
  }
}

class _BentoStats extends StatelessWidget {
  const _BentoStats({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return DsCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'RINGKASAN HARI INI',
                  style: AppTypography.labelMd.copyWith(
                    color: s.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const DsPill(label: 'Harian', tone: DsTone.neutral, icon: Icons.today_rounded, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DsStatTile(
                  label: 'Total Tim',
                  value: '${data.totalKaryawanAktif}',
                  unit: 'Org',
                  valueColor: s.onSurface,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Hadir',
                  value: '${data.hadirHariIni}',
                  unit: 'Org',
                  valueColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Tidak Hadir',
                  value: '${data.tidakHadirHariIni}',
                  unit: 'Org',
                  valueColor: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DsStatTile(
                  label: 'Total Lembur',
                  value: data.lemburHariIni.toStringAsFixed(1),
                  unit: 'Jam',
                  valueColor: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Rata-rata Upah',
                  value: _averageWage(data),
                  valueColor: s.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _averageWage(DashboardData d) {
    if (d.totalKaryawanAktif == 0) return 'Rp 0';
    final double avg = d.estimasiGajiBulanIni / d.totalKaryawanAktif;
    return 'Rp ${CurrencyFormatter.compact(avg)}';
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DsSectionHeader(
          title: 'Estimasi Pengeluaran',
          icon: Icons.account_balance_wallet_rounded,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        DsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: s.secondaryContainer,
                      borderRadius: AppRadius.rMd,
                    ),
                    child: Icon(Icons.savings_rounded, color: s.onSecondaryContainer),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total gaji bulan berjalan',
                          style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            CurrencyFormatter.format(total),
                            style: AppTypography.currencyDisplay.copyWith(
                              color: s.primary,
                              fontFeatures: AppTypography.tabular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final List<({IconData icon, String label, Widget page})> links = [
      (
        icon: Icons.badge_rounded,
        label: 'Karyawan',
        page: const KaryawanListPage(),
      ),
      (
        icon: Icons.receipt_long_rounded,
        label: 'Riwayat Gaji',
        page: const RiwayatPage(),
      ),
      (
        icon: Icons.settings_rounded,
        label: 'Pengaturan',
        page: const SettingsPage(),
      ),
    ];

    return Row(
      children: [
        for (int i = 0; i < links.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DsCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => links[i].page),
              ),
              child: Column(
                children: [
                  Icon(links[i].icon, size: 22, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 6),
                  Text(
                    links[i].label,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

