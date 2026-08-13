import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/absensi_provider.dart';
import '../../providers/karyawan_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/absensi_model.dart';
import '../../../data/models/karyawan_model.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Date Selector Header (Premium design)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1F3D).withOpacity(0.4) : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Navigation Hari
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: () {
                            ref.read(selectedDateProvider.notifier).state =
                                selectedDate.subtract(const Duration(days: 1));
                          },
                        ),
                        TextButton.icon(
                          onPressed: () => _selectDate(context, selectedDate),
                          icon: const Icon(Icons.calendar_month_rounded, color: Color(0xFF10B981)),
                          label: Text(
                            DateFormatter.formatFull(selectedDate),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: () {
                            ref.read(selectedDateProvider.notifier).state =
                                selectedDate.add(const Duration(days: 1));
                          },
                        ),
                      ],
                    ),
                    // Tombol Absen Massal
                    TextButton.icon(
                      onPressed: () => _showBulkAbsensiSheet(context),
                      icon: const Icon(Icons.flash_on_rounded, size: 16),
                      label: const Text(
                        'Absen Massal',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                        foregroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.green.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Tersimpan otomatis • Bebas ubah kapan saja',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.green.shade400 : Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama karyawan...',
                prefixIcon: const Icon(Icons.search_rounded),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: isDark ? const Color(0xFF162235).withOpacity(0.6) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameParts = karyawan.nama.trim().split(' ');
    final initials = nameParts.length > 1
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : nameParts[0][0].toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162235) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // Profil Avatar Karyawan
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F1F3D), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info Karyawan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    karyawan.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    karyawan.jabatan,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Status Switchers (Ikon Premium)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusButton(context, absensi, 'Hadir', Icons.check_circle_rounded, Colors.green),
                const SizedBox(width: 5),
                _buildStatusButton(context, absensi, 'Izin', Icons.assignment_rounded, Colors.blue),
                const SizedBox(width: 5),
                _buildStatusButton(context, absensi, 'Sakit', Icons.local_hospital_rounded, Colors.orange),
                const SizedBox(width: 5),
                _buildStatusButton(context, absensi, 'Alfa', Icons.cancel_rounded, Colors.red),
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
    IconData icon,
    Color activeColor,
  ) {
    final isSelected = absensi.status == status;
    final selectedDate = ref.read(selectedDateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: status,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          ref
              .read(absensiProvider(selectedDate).notifier)
              .updateStatus(absensi.karyawan.value!.id, status);
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected 
                ? activeColor.withOpacity(isDark ? 0.25 : 0.15) 
                : (isDark ? const Color(0xFF1E2D4A) : Colors.grey.shade100),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [
              BoxShadow(
                color: activeColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected 
                ? activeColor 
                : (isDark ? Colors.white38 : Colors.grey.shade400),
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

  // Menampilkan Bottom Sheet Premium untuk Input Absensi Massal (Bulk Input)
  void _showBulkAbsensiSheet(BuildContext context) {
    final karyawanState = ref.read(karyawanProvider);
    final activeEmployees = karyawanState.maybeWhen(
      data: (list) => list.where((k) => k.statusAktif).toList(),
      orElse: () => <KaryawanModel>[],
    );

    if (activeEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada karyawan aktif untuk diabsen.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    DateTime _startDate = DateTime.now();
    DateTime _endDate = DateTime.now();
    String _selectedStatus = 'Hadir';
    List<int> _selectedKaryawanIds = activeEmployees.map((k) => k.id).toList();
    String _sheetSearchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            
            final filteredEmployees = activeEmployees.where((k) {
              return k.nama.toLowerCase().contains(_sheetSearchQuery.toLowerCase());
            }).toList();

            final daysCount = _endDate.difference(_startDate).inDays + 1;

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1F3D) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Judul Sheet
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      'Input Absensi Massal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        const SizedBox(height: 12),
                        // 1. Pemilih Rentang Tanggal
                        const Text(
                          '1. Rentang Tanggal',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final pickedRange = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2025),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                              initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                            );
                            if (pickedRange != null) {
                              setSheetState(() {
                                _startDate = pickedRange.start;
                                _endDate = pickedRange.end;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF162235) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_rounded, color: Color(0xFF10B981)),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${DateFormatter.formatShort(_startDate)}  s/d  ${DateFormatter.formatShort(_endDate)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$daysCount Hari',
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 2. Status Kehadiran
                        const Text(
                          '2. Status Kehadiran',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildBulkStatusOption(context, setSheetState, 'Hadir', Icons.check_circle_rounded, Colors.green, _selectedStatus, (val) {
                              setSheetState(() => _selectedStatus = val);
                            }),
                            const SizedBox(width: 8),
                            _buildBulkStatusOption(context, setSheetState, 'Izin', Icons.assignment_rounded, Colors.blue, _selectedStatus, (val) {
                              setSheetState(() => _selectedStatus = val);
                            }),
                            const SizedBox(width: 8),
                            _buildBulkStatusOption(context, setSheetState, 'Sakit', Icons.local_hospital_rounded, Colors.orange, _selectedStatus, (val) {
                              setSheetState(() => _selectedStatus = val);
                            }),
                            const SizedBox(width: 8),
                            _buildBulkStatusOption(context, setSheetState, 'Alfa', Icons.cancel_rounded, Colors.red, _selectedStatus, (val) {
                              setSheetState(() => _selectedStatus = val);
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // 3. Pemilih Karyawan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '3. Karyawan Terpilih (${_selectedKaryawanIds.length})',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                setSheetState(() {
                                  if (_selectedKaryawanIds.length == activeEmployees.length) {
                                    _selectedKaryawanIds.clear();
                                  } else {
                                    _selectedKaryawanIds = activeEmployees.map((k) => k.id).toList();
                                  }
                                });
                              },
                              child: Text(
                                _selectedKaryawanIds.length == activeEmployees.length
                                    ? 'Batal Semua'
                                    : 'Pilih Semua',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Pencarian Karyawan Di Dalam Sheet
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari karyawan...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF162235) : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (val) {
                            setSheetState(() {
                              _sheetSearchQuery = val;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListView.builder(
                            itemCount: filteredEmployees.length,
                            itemBuilder: (context, index) {
                              final karyawan = filteredEmployees[index];
                              final isSelected = _selectedKaryawanIds.contains(karyawan.id);

                              return CheckboxListTile(
                                activeColor: const Color(0xFF10B981),
                                title: Text(
                                  karyawan.nama,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  karyawan.jabatan,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                value: isSelected,
                                onChanged: (val) {
                                  setSheetState(() {
                                    if (val == true) {
                                      _selectedKaryawanIds.add(karyawan.id);
                                    } else {
                                      _selectedKaryawanIds.remove(karyawan.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // Tombol Terapkan di Bagian Bawah
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _selectedKaryawanIds.isEmpty
                            ? null
                            : () async {
                                final selectedDate = ref.read(selectedDateProvider);
                                final notifier = ref.read(absensiProvider(selectedDate).notifier);
                                
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(child: CircularProgressIndicator()),
                                );

                                try {
                                  await notifier.saveBulkAbsensi(
                                    karyawanIds: _selectedKaryawanIds,
                                    startDate: _startDate,
                                    endDate: _endDate,
                                    status: _selectedStatus,
                                  );
                                  
                                  Navigator.pop(context); // Close loading dialog
                                  Navigator.pop(context); // Close bottom sheet
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Berhasil menyimpan $_selectedStatus massal ($daysCount hari).'),
                                      backgroundColor: const Color(0xFF10B981),
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context); // Close loading dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal menyimpan: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Terapkan Absensi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBulkStatusOption(
    BuildContext context,
    StateSetter setSheetState,
    String status,
    IconData icon,
    Color color,
    String selectedStatus,
    void Function(String) onTap,
  ) {
    final isSelected = selectedStatus == status;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(status),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
                ? color.withOpacity(isDark ? 0.25 : 0.15) 
                : (isDark ? const Color(0xFF162235) : Colors.grey.shade100),
            border: Border.all(
              color: isSelected ? color : (isDark ? Colors.white10 : Colors.grey.shade300),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? color : (isDark ? Colors.white30 : Colors.grey.shade400),
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                      ? color 
                      : (isDark ? Colors.white70 : Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
