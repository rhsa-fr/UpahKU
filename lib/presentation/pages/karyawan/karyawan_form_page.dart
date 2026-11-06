import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/karyawan_provider.dart';
import '../../../data/models/karyawan_model.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/ds/design_system.dart';

class KaryawanFormPage extends ConsumerStatefulWidget {
  const KaryawanFormPage({super.key, this.karyawan});

  final KaryawanModel? karyawan;

  @override
  ConsumerState<KaryawanFormPage> createState() => _KaryawanFormPageState();
}

class _KaryawanFormPageState extends ConsumerState<KaryawanFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _jabatanController;
  late final TextEditingController _upahController;
  late final TextEditingController _lemburController;

  bool get isEdit => widget.karyawan != null;

  @override
  void initState() {
    super.initState();
    final NumberFormat fmt = NumberFormat('#,###', 'id_ID');
    _namaController = TextEditingController(text: widget.karyawan?.nama ?? '');
    _jabatanController = TextEditingController(text: widget.karyawan?.jabatan ?? '');
    _upahController = TextEditingController(
      text: widget.karyawan != null ? fmt.format(widget.karyawan!.upahHarian) : '',
    );
    _lemburController = TextEditingController(
      text: widget.karyawan != null ? fmt.format(widget.karyawan!.tarifLembur) : '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jabatanController.dispose();
    _upahController.dispose();
    _lemburController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          isEdit ? 'Edit Karyawan' : 'Karyawan Baru',
          style: AppTypography.headlineMd.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.margin,
          AppSpacing.sm,
          AppSpacing.margin,
          AppSpacing.md,
        ),
        child: FilledButton.icon(
          onPressed: _saveKaryawan,
          icon: Icon(isEdit ? Icons.save_rounded : Icons.person_add_alt_rounded, size: 18),
          label: Text(isEdit ? 'Simpan Perubahan' : 'Daftarkan Karyawan'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.sm,
            AppSpacing.margin,
            AppSpacing.lg,
          ),
          children: [
            DsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'INFORMASI PRIBADI',
                    style: AppTypography.labelMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _namaController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama karyawan',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _jabatanController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Jabatan / Peran',
                      hintText: 'Tukang, Kenek, Operator, dll.',
                      prefixIcon: Icon(Icons.work_outline_rounded),
                    ),
                    validator: (String? v) =>
                        (v == null || v.trim().isEmpty) ? 'Jabatan tidak boleh kosong' : null,
                  ),
                ],
              ),
            ),
            DsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'KONFIGURASI UPAH & LEMBUR',
                    style: AppTypography.labelMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _upahController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Upah Harian',
                      hintText: 'Upah standar per hari kerja',
                      prefixText: 'Rp ',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    validator: (String? v) {
                      if (v == null || v.isEmpty) return 'Upah harian tidak boleh kosong';
                      final double? n = double.tryParse(v.replaceAll('.', ''));
                      if (n == null || n <= 0) return 'Upah harus bernilai positif';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _lemburController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Tarif Lembur (Per Jam)',
                      hintText: 'Tarif upah lembur per jam',
                      prefixText: 'Rp ',
                      prefixIcon: Icon(Icons.schedule_rounded),
                    ),
                    validator: (String? v) {
                      if (v == null || v.isEmpty) return 'Tarif lembur tidak boleh kosong';
                      final double? n = double.tryParse(v.replaceAll('.', ''));
                      if (n == null || n < 0) return 'Tarif lembur tidak boleh kurang dari 0';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveKaryawan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String nama = _namaController.text.trim();
    final String jabatan = _jabatanController.text.trim();
    final double upahHarian = double.parse(_upahController.text.replaceAll('.', ''));
    final double tarifLembur = double.parse(_lemburController.text.replaceAll('.', ''));

    final notifier = ref.read(karyawanProvider.notifier);

    if (isEdit) {
      final KaryawanModel updated = widget.karyawan!
        ..nama = nama
        ..jabatan = jabatan
        ..upahHarian = upahHarian
        ..tarifLembur = tarifLembur;
      notifier.updateKaryawan(updated);
      _toast('Data karyawan berhasil diperbarui.');
    } else {
      notifier.addKaryawan(
        nama: nama,
        jabatan: jabatan,
        upahHarian: upahHarian,
        tarifLembur: tarifLembur,
      );
      _toast('Karyawan baru berhasil didaftarkan.');
    }

    Navigator.pop(context);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }
}
