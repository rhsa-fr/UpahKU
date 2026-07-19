import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/absensi_provider.dart'; // sharing selectedDateProvider
import '../../providers/lembur_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/lembur_model.dart';

class LemburPage extends ConsumerStatefulWidget {
  const LemburPage({super.key});

  @override
  ConsumerState<LemburPage> createState() => _LemburPageState();
}

class _LemburPageState extends ConsumerState<LemburPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final lemburState = ref.watch(lemburProvider(selectedDate));

    return Scaffold(
      body: Column(
        children: [
          // Date Selector Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        ref.read(selectedDateProvider.notifier).state =
                            selectedDate.subtract(const Duration(days: 1));
                      },
                    ),
                    TextButton.icon(
                      onPressed: () => _selectDate(context, selectedDate),
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        DateFormatter.formatFull(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        ref.read(selectedDateProvider.notifier).state =
                            selectedDate.add(const Duration(days: 1));
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Colors.green.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Tersimpan otomatis • Bebas ubah kapan saja',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama karyawan...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          // Overtime List
          Expanded(
            child: lemburState.when(
              data: (list) {
                final filteredList = list.where((l) {
                  final name = l.karyawan.value?.nama ?? '';
                  return name.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada karyawan aktif untuk input lembur.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final lembur = filteredList[index];
                    return _buildLemburCard(context, lembur);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Gagal memuat lembur: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLemburCard(BuildContext context, LemburModel lembur) {
    final karyawan = lembur.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();
    final selectedDate = ref.watch(selectedDateProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // Info Karyawan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    karyawan.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    karyawan.jabatan,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tarif: Rp ${karyawan.tarifLembur.toStringAsFixed(0)}/jam',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Hour Incrementor Controls (User Friendly - / +)
            Row(
              children: [
                IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    final newHours = (lembur.jumlahJam - 0.5).clamp(0.0, 24.0);
                    ref
                        .read(lemburProvider(selectedDate).notifier)
                        .updateHours(karyawan.id, newHours);
                  },
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _showCustomHoursDialog(context, lembur),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
                    ),
                    constraints: const BoxConstraints(minWidth: 65),
                    alignment: Alignment.center,
                    child: Text(
                      '${lembur.jumlahJam.toStringAsFixed(1)} j',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    final newHours = (lembur.jumlahJam + 0.5).clamp(0.0, 24.0);
                    ref
                        .read(lemburProvider(selectedDate).notifier)
                        .updateHours(karyawan.id, newHours);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustButton(BuildContext context, LemburModel lembur, double amount) {
    final selectedDate = ref.read(selectedDateProvider);
    final signText = amount > 0 ? '+${amount.abs().toStringAsFixed(amount.abs() == 0.5 ? 1 : 0)}' : '-${amount.abs().toStringAsFixed(amount.abs() == 0.5 ? 1 : 0)}';

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        final newHours = (lembur.jumlahJam + amount).clamp(0.0, 24.0);
        ref
            .read(lemburProvider(selectedDate).notifier)
            .updateHours(lembur.karyawan.value!.id, newHours);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          signText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: amount > 0
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != currentDate) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  void _showCustomHoursDialog(BuildContext context, LemburModel lembur) {
    final controller = TextEditingController(text: lembur.jumlahJam.toString());
    final selectedDate = ref.read(selectedDateProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Masukkan Jam Lembur: ${lembur.karyawan.value?.nama}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Jumlah Jam',
            suffixText: 'Jam',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 0.0;
              final hours = val.clamp(0.0, 24.0);
              ref
                  .read(lemburProvider(selectedDate).notifier)
                  .updateHours(lembur.karyawan.value!.id, hours);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _saveLembur(BuildContext context, DateTime date) async {
    final notifier = ref.read(lemburProvider(date).notifier);
    await notifier.save();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lembur tanggal ${DateFormatter.formatShort(date)} berhasil disimpan.',
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }
}
