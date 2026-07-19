import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/absensi_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/absensi_model.dart';

class AbsensiPage extends ConsumerStatefulWidget {
  const AbsensiPage({super.key});

  @override
  ConsumerState<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends ConsumerState<AbsensiPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final absensiState = ref.watch(absensiProvider(selectedDate));

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
          // Attendance List
          Expanded(
            child: absensiState.when(
              data: (list) {
                final filteredList = list.where((a) {
                  final name = a.karyawan.value?.nama ?? '';
                  return name.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_ind_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada karyawan aktif untuk diabsen.',
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
                    final absensi = filteredList[index];
                    return _buildAbsensiCard(context, absensi);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Gagal memuat absensi: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiCard(BuildContext context, AbsensiModel absensi) {
    final karyawan = absensi.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();

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
                ],
              ),
            ),
            // Status Switchers
            Row(
              children: [
                _buildStatusButton(context, absensi, 'Hadir', 'H', Colors.green),
                const SizedBox(width: 6),
                _buildStatusButton(context, absensi, 'Izin', 'I', Colors.blue),
                const SizedBox(width: 6),
                _buildStatusButton(context, absensi, 'Sakit', 'S', Colors.orange),
                const SizedBox(width: 6),
                _buildStatusButton(context, absensi, 'Alfa', 'A', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    AbsensiModel absensi,
    String status,
    String label,
    Color activeColor,
  ) {
    final isSelected = absensi.status == status;
    final selectedDate = ref.read(selectedDateProvider);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        ref
            .read(absensiProvider(selectedDate).notifier)
            .updateStatus(absensi.karyawan.value!.id, status);
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
            color: isSelected ? activeColor : Theme.of(context).colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? activeColor : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
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

  void _saveAbsensi(BuildContext context, DateTime date) async {
    final notifier = ref.read(absensiProvider(date).notifier);
    await notifier.save();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Absensi tanggal ${DateFormatter.formatShort(date)} berhasil disimpan.',
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }
}
