import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/absensi_model.dart';
import '../../../data/models/karyawan_model.dart';
import '../../../data/models/lembur_model.dart';
import '../../../data/models/transaksi_tambahan_model.dart';
import '../../providers/absensi_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/karyawan_provider.dart';
import '../../providers/lembur_provider.dart';
import '../../providers/transaksi_tambahan_provider.dart';
import '../../widgets/ds/design_system.dart';

/// "Hari Ini" — dashboard operasional: angka utama, status kru, aktivitas,
/// dan aksi cepat. Menggantikan dashboard lama yang hanya menampilkan kartu.
class HariIniPage extends ConsumerWidget {
  const HariIniPage({
    super.key,
    required this.onOpenMenu,
    required this.onOpenAbsensi,
    required this.onOpenGaji,
    required this.onOpenData,
  });

  final VoidCallback onOpenMenu;
  final VoidCallback onOpenAbsensi;
  final VoidCallback onOpenGaji;
  final VoidCallback onOpenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final List<KaryawanModel> karyawan = ref.watch(karyawanProvider).valueOrNull ?? const <KaryawanModel>[];
    final List<KaryawanModel> active = karyawan.where((KaryawanModel k) => k.statusAktif).toList();
    final List<AbsensiModel> absensi = ref.watch(absensiProvider(today)).valueOrNull ?? const <AbsensiModel>[];
    final List<LemburModel> lembur = ref.watch(lemburProvider(today)).valueOrNull ?? const <LemburModel>[];
    final List<TransaksiTambahanModel> transaksi =
        ref.watch(transaksiTambahanProvider(today)).valueOrNull ?? const <TransaksiTambahanModel>[];
    final DashboardData? dash = ref.watch(dashboardProvider).valueOrNull;

    int hadir = 0, izin = 0, sakit = 0, alfa = 0;
    double totalLembur = 0;
    double upahHariIni = 0;
    final Set<int> recorded = <int>{};

    for (final AbsensiModel a in absensi) {
      final int? id = a.karyawan.value?.id;
      if (id == null) continue;
      recorded.add(id);
      switch (a.status) {
        case 'Hadir':
          hadir++;
          break;
        case 'Izin':
          izin++;
          break;
        case 'Sakit':
          sakit++;
          break;
        default:
          alfa++;
      }
    }

    for (final LemburModel l in lembur) {
      final int? id = l.karyawan.value?.id;
      if (id == null) continue;
      totalLembur += l.jumlahJam;
    }

    for (final KaryawanModel k in active) {
      AbsensiModel? found;
      for (final AbsensiModel a in absensi) {
        if (a.karyawan.value?.id == k.id) {
          found = a;
          break;
        }
      }
      if (found?.status != 'Hadir') continue;
      final double jam = lembur
          .where((LemburModel l) => l.karyawan.value?.id == k.id)
          .fold<double>(0, (double sum, LemburModel l) => sum + l.jumlahJam);
      upahHariIni += k.upahHarian + (jam * k.tarifLembur);
    }

    final List<KaryawanModel> pending =
        active.where((KaryawanModel k) => !recorded.contains(k.id)).toList();
    final double avgRate = active.isEmpty
        ? 0
        : active.fold<double>(0, (double a, KaryawanModel b) => a + b.upahHarian) / active.length;

