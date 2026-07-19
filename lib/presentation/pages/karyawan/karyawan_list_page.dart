import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/karyawan_provider.dart';
import '../../../data/models/karyawan_model.dart';
import '../../../core/utils/currency_formatter.dart';
import 'karyawan_form_page.dart';

class KaryawanListPage extends ConsumerStatefulWidget {
  const KaryawanListPage({super.key});

  @override
  ConsumerState<KaryawanListPage> createState() => _KaryawanListPageState();
}

class _KaryawanListPageState extends ConsumerState<KaryawanListPage> {
  String _searchQuery = '';
  String _statusFilter = 'Semua'; // 'Semua', 'Aktif', 'Nonaktif'

  @override
  Widget build(BuildContext context) {
    final karyawanState = ref.watch(karyawanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(karyawanProvider.notifier).loadKaryawan(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Panel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama karyawan...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Filter Segmented Buttons
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Semua', 'Aktif', 'Nonaktif'].map((filter) {
                            final isSelected = _statusFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              key: ValueKey(filter),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _statusFilter = filter;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Employees List
          Expanded(
            child: karyawanState.when(
              data: (list) {
                // Apply search and status filters
                final filteredList = list.where((k) {
                  final matchesSearch =
                      k.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          k.jabatan.toLowerCase().contains(_searchQuery.toLowerCase());
                  
                  bool matchesStatus = true;
                  if (_statusFilter == 'Aktif') {
                    matchesStatus = k.statusAktif;
                  } else if (_statusFilter == 'Nonaktif') {
                    matchesStatus = !k.statusAktif;
                  }

                  return matchesSearch && matchesStatus;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Karyawan tidak ditemukan'
                              : 'Belum ada data karyawan',
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final karyawan = filteredList[index];
                    return _buildEmployeeCard(context, karyawan);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Gagal memuat data: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KaryawanFormPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Karyawan Baru'),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, KaryawanModel karyawan) {
    final statusColor = karyawan.statusAktif
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.outline;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                karyawan.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              karyawan.jabatan,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upah Harian',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(karyawan.upahHarian),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarif Lembur',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Text(
                        '${CurrencyFormatter.format(karyawan.tarifLembur)} /jam',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KaryawanFormPage(karyawan: karyawan),
                ),
              );
            } else if (value == 'toggle_status') {
              _toggleEmployeeStatus(karyawan);
            } else if (value == 'delete') {
              _confirmDelete(context, karyawan);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Edit Data'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'toggle_status',
              child: ListTile(
                leading: Icon(karyawan.statusAktif
                    ? Icons.toggle_off_outlined
                    : Icons.toggle_on_outlined),
                title: Text(karyawan.statusAktif
                    ? 'Nonaktifkan Karyawan'
                    : 'Aktifkan Karyawan'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Hapus Permanen',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEmployeeStatus(KaryawanModel karyawan) {
    karyawan.statusAktif = !karyawan.statusAktif;
    ref.read(karyawanProvider.notifier).updateKaryawan(karyawan);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Karyawan ${karyawan.nama} berhasil ${karyawan.statusAktif ? 'diaktifkan' : 'dinonaktifkan'}.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(BuildContext context, KaryawanModel karyawan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Karyawan'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ${karyawan.nama} secara permanen? Seluruh riwayat absensi, lembur, dan gaji terkait akan tetap berada di database namun karyawan ini akan dihapus dari daftar.',
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
              ref.read(karyawanProvider.notifier).deleteKaryawan(karyawan.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Karyawan ${karyawan.nama} telah dihapus.'),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
