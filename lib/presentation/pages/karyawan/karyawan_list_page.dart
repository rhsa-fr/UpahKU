import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/karyawan_provider.dart';
import '../../../data/models/karyawan_model.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/ds/ds_app_header.dart';
import '../../widgets/ds/design_system.dart';
import 'karyawan_form_page.dart';

class KaryawanListPage extends ConsumerStatefulWidget {
  const KaryawanListPage({super.key});

  @override
  ConsumerState<KaryawanListPage> createState() => _KaryawanListPageState();
}

class _KaryawanListPageState extends ConsumerState<KaryawanListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int _statusFilter = 0;

  static const List<String> _filters = ['Semua', 'Aktif', 'Nonaktif'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<KaryawanModel>> state = ref.watch(karyawanProvider);

    final List<KaryawanModel> visible = state.maybeWhen(
      data: (list) => list.where(_matches).toList(),
      orElse: () => const [],
    );

    return DsPage(
      header: DsAppHeader(
        title: 'UpahKu',
        subtitle: 'Master Data Karyawan',
        onAvatarTap: () {},
      ),
      refresh: () => ref.read(karyawanProvider.notifier).loadKaryawan(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Karyawan Baru'),
      ),
      slivers: [
        Row(
          children: [
            Text(
              'Data Karyawan',
              style: AppTypography.headlineMd.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            DsPill(
              label: '${state.maybeWhen(data: (l) => l.length, orElse: () => 0)} Org',
              tone: DsTone.primary,
            ),
            const Spacer(),
            const DsPill(
              label: 'Database Lokal Isar',
              tone: DsTone.neutral,
              icon: Icons.storage_rounded,
            ),
          ],
        ),
        DsSearchField(
          controller: _searchCtrl,
          hintText: 'Cari nama atau jabatan...',
          onChanged: (v) => setState(() => _searchQuery = v),
          onFilterTap: () => setState(() => _statusFilter = (_statusFilter + 1) % 3),
        ),
        DsChipBar(
          labels: _filters,
          selectedIndex: _statusFilter,
          onSelected: (i) => setState(() => _statusFilter = i),
        ),
        _SummaryCard(all: state.maybeWhen(data: (l) => l, orElse: () => const [])),
        state.when(
          data: (_) => visible.isEmpty
              ? DsEmptyState(
                  icon: Icons.people_outline_rounded,
                  title: _searchQuery.isEmpty
                      ? 'Belum ada data karyawan'
                      : 'Karyawan tidak ditemukan',
                  subtitle: 'Tambahkan karyawan untuk mulai mencatat absensi.',
                  action: FilledButton.icon(
                    onPressed: _openForm,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Tambah Karyawan'),
                  ),
                )
              : Column(
                  children: [
                    for (final KaryawanModel k in visible) ...[
                      _KaryawanCard(
                        karyawan: k,
                        onEdit: () => _openForm(karyawan: k),
                        onToggle: () => _toggle(k),
                        onDelete: () => _confirmDelete(k),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
          loading: () => const SizedBox(height: 240, child: DsLoading()),
          error: (err, _) => DsErrorView(
            message: '$err',
            onRetry: () => ref.read(karyawanProvider.notifier).loadKaryawan(),
          ),
        ),
      ],
    );
  }

  bool _matches(KaryawanModel k) {
    final String q = _searchQuery.trim().toLowerCase();
    final bool matchSearch = q.isEmpty ||
        k.nama.toLowerCase().contains(q) ||
        k.jabatan.toLowerCase().contains(q);
    final bool matchStatus = switch (_statusFilter) {
      1 => k.statusAktif,
      2 => !k.statusAktif,
      _ => true,
    };
    return matchSearch && matchStatus;
  }

  void _openForm({KaryawanModel? karyawan}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => KaryawanFormPage(karyawan: karyawan),
      ),
    );
  }

  void _toggle(KaryawanModel karyawan) {
    karyawan.statusAktif = !karyawan.statusAktif;
    ref.read(karyawanProvider.notifier).updateKaryawan(karyawan);
    _snack(
      '${karyawan.nama} berhasil ${karyawan.statusAktif ? 'diaktifkan' : 'dinonaktifkan'}.',
      tone: DsTone.success,
    );
  }

  void _confirmDelete(KaryawanModel karyawan) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Hapus Karyawan'),
        content: Text(
          'Hapus ${karyawan.nama} secara permanen? Riwayat absensi, lembur, '
          'dan gaji terkait tetap tersimpan namun karyawan ini hilang dari daftar.',
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
              ref.read(karyawanProvider.notifier).deleteKaryawan(karyawan.id);
              Navigator.pop(ctx);
              _snack('${karyawan.nama} telah dihapus.', tone: DsTone.danger);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _snack(String message, {DsTone tone = DsTone.neutral}) {
    if (!mounted) return;
    final ColorScheme s = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: switch (tone) {
          DsTone.success => AppColors.success,
          DsTone.danger => s.error,
          _ => s.inverseSurface,
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.all});

  final List<KaryawanModel> all;

  @override
  Widget build(BuildContext context) {
    final List<KaryawanModel> active = all.where((k) => k.statusAktif).toList();
    final double totalWage = active.fold(0, (sum, k) => sum + k.upahHarian);
    final double avgWage = active.isEmpty ? 0 : totalWage / active.length;
    final double avgLembur =
        active.isEmpty ? 0 : active.fold(0.0, (s, k) => s + k.tarifLembur) / active.length;

    return DsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'RINGKASAN UPAH HARIAN',
                  style: AppTypography.labelMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Icon(Icons.payments_rounded,
                  size: 18, color: Theme.of(context).colorScheme.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: DsStatTile(label: 'Total Tim', value: '${active.length}', unit: 'Org')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Rata-rata',
                  value: 'Rp ${CurrencyFormatter.compact(avgWage)}',
                  valueColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DsStatTile(
                  label: 'Lembur/Jam',
                  value: 'Rp ${CurrencyFormatter.compact(avgLembur)}',
                  valueColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KaryawanCard extends StatelessWidget {
  const _KaryawanCard({
    required this.karyawan,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final KaryawanModel karyawan;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return DsCard(
      onTap: onEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsAvatar(initials: initialsOf(karyawan.nama)),
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
                    const SizedBox(height: 4),
                    DsPill(label: karyawan.jabatan, tone: DsTone.neutral, dense: true),
                  ],
                ),
              ),
              _CardMenu(onEdit: onEdit, onToggle: onToggle, onDelete: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DsInset(
            child: Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Upah Pokok',
                    value: 'Rp ${CurrencyFormatter.plain(karyawan.upahHarian)}',
                    unit: '/hari',
                    color: s.primary,
                  ),
                ),
                Container(width: 1, height: 30, color: s.outlineVariant),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MiniStat(
                    label: 'Tarif Lembur',
                    value: 'Rp ${CurrencyFormatter.plain(karyawan.tarifLembur)}',
                    unit: '/jam',
                    color: s.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.event_available_rounded, size: 14, color: s.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Bergabung sejak ${_joinedLabel(karyawan)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(color: s.outline),
                ),
              ),
              DsPill(
                label: karyawan.statusAktif ? 'Aktif' : 'Nonaktif',
                tone: karyawan.statusAktif ? DsTone.primary : DsTone.neutral,
                dot: true,
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _joinedLabel(KaryawanModel k) {
    try {
      final DateTime d = k.createdAt;
      const List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      return '${d.day} ${months[d.month - 1]} ${d.year}';
    } catch (_) {
      return '-';
    }
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMd.copyWith(color: s.outline)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: value,
              style: AppTypography.bodyMd.copyWith(color: color, fontWeight: FontWeight.w700),
              children: [
                TextSpan(
                  text: unit,
                  style: AppTypography.labelMd.copyWith(color: s.outline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CardMenu extends StatelessWidget {
  const _CardMenu({required this.onEdit, required this.onToggle, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      tooltip: 'Opsi',
      icon: Icon(Icons.more_vert_rounded, size: 20, color: s.onSurfaceVariant),
      onSelected: (String v) => switch (v) {
        'edit' => onEdit(),
        'toggle' => onToggle(),
        _ => onDelete(),
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit Data')),
        const PopupMenuItem(value: 'toggle', child: Text('Aktif / Nonaktif')),
        PopupMenuItem(
          value: 'delete',
          child: Text('Hapus Permanen', style: TextStyle(color: s.error)),
        ),
      ],
    );
  }
}
