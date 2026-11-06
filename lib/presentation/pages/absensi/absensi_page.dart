import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/absensi_provider.dart';
import '../../providers/karyawan_provider.dart';
import '../../providers/lembur_provider.dart';
import '../../providers/transaksi_tambahan_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/absensi_model.dart';
import '../../../data/models/karyawan_model.dart';
import '../../../data/models/lembur_model.dart';
import '../../../data/models/transaksi_tambahan_model.dart';
import '../../widgets/ds/design_system.dart';
import '../../widgets/ds/date_picker_sheet.dart';

class AbsensiPage extends ConsumerStatefulWidget {
  const AbsensiPage({super.key});

  @override
  ConsumerState<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends ConsumerState<AbsensiPage> {
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
    final AsyncValue<List<AbsensiModel>> state = ref.watch(absensiProvider(selectedDate));

    return Column(
      children: [
        _DateBar(date: selectedDate),
        Expanded(
          child: state.when(
            data: (List<AbsensiModel> list) => _buildBody(context, selectedDate, list),
            loading: () => const DsLoading(label: 'Memuat absensi...'),
            error: (Object err, StackTrace _) => DsErrorView(
              message: '$err',
              onRetry: () => ref.invalidate(absensiProvider(selectedDate)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, DateTime date, List<AbsensiModel> list) {
    if (list.isEmpty) {
      return DsEmptyState(
        icon: Icons.assignment_ind_outlined,
        title: 'Tidak ada karyawan aktif',
        subtitle: 'Tambahkan karyawan dulu di tab Karyawan sebelum mencatat absensi.',
      );
    }

    final String q = _searchQuery.trim().toLowerCase();
    final List<AbsensiModel> visible = list.where((AbsensiModel a) {
      final String name = a.karyawan.value?.nama ?? '';
      return q.isEmpty || name.toLowerCase().contains(q);
    }).toList();

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
              _SummaryCounters(list: list),
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
                  subtitle: 'Coba kata kunci lain.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.margin,
                    AppSpacing.sm,
                    AppSpacing.margin,
                    AppSpacing.xl,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (BuildContext context, int i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _AbsensiCard(absensi: visible[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Date navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _DateBar extends ConsumerWidget {
  const _DateBar({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isToday = DateUtils.isSameDay(date, DateTime.now());

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.margin,
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
                onTap: () => _pickDate(context, ref),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 16, color: s.primary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              DateFormat('EEE, d MMM', 'id_ID').format(date),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleMd.copyWith(
                                color: s.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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
          const SizedBox(width: AppSpacing.xs),
          FilledButton.tonalIcon(
            onPressed: () => _DateBar.showBulkSheet(context),
            icon: const Icon(Icons.bolt_rounded, size: 16),
            label: const Text('Massal'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 38),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: s.secondaryContainer,
              foregroundColor: s.onSecondaryContainer,
              textStyle: AppTypography.labelMd,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showUpahDatePicker(
      context,
      initialDate: date,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      title: 'Tanggal absensi',
      subtitle: 'Pilih hari yang mau dicatat',
    );
    if (picked != null) ref.read(selectedDateProvider.notifier).state = picked;
  }

  static Future<void> showBulkSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (BuildContext _) => const _BulkAbsensiSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary counters
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCounters extends StatelessWidget {
  const _SummaryCounters({required this.list});

  final List<AbsensiModel> list;

  static const List<({String label, DsTone tone, IconData? icon})> _tones = [
    (label: 'Hadir', tone: DsTone.success, icon: Icons.check_circle_rounded),
    (label: 'Izin', tone: DsTone.info, icon: Icons.event_available_rounded),
    (label: 'Sakit', tone: DsTone.warning, icon: Icons.healing_rounded),
    (label: 'Alpa', tone: DsTone.danger, icon: Icons.cancel_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {'Hadir': 0, 'Izin': 0, 'Sakit': 0, 'Alpa': 0};
    for (final AbsensiModel a in list) {
      counts[a.status] = (counts[a.status] ?? 0) + 1;
    }

    return Row(
      children: [
        for (int i = 0; i < _tones.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DsCounterChip(
              label: _tones[i].label,
              value: counts[_tones[i].label] ?? 0,
              tone: _tones[i].tone,
              icon: _tones[i].icon,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Worker card
// ─────────────────────────────────────────────────────────────────────────────

class _AbsensiCard extends ConsumerWidget {
  const _AbsensiCard({required this.absensi});

  final AbsensiModel absensi;

  static const List<({String label, IconData icon, DsTone tone})> _statuses = [
    (label: 'Hadir', icon: Icons.check_rounded, tone: DsTone.success),
    (label: 'Izin', icon: Icons.assignment_turned_in_outlined, tone: DsTone.info),
    (label: 'Sakit', icon: Icons.healing_rounded, tone: DsTone.warning),
    (label: 'Alpa', icon: Icons.close_rounded, tone: DsTone.danger),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final KaryawanModel? k = absensi.karyawan.value;
    if (k == null) return const SizedBox.shrink();

    final DateTime date = ref.watch(selectedDateProvider);
    final bool canOvertime = absensi.status == 'Hadir';

    return DsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                      'Harian: ${CurrencyFormatter.format(k.upahHarian)} • '
                      'Lembur: ${CurrencyFormatter.compact(k.tarifLembur)}/jam',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int i = 0; i < _statuses.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _StatusToggle(
                    absensi: absensi,
                    date: date,
                    spec: _statuses[i],
                    selected: absensi.status == _statuses[i].label,
                  ),
                ),
              ],
            ],
          ),
          if (canOvertime)
            _OvertimeRow(karyawanId: k.id, date: date, tarifLembur: k.tarifLembur)
          else
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: DsInset(
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: s.outline),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lembur dinonaktifkan • status ${absensi.status}',
                        style: AppTypography.labelMd.copyWith(color: s.outline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _EstimateRow(karyawan: k, date: date, status: absensi.status),
        ],
      ),
    );
  }
}

class _StatusToggle extends ConsumerWidget {
  const _StatusToggle({
    required this.absensi,
    required this.date,
    required this.spec,
    required this.selected,
  });

  final AbsensiModel absensi;
  final DateTime date;
  final ({IconData icon, DsTone tone, String label}) spec;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final Color accent = spec.tone.accent(s);
    final Color bg = selected ? spec.tone.bg(s) : s.surfaceContainerHigh;
    final Color fg = selected ? spec.tone.fg(s) : s.outline;

    return Semantics(
      button: true,
      selected: selected,
      label: spec.label,
      child: Material(
        color: bg,
        borderRadius: AppRadius.rMd,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            ref
                .read(absensiProvider(date).notifier)
                .updateStatus(absensi.karyawan.value!.id, spec.label);
          },
          borderRadius: AppRadius.rMd,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: AppRadius.rMd,
              border: Border.all(
                color: selected ? accent : Colors.transparent,
                width: 1.4,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(spec.icon, size: 15, color: fg),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    spec.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd.copyWith(
                      color: fg,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OvertimeRow extends ConsumerWidget {
  const _OvertimeRow({
    required this.karyawanId,
    required this.date,
    required this.tarifLembur,
  });

  final int karyawanId;
  final DateTime date;
  final double tarifLembur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final List<LemburModel> lemburList =
        ref.watch(lemburProvider(date)).valueOrNull ?? const <LemburModel>[];
    final double jam = lemburList
        .where((LemburModel l) => l.karyawan.value?.id == karyawanId)
        .fold<double>(0.0, (double sum, LemburModel l) => sum + l.jumlahJam);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: DsInset(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lembur Harian',
                    style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kelipatan 0,5 jam (+${CurrencyFormatter.format(jam * tarifLembur)})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd.copyWith(color: s.outline, fontSize: 11),
                  ),
                ],
              ),
            ),
            DsStepper(
              value: jam,
              onChanged: (double v) =>
                  ref.read(lemburProvider(date).notifier).updateHours(karyawanId, v),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstimateRow extends ConsumerWidget {
  const _EstimateRow({
    required this.karyawan,
    required this.date,
    required this.status,
  });

  final KaryawanModel karyawan;
  final DateTime date;
  final String status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;

    final List<LemburModel> lemburList =
        ref.watch(lemburProvider(date)).valueOrNull ?? const <LemburModel>[];
    final List<TransaksiTambahanModel> transaksiList =
        ref.watch(transaksiTambahanProvider(date)).valueOrNull ??
            const <TransaksiTambahanModel>[];

    double lemburJam = 0;
    double bonus = 0;
    double potongan = 0;

    for (final LemburModel l in lemburList) {
      if (l.karyawan.value?.id == karyawan.id) lemburJam += l.jumlahJam;
    }
    for (final TransaksiTambahanModel t in transaksiList) {
      if (t.karyawan.value?.id != karyawan.id) continue;
      if (t.tipe == 'Bonus') {
        bonus += t.nominal;
      } else {
        potongan += t.nominal;
      }
    }

    final double total = status == 'Hadir'
        ? karyawan.upahHarian + lemburJam * karyawan.tarifLembur + bonus - potongan
        : bonus - potongan;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const DsPill(label: '+ Bonus', tone: DsTone.success, dense: true),
                const SizedBox(width: 6),
                Flexible(
                  child: DsPill(
                    label: '- Potongan',
                    tone: potongan > 0 ? DsTone.danger : DsTone.neutral,
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Estimasi hari ini',
                style: AppTypography.labelMd.copyWith(color: s.outline, fontSize: 11),
              ),
              Text(
                CurrencyFormatter.format(total),
                style: AppTypography.titleMd.copyWith(
                  color: s.primary,
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bulk sheet
// ─────────────────────────────────────────────────────────────────────────────

class _BulkAbsensiSheet extends ConsumerStatefulWidget {
  const _BulkAbsensiSheet();

  @override
  ConsumerState<_BulkAbsensiSheet> createState() => _BulkAbsensiSheetState();
}

class _BulkAbsensiSheetState extends ConsumerState<_BulkAbsensiSheet> {
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  String _status = 'Hadir';
  final Set<int> _selected = <int>{};
  String _query = '';
  bool _initialised = false;

  static const List<({String label, IconData icon, DsTone tone})> _statuses = [
    (label: 'Hadir', icon: Icons.check_rounded, tone: DsTone.success),
    (label: 'Izin', icon: Icons.assignment_turned_in_outlined, tone: DsTone.info),
    (label: 'Sakit', icon: Icons.healing_rounded, tone: DsTone.warning),
    (label: 'Alpa', icon: Icons.close_rounded, tone: DsTone.danger),
  ];

  List<KaryawanModel> _active() {
    return ref.read(karyawanProvider).maybeWhen(
          data: (List<KaryawanModel> l) => l.where((KaryawanModel k) => k.statusAktif).toList(),
          orElse: () => <KaryawanModel>[],
        );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final List<KaryawanModel> all = _active();
    if (!_initialised && all.isNotEmpty) {
      _initialised = true;
      _selected.addAll(all.map((KaryawanModel k) => k.id));
    }
    final String q = _query.trim().toLowerCase();
    final List<KaryawanModel> visible = all
        .where((KaryawanModel k) => q.isEmpty || k.nama.toLowerCase().contains(q))
        .toList();
    final int days = _end.difference(_start).inDays + 1;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Text(
                  'Absensi Massal',
                  style: AppTypography.headlineMd.copyWith(color: s.onSurface),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  children: [
                    DsInset(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 18, color: s.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${DateFormatter.formatShort(_start)}  s/d  ${DateFormatter.formatShort(_end)}',
                              style: AppTypography.titleMd.copyWith(color: s.onSurface),
                            ),
                          ),
                          DsPill(label: '$days Hari', tone: DsTone.secondary),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () => _pickRange(context),
                      icon: const Icon(Icons.date_range_rounded, size: 18),
                      label: const Text('Ubah rentang tanggal'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'STATUS KEHADIRAN',
                      style: AppTypography.labelMd.copyWith(
                        color: s.onSurfaceVariant,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        for (int i = 0; i < _statuses.length; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: _BulkStatusOption(
                              spec: _statuses[i],
                              selected: _status == _statuses[i].label,
                              onTap: () => setState(() => _status = _statuses[i].label),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'KARYAWAN TERPILIH (${_selected.length})',
                            style: AppTypography.labelMd.copyWith(
                              color: s.onSurfaceVariant,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: all.isEmpty
                              ? null
                              : () => setState(() {
                                    if (_selected.length == all.length) {
                                      _selected.clear();
                                    } else {
                                      _selected
                                        ..clear()
                                        ..addAll(all.map((KaryawanModel k) => k.id));
                                    }
                                  }),
                          child: Text(_selected.length == all.length ? 'Batal Semua' : 'Pilih Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 48,
                      child: TextField(
                        onChanged: (String v) => setState(() => _query = v),
                        decoration: const InputDecoration(
                          hintText: 'Cari karyawan...',
                          prefixIcon: Icon(Icons.search_rounded, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (visible.isEmpty)
                      const DsEmptyState(
                        icon: Icons.person_off_rounded,
                        title: 'Tidak ada karyawan',
                      )
                    else
                      ...visible.map((KaryawanModel k) {
                        final bool on = _selected.contains(k.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: DsInset(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: on,
                                  onChanged: (bool? v) => setState(() {
                                    if (v ?? false) {
                                      _selected.add(k.id);
                                    } else {
                                      _selected.remove(k.id);
                                    }
                                  }),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        k.nama,
                                        style: AppTypography.bodyMd.copyWith(
                                          color: s.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        k.jabatan,
                                        style: AppTypography.labelMd.copyWith(color: s.outline),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: FilledButton.icon(
                  onPressed: _selected.isEmpty ? null : () => _apply(days),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: Text('Terapkan $_status ke $days hari'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDateRange: DateTimeRange(start: _start, end: _end),
    );
    if (range != null) {
      setState(() {
        _start = range.start;
        _end = range.end;
      });
    }
  }

  Future<void> _apply(int days) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);
    final Color error = Theme.of(context).colorScheme.error;
    final Color success = AppColors.success;

    try {
      await ref.read(absensiProvider(_end).notifier).saveBulkAbsensi(
            karyawanIds: _selected.toList(),
            startDate: _start,
            endDate: _end,
            status: _status,
          );
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Berhasil menyimpan $_status massal ($days hari).'),
          backgroundColor: success,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: error),
      );
    }
  }
}

class _BulkStatusOption extends StatelessWidget {
  const _BulkStatusOption({required this.spec, required this.selected, required this.onTap});

  final ({IconData icon, DsTone tone, String label}) spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Material(
      color: selected ? spec.tone.bg(s) : s.surfaceContainerHigh,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            border: Border.all(
              color: selected ? spec.tone.accent(s) : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Column(
            children: [
              Icon(
                spec.icon,
                size: 18,
                color: selected ? spec.tone.fg(s) : s.outline,
              ),
              const SizedBox(height: 4),
              Text(
                spec.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMd.copyWith(
                  color: selected ? spec.tone.fg(s) : s.outline,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
