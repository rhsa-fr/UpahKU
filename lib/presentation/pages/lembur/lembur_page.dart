import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/absensi_provider.dart';
import '../../providers/lembur_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/lembur_model.dart';
import '../../widgets/ds/design_system.dart';
import '../../widgets/ds/date_picker_sheet.dart';

class LemburPage extends ConsumerStatefulWidget {
  const LemburPage({super.key});

  @override
  ConsumerState<LemburPage> createState() => _LemburPageState();
}

class _LemburPageState extends ConsumerState<LemburPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    final AsyncValue<List<LemburModel>> state = ref.watch(lemburProvider(selectedDate));

    return Column(
      children: [
        _LemburDateBar(date: selectedDate),
        Expanded(
          child: state.when(
            data: (List<LemburModel> list) {
              final String q = _searchQuery.trim().toLowerCase();
              final List<LemburModel> visible = list
                  .where((LemburModel l) =>
                      q.isEmpty ||
                      (l.karyawan.value?.nama ?? '').toLowerCase().contains(q))
                  .toList();

              if (list.isEmpty) {
                return const DsEmptyState(
                  icon: Icons.schedule_rounded,
                  title: 'Tidak ada karyawan aktif',
                  subtitle: 'Tambahkan karyawan di tab Karyawan untuk input lembur.',
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.margin,
                      AppSpacing.md,
                      AppSpacing.margin,
                      AppSpacing.sm,
                    ),
                    child: Column(
                      children: [
                        _LemburSummary(list: list),
                        const SizedBox(height: AppSpacing.sm),
                        DsSearchField(
                          controller: _searchCtrl,
                          hintText: 'Cari nama karyawan...',
                          onChanged: (String v) => setState(() => _searchQuery = v),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: visible.isEmpty
                        ? const DsEmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'Karyawan tidak ditemukan',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.margin,
                              AppSpacing.sm,
                              AppSpacing.margin,
                              AppSpacing.xl,
                            ),
                            itemCount: visible.length,
                            itemBuilder: (BuildContext _, int i) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: _LemburCard(lembur: visible[i], date: selectedDate),
                            ),
                          ),
                  ),
                ],
              );
            },
            loading: () => const DsLoading(label: 'Memuat lembur...'),
            error: (Object err, StackTrace _) => DsErrorView(
              message: '$err',
              onRetry: () => ref.invalidate(lemburProvider(selectedDate)),
            ),
          ),
        ),
      ],
    );
  }
}

class _LemburDateBar extends ConsumerWidget {
  const _LemburDateBar({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isToday = DateUtils.isSameDay(date, DateTime.now());

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: s.surface,
        border: Border(bottom: BorderSide(color: s.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () => ref
                .read(selectedDateProvider.notifier)
                .state = date.subtract(const Duration(days: 1)),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppRadius.rMd,
                onTap: () => _pick(context, ref),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      Text(
                        DateFormatter.formatFull(date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMd.copyWith(
                          color: s.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      DsPill(
                        label: isToday ? 'HARI INI' : DateFormatter.formatShort(date),
                        tone: isToday ? DsTone.secondary : DsTone.neutral,
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () => ref
                .read(selectedDateProvider.notifier)
                .state = date.add(const Duration(days: 1)),
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showUpahDatePicker(
      context,
      initialDate: date,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      title: 'Tanggal lembur',
      subtitle: 'Pilih hari untuk mencatat lembur',
    );
    if (picked != null) ref.read(selectedDateProvider.notifier).state = picked;
  }
}
class _LemburSummary extends StatelessWidget {
  const _LemburSummary({required this.list});

  final List<LemburModel> list;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    double totalHours = 0;
    double totalCost = 0;
    int recorded = 0;
    for (final LemburModel l in list) {
      if (l.jumlahJam > 0) {
        recorded++;
        totalHours += l.jumlahJam;
        totalCost += l.jumlahJam * (l.karyawan.value?.tarifLembur ?? 0);
      }
    }

    return DsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 18, color: s.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'TOTAL LEMBUR TANGGAL INI',
                  style: AppTypography.labelMd.copyWith(
                    color: s.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              DsPill(label: '$recorded Org', tone: DsTone.neutral, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DsStatTile(
                  label: 'Total Jam',
                  value: totalHours.toStringAsFixed(1),
                  unit: 'Jam',
                  valueColor: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Biaya Lembur',
                  value: CurrencyFormatter.compact(totalCost),
                  valueColor: s.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LemburCard extends ConsumerWidget {
  const _LemburCard({required this.lembur, required this.date});

  final LemburModel lembur;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final k = lembur.karyawan.value;
    if (k == null) return const SizedBox.shrink();

    final double biaya = lembur.jumlahJam * k.tarifLembur;

    return DsCard(
      child: Row(
        children: [
          DsAvatar(initials: initialsOf(k.nama), size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  k.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMd.copyWith(
                    color: s.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tarif ${CurrencyFormatter.format(k.tarifLembur)}/jam',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                DsPill(
                  label: biaya > 0 ? CurrencyFormatter.format(biaya) : 'Belum ada lembur',
                  tone: biaya > 0 ? DsTone.primary : DsTone.neutral,
                  dense: true,
                ),
              ],
            ),
          ),
          DsStepper(
            value: lembur.jumlahJam,
            max: 24,
            suffix: 'Jam',
            onChanged: (double v) {
              HapticFeedback.selectionClick();
              ref.read(lemburProvider(date).notifier).updateHours(k.id, v);
            },
          ),
        ],
      ),
    );
  }
}
