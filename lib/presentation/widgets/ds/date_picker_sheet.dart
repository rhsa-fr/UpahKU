import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';

const List<String> _monthNames = <String>[
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> _dayNames = <String>[
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const List<String> _dayShort = <String>['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
  if (value.isBefore(min)) return min;
  if (value.isAfter(max)) return max;
  return value;
}

/// Date picker bottom sheet yang mengikuti bahasa visual UpahKu.
/// Nama hari & bulan selalu Bahasa Indonesia.
Future<DateTime?> showUpahDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = 'Pilih tanggal',
  String subtitle = 'Tanggal kerja',
}) {
  final DateTime first = _dateOnly(firstDate ?? DateTime(2020));
  final DateTime last = _dateOnly(lastDate ?? DateTime.now().add(const Duration(days: 365)));
  final DateTime initial = _clampDate(_dateOnly(initialDate), first, last);

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext _) => _UpahDatePickerSheet(
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      title: title,
      subtitle: subtitle,
    ),
  );
}

class _UpahDatePickerSheet extends StatefulWidget {
  const _UpahDatePickerSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.title,
    required this.subtitle,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;
  final String subtitle;

  @override
  State<_UpahDatePickerSheet> createState() => _UpahDatePickerSheetState();
}

class _UpahDatePickerSheetState extends State<_UpahDatePickerSheet> {
  late DateTime _selected;
  late DateTime _visible;
  bool _monthMode = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    _visible = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  bool get _canPrev {
    if (_monthMode) return _visible.year > widget.firstDate.year;
    return DateTime(_visible.year, _visible.month).isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  bool get _canNext {
    if (_monthMode) return _visible.year < widget.lastDate.year;
    return DateTime(_visible.year, _visible.month).isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month),
    );
  }

  void _shift(int delta) {
    setState(() {
      if (_monthMode) {
        _visible = DateTime(_visible.year + delta, _visible.month);
      } else {
        _visible = DateTime(_visible.year, _visible.month + delta);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: s.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: s.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: AppTypography.titleMd.copyWith(color: s.onSurface)),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant, fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                  _SquareButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    label: 'Tutup',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _SquareButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: _canPrev ? () => _shift(-1) : null,
                    label: _monthMode ? 'Tahun sebelumnya' : 'Bulan sebelumnya',
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _monthMode = !_monthMode),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _monthMode
                                ? '${_visible.year}'
                                : '${_monthNames[_visible.month - 1]} ${_visible.year}',
                            style: AppTypography.headlineMd.copyWith(color: s.onSurface, fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _monthMode ? Icons.expand_more_rounded : Icons.expand_less_rounded,
                            size: 18,
                            color: s.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _SquareButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: _canNext ? () => _shift(1) : null,
                    label: _monthMode ? 'Tahun berikutnya' : 'Bulan berikutnya',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _monthMode ? _buildMonths(s) : _buildDays(s),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: s.outlineVariant)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TANGGAL DIPILIH',
                            style: AppTypography.monoLabel.copyWith(
                              color: s.onSurfaceVariant,
                              fontSize: 8,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _longDate(_selected),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleMd.copyWith(color: s.onSurface, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(_selected),
                      child: const Text('Pilih'),
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

  Widget _buildDays(ColorScheme s) {
    final int leading = DateTime(_visible.year, _visible.month, 1).weekday - 1;
    final int days = DateTime(_visible.year, _visible.month + 1, 0).day;
    final int total = leading + days;

    return Column(
      key: ValueKey<String>('days-${_visible.year}-${_visible.month}'),
      children: [
        Row(
          children: [
            for (final String day in _dayShort)
              Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTypography.monoLabel.copyWith(
                      fontSize: 8,
                      letterSpacing: 0.6,
                      color: s.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.05,
          ),
          itemCount: total,
          itemBuilder: (BuildContext context, int index) {
            if (index < leading) return const SizedBox.shrink();
            final int day = index - leading + 1;
            final DateTime date = DateTime(_visible.year, _visible.month, day);
            return _dayCell(s, date);
          },
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              final DateTime today = _dateOnly(DateTime.now());
              if (today.isBefore(widget.firstDate) || today.isAfter(widget.lastDate)) return;
              setState(() {
                _selected = today;
                _visible = DateTime(today.year, today.month);
                _monthMode = false;
              });
            },
            icon: const Icon(Icons.today_outlined, size: 16),
            label: const Text('Hari ini'),
          ),
        ),
      ],
    );
  }

  Widget _dayCell(ColorScheme s, DateTime date) {
    final bool enabled = !date.isBefore(widget.firstDate) && !date.isAfter(widget.lastDate);
    final bool selected = _sameDay(date, _selected);
    final bool today = _sameDay(date, DateTime.now());

    return Center(
      child: Material(
        color: selected ? s.secondary : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? () => setState(() => _selected = date) : null,
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: today && !selected
                  ? Border.all(color: s.secondary, width: 1.4)
                  : null,
            ),
            child: Text(
              '${date.day}',
              style: AppTypography.monoValue.copyWith(
                fontSize: 13,
                color: !enabled
                    ? s.outline.withValues(alpha: 0.45)
                    : selected
                        ? s.onSecondary
                        : today
                            ? s.secondary
                            : s.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonths(ColorScheme s) {
    return Column(
      key: ValueKey<String>('months-${_visible.year}'),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.1,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            final int month = index + 1;
            final DateTime firstOfMonth = DateTime(_visible.year, month, 1);
            final DateTime lastOfMonth = DateTime(_visible.year, month + 1, 0);
            final bool enabled = !lastOfMonth.isBefore(widget.firstDate) &&
                !firstOfMonth.isAfter(widget.lastDate);
            final bool selected =
                _selected.year == _visible.year && _selected.month == month;

            return Material(
              color: selected ? s.secondary : s.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: enabled
                    ? () => setState(() {
                          _visible = DateTime(_visible.year, month);
                          _monthMode = false;
                        })
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? s.secondary : s.outlineVariant,
                    ),
                  ),
                  child: Text(
                    _monthNames[index],
                    style: AppTypography.labelMd.copyWith(
                      fontSize: 11,
                      color: !enabled
                          ? s.outline.withValues(alpha: 0.45)
                          : selected
                              ? s.onSecondary
                              : s.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static String _longDate(DateTime date) =>
      '${_dayNames[date.weekday - 1]}, ${date.day} ${_monthNames[date.month - 1]} ${date.year}';
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap, required this.label});

  final IconData icon;
  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: s.surfaceContainerLowest,
        borderRadius: AppRadius.rMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.rMd,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: AppRadius.rMd,
              border: Border.all(color: s.outlineVariant),
            ),
            child: Icon(
              icon,
              size: 19,
              color: onTap == null ? s.outline.withValues(alpha: 0.4) : s.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
