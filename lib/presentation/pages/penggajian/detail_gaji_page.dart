import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../data/models/penggajian_model.dart';

class DetailGajiPage extends StatelessWidget {
  final PenggajianModel penggajian;
  final String namaUsaha;
  final String alamatUsaha;

  const DetailGajiPage({
    super.key,
    required this.penggajian,
    this.namaUsaha = 'UpahKu',
    this.alamatUsaha = 'Offline Workshop Location',
  });

  @override
  Widget build(BuildContext context) {
    final namaKaryawan = penggajian.karyawan.value?.nama ?? 'Karyawan';

    return Scaffold(
      appBar: AppBar(
        title: Text('Slip Gaji - $namaKaryawan'),
      ),
      body: PdfPreview(
        build: (format) => PdfGenerator.generateSlipGajiPdf(
          penggajian: penggajian,
          namaUsaha: namaUsaha,
          alamatUsaha: alamatUsaha,
        ),
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}
