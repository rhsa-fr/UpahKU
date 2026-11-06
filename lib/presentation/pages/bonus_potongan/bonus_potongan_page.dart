import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/absensi_provider.dart';
import '../../providers/karyawan_provider.dart';
import '../../providers/transaksi_tambahan_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/transaksi_tambahan_model.dart';
import '../../../data/models/karyawan_model.dart';
import '../../widgets/ds/design_system.dart';

class BonusPotonganPage extends ConsumerStatefulWidget {
  const BonusPotonganPage({super.key});

  @override
  ConsumerState<BonusPotonganPage> createState() => _BonusPotonganPageState();
}

class _BonusPotonganPageState extends ConsumerState<BonusPotonganPage> {
  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    final AsyncValue<List<TransaksiTambahanModel>> txState =
        ref.watch(transaksiTambahanProvider(selectedDate));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          _DateStrip(date: selectedDate),
          Expanded(
            child: txState.when(
              data: (List<TransaksiTambahanModel> list) {
                if (list.isEmpty) {
                  return DsEmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: 'Belum ada transaksi tambahan',
                    subtitle: 'Catat bonus, potongan, atau kasbon untuk tanggal ini.',
                    action: FilledButton.icon(
                      onPressed: () => _openSheet(context, selectedDate),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Tambah Transaksi'),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.margin,
                    AppSpacing.md,
                    AppSpacing.margin,
                    AppSpacing.xl,
                  ),
                  children: [
                    _TxSummary(list: list),
                    const SizedBox(height: AppSpacing.md),
                    for (final TransaksiTambahanModel tx in list) ...[
                      _TransactionCard(tx: tx, onDelete: () => _confirmDelete(tx)),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
              loading: () => const DsLoading(),
              error: (Object err, StackTrace _) => DsErrorView(
                message: '$err',
                onRetry: () => ref.invalidate(transaksiTambahanProvider(selectedDate)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSheet(context, selectedDate),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
    );
  }

  static void _openSheet(BuildContext context, DateTime date) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) => _AddTransactionSheet(date: date),
    );
  }

  void _confirmDelete(TransaksiTambahanModel tx) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text(
          'Hapus catatan ${tx.tipe} sebesar ${CurrencyFormatter.format(tx.nominal)} '
          'untuk ${tx.karyawan.value?.nama ?? ''}?',
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
              final DateTime date = ref.read(selectedDateProvider);
              ref
                  .read(transaksiTambahanProvider(date).notifier)
                  .deleteTransaksi(tx.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaksi berhasil dihapus.')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _DateStrip extends ConsumerWidget {
  const _DateStrip({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isToday = DateUtils.isSameDay(date, DateTime.now());

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
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
}

class _TxSummary extends StatelessWidget {
  const _TxSummary({required this.list});

  final List<TransaksiTambahanModel> list;

  @override
  Widget build(BuildContext context) {
    double bonus = 0;
    double potongan = 0;
    for (final TransaksiTambahanModel t in list) {
      if (t.tipe == 'Bonus') {
        bonus += t.nominal;
      } else {
        potongan += t.nominal;
      }
    }

    return DsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RINGKASAN TAMBAHAN',
            style: AppTypography.labelMd.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DsStatTile(
                  label: 'Total Bonus',
                  value: CurrencyFormatter.compact(bonus),
                  valueColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Total Potongan',
                  value: CurrencyFormatter.compact(potongan),
                  valueColor: AppColors.danger,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Selisih',
                  value: CurrencyFormatter.compact(bonus - potongan),
                  valueColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.tx, required this.onDelete});

  final TransaksiTambahanModel tx;
  final VoidCallback onDelete;

  static ({IconData icon, DsTone tone}) _style(String tipe) => switch (tipe) {
        'Bonus' => (icon: Icons.add_circle_rounded, tone: DsTone.success),
        'Potongan' => (icon: Icons.remove_circle_rounded, tone: DsTone.danger),
        _ => (icon: Icons.request_quote_rounded, tone: DsTone.warning),
      };

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final KaryawanModel? karyawan = tx.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();

    final ({IconData icon, DsTone tone}) style = _style(tx.tipe);

    return DsCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: style.tone.bg(s), shape: BoxShape.circle),
            child: Icon(style.icon, size: 20, color: style.tone.fg(s)),
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
                  tx.keterangan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    DsPill(label: tx.tipe, tone: style.tone, dense: true),
                    const SizedBox(width: 6),
                    Text(
                      CurrencyFormatter.format(tx.nominal),
                      style: AppTypography.titleMd.copyWith(
                        color: style.tone.accent(s),
                        fontWeight: FontWeight.w700,
                        fontFeatures: AppTypography.tabular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

class _AddTransactionSheet extends ConsumerStatefulWidget {
  const _AddTransactionSheet({required this.date});

  final DateTime date;

  @override
  ConsumerState<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<_AddTransactionSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  KaryawanModel? _selected;
  String _type = 'Bonus';
  final TextEditingController _nominal = TextEditingController();
  final TextEditingController _keterangan = TextEditingController();

  static const List<({String label, IconData icon})> _types = [
    (label: 'Bonus', icon: Icons.add_circle_rounded),
    (label: 'Potongan', icon: Icons.remove_circle_rounded),
    (label: 'Kasbon', icon: Icons.request_quote_rounded),
  ];

  @override
  void dispose() {
    _nominal.dispose();
    _keterangan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<KaryawanModel>> karyawanState = ref.watch(karyawanProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tambah Transaksi',
                  style: AppTypography.headlineMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                karyawanState.when(
                  data: (List<KaryawanModel> list) {
                    final List<KaryawanModel> active =
                        list.where((KaryawanModel k) => k.statusAktif).toList();
                    if (active.isEmpty) {
                      return DsInset(
                        child: Text(
                          'Tidak ada karyawan aktif.',
                          style: AppTypography.bodyMd.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }
                    return DropdownButtonFormField<KaryawanModel>(
                      initialValue: _selected,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Karyawan',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      items: [
                        for (final KaryawanModel k in active)
                          DropdownMenuItem<KaryawanModel>(
                            value: k,
                            child: Text(k.nama, overflow: TextOverflow.ellipsis),
                          ),
                      ],
                      onChanged: (KaryawanModel? v) => setState(() => _selected = v),
                      validator: (KaryawanModel? v) =>
                          v == null ? 'Silakan pilih karyawan' : null,
                    );
                  },
                  loading: () => const SizedBox(height: 56, child: DsLoading()),
                  error: (Object err, StackTrace _) => Text('Error: $err'),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    for (int i = 0; i < _types.length; i++) ...[
                      if (i > 0) const SizedBox(width: 6),
                      Expanded(
                        child: _TypeChip(
                          label: _types[i].label,
                          icon: _types[i].icon,
                          selected: _type == _types[i].label,
                          onTap: () => setState(() => _type = _types[i].label),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nominal,
                  keyboardType: TextInputType.number,
                  inputFormatters: [RupiahInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Nominal',
                    prefixText: 'Rp ',
                    prefixIcon: Icon(Icons.payments_rounded),
                  ),
                  validator: (String? v) {
                    if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                    final double? n = double.tryParse(v.replaceAll('.', ''));
                    if (n == null || n <= 0) return 'Nominal harus lebih dari 0';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _keterangan,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                    hintText: 'Misal: Bonus kerajinan, Kasbon mingguan',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? 'Keterangan wajib diisi' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('Simpan Transaksi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false) || _selected == null) return;

    final double nominal = double.parse(_nominal.text.replaceAll('.', ''));
    ref.read(transaksiTambahanProvider(widget.date).notifier).addTransaksi(
          karyawan: _selected!,
          nominal: nominal,
          tipe: _type,
          keterangan: _keterangan.text.trim(),
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaksi $_type berhasil ditambahkan.'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Material(
      color: selected ? s.primary : s.surfaceContainerHigh,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: selected ? s.onPrimary : s.outline),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(
                    color: selected ? s.onPrimary : s.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
