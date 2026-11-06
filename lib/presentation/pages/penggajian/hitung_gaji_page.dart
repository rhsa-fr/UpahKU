import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/penggajian_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/penggajian_model.dart';
import '../../widgets/ds/design_system.dart';
import '../../widgets/ds/date_picker_sheet.dart';

class HitungGajiPage extends ConsumerStatefulWidget {
  const HitungGajiPage({super.key});

  @override
  ConsumerState<HitungGajiPage> createState() => _HitungGajiPageState();
}

class _HitungGajiPageState extends ConsumerState<HitungGajiPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  bool _hasCalculated = false;

  @override
  Widget build(BuildContext context) {
    final arg = (start: _startDate, end: _endDate);
    final AsyncValue<List<PenggajianModel>>? result =
        _hasCalculated ? ref.watch(hitungGajiProvider(arg)) : null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Proses Penggajian',
          style: AppTypography.headlineMd.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              0,
              AppSpacing.margin,
              AppSpacing.sm,
            ),
            child: DsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'PILIH PERIODE KERJA',
                    style: AppTypography.labelMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: 'Mulai',
                          date: _startDate,
                          onTap: () => _pickDate(true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _DateButton(
                          label: 'Selesai',
                          date: _endDate,
                          onTap: () => _pickDate(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() => _hasCalculated = true);
                      ref.invalidate(hitungGajiProvider(arg));
                    },
                    icon: const Icon(Icons.calculate_rounded, size: 18),
                    label: const Text('Hitung Gaji Kolektif'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: !_hasCalculated
                ? const DsEmptyState(
                    icon: Icons.calculate_rounded,
                    title: 'Pilih periode lalu hitung',
                    subtitle: 'Gaji dihitung dari absensi, lembur, bonus, dan potongan.',
                  )
                : result!.when(
                    data: (List<PenggajianModel> rows) {
                      if (rows.isEmpty) {
                        return const DsEmptyState(
                          icon: Icons.person_off_rounded,
                          title: 'Tidak ada data pada periode ini',
                          subtitle: 'Belum ada karyawan yang punya riwayat kerja di rentang tersebut.',
                        );
                      }
                      return _ResultList(rows: rows, onSave: () => _confirmSave(rows));
                    },
                    loading: () => const DsLoading(label: 'Menghitung...'),
                    error: (Object err, StackTrace _) => DsErrorView(
                      message: '$err',
                      onRetry: () => ref.invalidate(hitungGajiProvider(arg)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final DateTime? picked = await showUpahDatePicker(
      context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      title: isStart ? 'Tanggal mulai' : 'Tanggal selesai',
      subtitle: isStart ? 'Awal periode penggajian' : 'Akhir periode penggajian',
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate.add(const Duration(days: 7));
        }
      } else {
        _endDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate.subtract(const Duration(days: 7));
        }
      }
      _hasCalculated = false;
    });
  }

  void _confirmSave(List<PenggajianModel> results) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Simpan Penggajian'),
        content: const Text(
          'Simpan seluruh rincian penggajian ini ke riwayat pembayaran? '
          'Data akan dikunci dan slip gaji PDF dapat langsung digenerate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(penggajianHistoryProvider.notifier).savePayrollRun(results);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Penggajian kolektif berhasil disimpan.'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Simpan & Bayar'),
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Material(
      color: s.surfaceContainerLow,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 16, color: s.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.labelMd.copyWith(color: s.outline)),
                    Text(
                      DateFormatter.formatShort(date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMd.copyWith(
                        color: s.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.rows, required this.onSave});

  final List<PenggajianModel> rows;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final double total =
        rows.fold<double>(0, (double s, PenggajianModel p) => s + p.totalGajiBersih);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.sm,
            AppSpacing.margin,
            AppSpacing.sm,
          ),
          child: DsCard(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HASIL PERHITUNGAN',
                        style: AppTypography.labelMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${rows.length} karyawan',
                        style: AppTypography.bodyMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL',
                      style: AppTypography.labelMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.8,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        CurrencyFormatter.format(total),
                        style: AppTypography.currencyDisplay.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontFeatures: AppTypography.tabular,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              AppSpacing.sm,
              AppSpacing.margin,
              AppSpacing.md,
            ),
            itemCount: rows.length,
            itemBuilder: (BuildContext context, int i) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _PreviewCard(model: rows[i]),
            ),
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.sm,
            AppSpacing.margin,
            AppSpacing.md,
          ),
          child: FilledButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
            label: const Text('Simpan & Bayar Gaji Kolektif'),
          ),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.model});

  final PenggajianModel model;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final karyawan = model.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();

    return DsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DsAvatar(initials: initialsOf(karyawan.nama), size: 38),
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
                    Text(
                      karyawan.jabatan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(model.totalGajiBersih),
                style: AppTypography.titleMd.copyWith(
                  color: s.primary,
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabular,
                ),
              ),
            ],
          ),
          const DsDivider(),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Hari Kerja',
                  value: '${model.totalHadir} hari',
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Lembur',
                  value: '${model.totalJamLembur.toStringAsFixed(1)} jam',
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Bonus',
                  value: CurrencyFormatter.compact(model.totalBonus),
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Potongan',
                  value: CurrencyFormatter.compact(model.totalPotongan + model.totalKasbon),
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMd.copyWith(color: s.outline, fontSize: 11)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: color ?? s.onSurface,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTypography.tabular,
            ),
          ),
        ),
      ],
    );
  }
}
