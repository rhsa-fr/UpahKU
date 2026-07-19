import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/karyawan_provider.dart';
import '../../../data/models/karyawan_model.dart';
import '../../../core/utils/currency_formatter.dart';

class KaryawanFormPage extends ConsumerStatefulWidget {
  final KaryawanModel? karyawan;

  const KaryawanFormPage({super.key, this.karyawan});

  @override
  ConsumerState<KaryawanFormPage> createState() => _KaryawanFormPageState();
}

class _KaryawanFormPageState extends ConsumerState<KaryawanFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _jabatanController;
  late TextEditingController _upahController;
  late TextEditingController _lemburController;

  bool get isEdit => widget.karyawan != null;

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat('#,###', 'id_ID');
    _namaController = TextEditingController(text: widget.karyawan?.nama ?? '');
    _jabatanController =
        TextEditingController(text: widget.karyawan?.jabatan ?? '');
    _upahController = TextEditingController(
        text: widget.karyawan != null ? formatter.format(widget.karyawan!.upahHarian) : '');
    _lemburController = TextEditingController(
        text: widget.karyawan != null ? formatter.format(widget.karyawan!.tarifLembur) : '');
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
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Pribadi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              // Nama Field
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama karyawan',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              // Jabatan Field
              TextFormField(
                controller: _jabatanController,
                decoration: const InputDecoration(
                  labelText: 'Jabatan / Peran',
                  hintText: 'Tukang, Kenek, Operator, dll.',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jabatan tidak boleh kosong';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              Text(
                'Konfigurasi Upah & Lembur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              // Upah Harian Field
              TextFormField(
                controller: _upahController,
                decoration: const InputDecoration(
                  labelText: 'Upah Harian',
                  hintText: 'Upah standar per hari kerja',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Upah harian tidak boleh kosong';
                  }
                  final nominal = double.tryParse(value.replaceAll('.', ''));
                  if (nominal == null || nominal <= 0) {
                    return 'Upah harus bernilai positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Sharif Lembur Field
              TextFormField(
                controller: _lemburController,
                decoration: const InputDecoration(
                  labelText: 'Tarif Lembur (Per Jam)',
                  hintText: 'Tarif upah lembur per jam',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.schedule_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tarif lembur tidak boleh kosong';
                  }
                  final nominal = double.tryParse(value.replaceAll('.', ''));
                  if (nominal == null || nominal < 0) {
                    return 'Tarif lembur tidak boleh kurang dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // Submit Button
              ElevatedButton(
                onPressed: _saveKaryawan,
                child: Text(isEdit ? 'Simpan Perubahan' : 'Daftarkan Karyawan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveKaryawan() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaController.text.trim();
    final jabatan = _jabatanController.text.trim();
    final upahHarian = double.parse(_upahController.text.replaceAll('.', ''));
    final tarifLembur = double.parse(_lemburController.text.replaceAll('.', ''));

    final notifier = ref.read(karyawanProvider.notifier);

    if (isEdit) {
      final updated = widget.karyawan!
        ..nama = nama
        ..jabatan = jabatan
        ..upahHarian = upahHarian
        ..tarifLembur = tarifLembur;
      notifier.updateKaryawan(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data karyawan berhasil diupdate.')),
      );
    } else {
      notifier.addKaryawan(
        nama: nama,
        jabatan: jabatan,
        upahHarian: upahHarian,
        tarifLembur: tarifLembur,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Karyawan baru berhasil didaftarkan.')),
      );
    }

    Navigator.pop(context);
  }
}
