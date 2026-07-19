import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/penggajian_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/penggajian_model.dart';
import 'detail_gaji_page.dart';

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
    // Watch calculation results if requested
    final calculationArg = (start: _startDate, end: _endDate);
    final calculationState = _hasCalculated
        ? ref.watch(hitungGajiProvider(calculationArg))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses Penggajian'),
      ),
      body: Column(
        children: [
          // Period Selectors Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Periode Kerja',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(context, true),
                          icon: const Icon(Icons.date_range),
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mulai', style: TextStyle(fontSize: 10)),
                              Text(DateFormatter.formatShort(_startDate)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(context, false),
                          icon: const Icon(Icons.date_range),
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Selesai', style: TextStyle(fontSize: 10)),
                              Text(DateFormatter.formatShort(_endDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasCalculated = true;
                      });
                      // invalidate provider to force reload
                      ref.invalidate(hitungGajiProvider(calculationArg));
                    },
                    child: const Text('Hitung Gaji Kolektif'),
                  ),
                ],
              ),
            ),
          ),
          
          // Calculation Preview Results
          Expanded(
            child: !_hasCalculated
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Pilih periode lalu klik Hitung Gaji',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : calculationState!.when(
                    data: (results) {
                      if (results.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada karyawan dengan riwayat kerja pada periode ini.'),
                        );
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Hasil Perhitungan (${results.length} Karyawan)',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Total: ${CurrencyFormatter.format(results.fold(0.0, (sum, p) => sum + p.totalGajiBersih))}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                final p = results[index];
                                return _buildPreviewCard(context, p);
                              },
                            ),
                          ),
                          // Save Payroll Button
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border(
                                top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                              ),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => _savePayrollRun(context, results),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Simpan & Bayar Gaji Kolektif'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Text('Gagal menghitung gaji: $err'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, PenggajianModel p) {
    final karyawan = p.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  karyawan.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  CurrencyFormatter.format(p.totalGajiBersih),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Text(
              karyawan.jabatan,
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hari Kerja', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.outline)),
                      Text('${p.totalHadir} Hari', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jam Lembur', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.outline)),
                      Text('${p.totalJamLembur.toStringAsFixed(1)} Jam', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bonus/Pot/Kasbon', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.outline)),
                      Text(
                        '+${p.totalBonus.toStringAsFixed(0)} / -${(p.totalPotongan + p.totalKasbon).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
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
        _hasCalculated = false; // Reset calculation status so user must re-calculate
      });
    }
  }

  void _savePayrollRun(BuildContext context, List<PenggajianModel> results) async {
    // Show confirmation Dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Simpan Penggajian'),
        content: Text(
          'Simpan seluruh rincian penggajian ini ke riwayat pembayaran? Data ini akan dikunci dan slip gaji PDF dapat segera digenerate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(penggajianHistoryProvider.notifier).savePayrollRun(results);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Seluruh penggajian kolektif berhasil disimpan.'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // Go back to salary home
              }
            },
            child: const Text('Simpan & Bayar'),
          ),
        ],
      ),
    );
  }
}