    return Scaffold(
      backgroundColor: s.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          children: [
            _Header(
              date: now,
              onOpenMenu: onOpenMenu,
              onOpenData: onOpenData,
            ),
            const SizedBox(height: 14),
            _DateStrip(today: today),
            const SizedBox(height: 14),
            _HeroCard(
              upah: upahHariIni,
              hadir: hadir,
              lembur: totalLembur,
              pending: pending.length,
              izin: izin,
              sakit: sakit,
              alfa: alfa,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              childAspectRatio: 1.45,
              children: [
                _StatTile(icon: Icons.group_outlined, label: 'Tim', value: '${active.length}', unit: 'org'),
                _StatTile(icon: Icons.check_circle_outline, label: 'Hadir', value: '$hadir', unit: 'org', tone: AppColors.success),
                _StatTile(icon: Icons.warning_amber_rounded, label: 'Absen', value: '${izin + sakit + alfa}', unit: 'org', tone: AppColors.danger),
                _StatTile(icon: Icons.schedule_outlined, label: 'Lembur', value: _num(totalLembur), unit: 'jam', tone: AppColors.warning),
                _StatTile(icon: Icons.trending_up_rounded, label: 'Rata-rata', value: CurrencyFormatter.compact(avgRate), unit: 'upah'),
                _StatTile(icon: Icons.account_balance_wallet_outlined, label: 'Estimasi', value: CurrencyFormatter.compact(dash?.estimasiGajiBulanIni ?? 0), unit: 'bulan ini', accent: true),
              ],
            ),
            const SizedBox(height: 18),
            _SectionHeader(
              icon: Icons.warning_amber_rounded,
              title: 'Belum ditandai',
              trailing: '${pending.length} ORANG',
            ),
            const SizedBox(height: 8),
            if (pending.isEmpty)
              _EmptyRow(text: 'Semua kru sudah tercatat hari ini.')
            else
              ...pending.take(4).map(
                    (KaryawanModel k) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: _PendingRow(
                        karyawan: k,
                        onTap: () => _showStatusSheet(context, ref, today, k),
                      ),
                    ),
                  ),
            const SizedBox(height: 18),
            _SectionHeader(
              icon: Icons.show_chart_rounded,
              title: 'Aktivitas hari ini',
              trailing: '${transaksi.length} TRANSAKSI',
            ),
            const SizedBox(height: 8),
            if (transaksi.isEmpty)
              _EmptyRow(text: 'Belum ada bonus, potongan, atau kasbon hari ini.')
            else
              ...transaksi.take(3).map(
                    (TransaksiTambahanModel t) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: _TrxRow(transaksi: t),
                    ),
                  ),
            const SizedBox(height: 18),
            _SectionHeader(icon: Icons.bolt_rounded, title: 'Aksi cepat'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _QuickAction(icon: Icons.fact_check_outlined, label: 'Absensi', onTap: onOpenAbsensi)),
                const SizedBox(width: 7),
                Expanded(child: _QuickAction(icon: Icons.schedule_outlined, label: 'Lembur', onTap: onOpenAbsensi)),
                const SizedBox(width: 7),
                Expanded(child: _QuickAction(icon: Icons.add_card_outlined, label: 'Bonus', onTap: onOpenAbsensi)),
                const SizedBox(width: 7),
                Expanded(child: _QuickAction(icon: Icons.receipt_long_outlined, label: 'Gaji', onTap: onOpenGaji)),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: FilledButton.icon(
                onPressed: onOpenGaji,
                icon: const Icon(Icons.calculate_rounded, size: 18),
                label: const Text('Proses gaji hari ini'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _num(double v) {
    final String s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s.replaceAll('.', ',');
  }

  static Future<void> _showStatusSheet(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    KaryawanModel karyawan,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(karyawan.nama, style: AppTypography.titleMd),
                const SizedBox(height: 2),
                Text(
                  '${karyawan.jabatan} · ${CurrencyFormatter.format(karyawan.upahHarian)}/hari',
                  style: AppTypography.labelMd.copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                for (final (String, String, IconData, Color) option in <(String, String, IconData, Color)>[
                  ('Hadir', 'Hadir', Icons.check_circle_outline, AppColors.success),
                  ('Izin', 'Izin', Icons.calendar_today_outlined, AppColors.info),
                  ('Sakit', 'Sakit', Icons.medical_services_outlined, AppColors.warning),
                  ('Alfa', 'Alfa', Icons.cancel_outlined, AppColors.danger),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(absensiProvider(date).notifier).updateStatus(karyawan.id, option.$1);
                          Navigator.of(ctx).pop();
                        },
                        icon: Icon(option.$3, size: 18, color: option.$4),
                        label: Text(option.$2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.date, required this.onOpenMenu, required this.onOpenData});

  final DateTime date;
  final VoidCallback onOpenMenu;
  final VoidCallback onOpenData;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String kicker = DateFormat('EEEE · d MMMM', 'id_ID').format(date).toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            isDark ? 'assets/images/logo_mark_dark.png' : 'assets/images/logo_mark.png',
            width: 38,
            height: 38,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kicker, style: AppTypography.monoLabel.copyWith(color: s.onSurfaceVariant)),
              const SizedBox(height: 5),
              Text('Hari Ini', style: AppTypography.headlineLg.copyWith(color: s.onSurface)),
            ],
          ),
        ),
        _HeaderButton(icon: Icons.grid_view_outlined, onTap: onOpenMenu, label: 'Menu'),
        const SizedBox(width: 7),
        _HeaderButton(icon: Icons.person_outline, onTap: onOpenData, label: 'Profil', filled: true),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap, required this.label, this.filled = false});

  final IconData icon;
  final VoidCallback onTap;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: filled ? s.secondary : s.surfaceContainerLowest,
        borderRadius: AppRadius.rMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.rMd,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: AppRadius.rMd,
              border: Border.all(color: filled ? s.secondary : s.outlineVariant),
            ),
            child: Icon(icon, size: 19, color: filled ? s.onSecondary : s.onSurface),
          ),
        ),
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({required this.today});

  final DateTime today;

  static const List<String> _days = <String>['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final DateTime monday = today.subtract(Duration(days: today.weekday - 1));

    return Row(
      children: [
        for (int i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 6 ? 0 : 4),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: i == today.weekday - 1 ? s.secondary : Colors.transparent,
                  borderRadius: AppRadius.rMd,
                  border: Border.all(
                    color: i == today.weekday - 1 ? s.secondary : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _days[i],
                      style: AppTypography.monoLabel.copyWith(
                        fontSize: 8.5,
                        letterSpacing: 0.8,
                        color: i == today.weekday - 1 ? s.onSecondary : s.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${monday.add(Duration(days: i)).day}',
                      style: AppTypography.titleMd.copyWith(
                        color: i == today.weekday - 1 ? s.onSecondary : s.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.upah,
    required this.hadir,
    required this.lembur,
    required this.pending,
    required this.izin,
    required this.sakit,
    required this.alfa,
    required this.isDark,
  });

  final double upah;
  final int hadir;
  final double lembur;
  final int pending;
  final int izin;
  final int sakit;
  final int alfa;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final List<(int, Color)> segments = <(int, Color)>[
      (hadir, AppColors.success),
      (izin, AppColors.info),
      (sakit, AppColors.warning),
      (alfa, AppColors.danger),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.panelDark : AppColors.panel,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UPAH HARI INI',
            style: AppTypography.monoLabel.copyWith(
              color: AppColors.paper.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            CurrencyFormatter.format(upah),
            style: AppTypography.currencyDisplay.copyWith(
              fontSize: 34,
              color: AppColors.amber,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _HeroMeta(text: '$hadir kru hadir'),
              _HeroMeta(text: '${HariIniPage._num(lembur)} jam lembur'),
              _HeroMeta(text: '$pending belum ditandai'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  for (final (int count, Color color) in segments)
                    if (count > 0) Expanded(flex: count, child: Container(color: color)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _LegendDot(color: AppColors.success, label: 'Hadir', value: hadir),
              _LegendDot(color: AppColors.info, label: 'Izin', value: izin),
              _LegendDot(color: AppColors.warning, label: 'Sakit', value: sakit),
              _LegendDot(color: AppColors.danger, label: 'Alfa', value: alfa),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(
          text,
          style: AppTypography.labelMd.copyWith(
            color: AppColors.paper.withValues(alpha: 0.74),
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label, required this.value});

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(
          '$label $value',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.paper.withValues(alpha: 0.72),
            fontSize: 9.5,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.tone,
    this.accent = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color? tone;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final Color fg = accent ? s.onSecondaryContainer : s.onSurface;

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: accent ? s.secondaryContainer : s.surfaceContainerLowest,
        borderRadius: AppRadius.rMd,
        border: Border.all(color: accent ? s.secondary.withValues(alpha: 0.45) : s.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.monoLabel.copyWith(
                    fontSize: 7.8,
                    letterSpacing: 0.6,
                    color: accent ? s.onSecondaryContainer.withValues(alpha: 0.75) : s.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(icon, size: 12, color: tone ?? (accent ? s.onSecondaryContainer : s.onSurfaceVariant)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.monoValue.copyWith(fontSize: 15, color: fg),
          ),
          Text(
            unit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMd.copyWith(
              fontSize: 8,
              color: accent ? s.onSecondaryContainer.withValues(alpha: 0.7) : s.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 15, color: s.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(title, style: AppTypography.titleMd.copyWith(color: s.onSurface)),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTypography.monoLabel.copyWith(color: s.onSurfaceVariant, fontSize: 8.5),
          ),
      ],
    );
  }
}

class _PendingRow extends StatelessWidget {
  const _PendingRow({required this.karyawan, required this.onTap});

  final KaryawanModel karyawan;
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
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            border: Border.all(color: s.outlineVariant),
          ),
          child: Row(
            children: [
              DsAvatar(initials: _initials(karyawan.nama), size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(karyawan.nama, style: AppTypography.bodyMd.copyWith(color: s.onSurface, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      '${karyawan.jabatan} · ${CurrencyFormatter.format(karyawan.upahHarian)}/hari',
                      style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant, fontSize: 10),
                    ),
                  ],
                ),
              ),
              DsPill(label: 'Belum', tone: DsTone.neutral, dense: true),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final List<String> parts = name.replaceAll('H. ', '').split(' ').where((String e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return (parts.first[0] + parts.last[0]).toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}

class _TrxRow extends StatelessWidget {
  const _TrxRow({required this.transaksi});

  final TransaksiTambahanModel transaksi;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final (Color tone, String sign, IconData icon) = switch (transaksi.tipe) {
      'Bonus' => (AppColors.success, '+', Icons.trending_up_rounded),
      'Potongan' => (AppColors.danger, '−', Icons.trending_down_rounded),
      _ => (AppColors.warning, '−', Icons.account_balance_wallet_outlined),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: s.surfaceContainerLowest,
        borderRadius: AppRadius.rMd,
        border: Border.all(color: s.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: tone.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, size: 17, color: tone),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.karyawan.value?.nama ?? 'Karyawan',
                  style: AppTypography.bodyMd.copyWith(color: s.onSurface, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  transaksi.keterangan.isEmpty ? transaksi.tipe : transaksi.keterangan,
                  style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '$sign ${CurrencyFormatter.format(transaksi.nominal)}',
            style: AppTypography.monoValue.copyWith(fontSize: 11.5, color: tone),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
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
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            border: Border.all(color: s.outlineVariant),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: s.onSurface),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelMd.copyWith(fontSize: 8.5, color: s.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: s.surfaceContainerLow,
        borderRadius: AppRadius.rMd,
        border: Border.all(color: s.outlineVariant),
      ),
      child: Text(text, style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant, fontSize: 11)),
    );
  }
}
