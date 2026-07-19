import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/absensi_provider.dart'; // sharing selectedDateProvider
import '../../providers/karyawan_provider.dart';
import '../../providers/transaksi_tambahan_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/transaksi_tambahan_model.dart';
import '../../../data/models/karyawan_model.dart';

class BonusPotonganPage extends ConsumerStatefulWidget {
  const BonusPotonganPage({super.key});

  @override
  ConsumerState<BonusPotonganPage> createState() => _BonusPotonganPageState();
}

class _BonusPotonganPageState extends ConsumerState<BonusPotonganPage> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final txState = ref.watch(transaksiTambahanProvider(selectedDate));

    return Scaffold(
      body: Column(
        children: [
          // Date Selector Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
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
          ),
          const Divider(height: 1),
          // Transactions List
          Expanded(
            child: txState.when(
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada transaksi tambahan hari ini.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final tx = list[index];
                    return _buildTransactionCard(context, tx);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Gagal memuat transaksi: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionSheet(context, selectedDate),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Transaksi'),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, TransaksiTambahanModel tx) {
    final karyawan = tx.karyawan.value;
    if (karyawan == null) return const SizedBox.shrink();

    Color typeColor;
    IconData typeIcon;
    switch (tx.tipe) {
      case 'Bonus':
        typeColor = Colors.green;
        typeIcon = Icons.add_circle_outline;
        break;
      case 'Potongan':
        typeColor = Colors.red;
        typeIcon = Icons.remove_circle_outline;
        break;
      case 'Kasbon':
      default:
        typeColor = Colors.orange;
        typeIcon = Icons.monetization_on_outlined;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(typeIcon, color: typeColor),
        ),
        title: Text(
          karyawan.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tx.tipe} • ${tx.keterangan}'),
            const SizedBox(height: 2),
            Text(
              CurrencyFormatter.format(tx.nominal),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: typeColor,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _confirmDelete(context, tx),
        ),
      ),
    );
  }

  void _showAddTransactionSheet(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _AddTransactionSheet(date: date),
        );
      },
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

  void _confirmDelete(BuildContext context, TransaksiTambahanModel tx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text(
          'Apakah Anda yakin ingin menghapus catatan ${tx.tipe} sebesar ${CurrencyFormatter.format(tx.nominal)} untuk ${tx.karyawan.value?.nama ?? ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              final selectedDate = ref.read(selectedDateProvider);
              ref
                  .read(transaksiTambahanProvider(selectedDate).notifier)
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

class _AddTransactionSheet extends ConsumerStatefulWidget {
  final DateTime date;

  const _AddTransactionSheet({required this.date});

  @override
  ConsumerState<_AddTransactionSheet> createState() => __AddTransactionSheetState();
}

class __AddTransactionSheetState extends ConsumerState<_AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  KaryawanModel? _selectedKaryawan;
  String _selectedType = 'Bonus'; // 'Bonus', 'Potongan', 'Kasbon'
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();

  @override
  void dispose() {
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final karyawanState = ref.watch(karyawanProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tambah Transaksi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Dropdown Karyawan
              karyawanState.when(
                data: (list) {
                  final activeList = list.where((k) => k.statusAktif).toList();
                  if (activeList.isEmpty) {
                    return const Text('Tidak ada karyawan aktif.');
                  }

                  return DropdownButtonFormField<KaryawanModel>(
                    value: _selectedKaryawan,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Karyawan',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    items: activeList.map((k) {
                      return DropdownMenuItem<KaryawanModel>(
                        value: k,
                        child: Text(k.nama),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedKaryawan = val;
                      });
                    },
                    validator: (val) =>
                        val == null ? 'Silakan pilih karyawan' : null,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error: $err'),
              ),
              const SizedBox(height: 16),
              // Segmented Button Tipe Transaksi
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Bonus',
                    label: Text('Bonus'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                  ButtonSegment(
                    value: 'Potongan',
                    label: Text('Potongan'),
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  ButtonSegment(
                    value: 'Kasbon',
                    label: Text('Kasbon'),
                    icon: Icon(Icons.monetization_on_outlined),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (set) {
                  setState(() {
                    _selectedType = set.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Input Nominal
              TextFormField(
                controller: _nominalController,
                decoration: const InputDecoration(
                  labelText: 'Nominal Rupiah',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Nominal wajib diisi';
                  final num = double.tryParse(val.replaceAll('.', ''));
                  if (num == null || num <= 0) return 'Nominal harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input Keterangan
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Misal: Bonus kerajinan, Kasbon mingguan',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Keterangan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Simpan Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _selectedKaryawan == null) return;

    final nominal = double.parse(_nominalController.text.replaceAll('.', ''));
    final keterangan = _keteranganController.text.trim();

    ref
        .read(transaksiTambahanProvider(widget.date).notifier)
        .addTransaksi(
          karyawan: _selectedKaryawan!,
          nominal: nominal,
          tipe: _selectedType,
          keterangan: keterangan,
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaksi $_selectedType berhasil ditambahkan.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
