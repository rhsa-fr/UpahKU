import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat;
import 'package:printing/printing.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../data/models/penggajian_model.dart';

class DetailGajiPage extends StatelessWidget {
  const DetailGajiPage({
    super.key,
    required this.penggajian,
    this.namaUsaha = 'UpahKu',
    this.alamatUsaha = 'Offline Workshop Location',
  });

  final PenggajianModel penggajian;
  final String namaUsaha;
  final String alamatUsaha;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final String namaKaryawan = penggajian.karyawan.value?.nama ?? 'Karyawan';

    return Scaffold(
      backgroundColor: s.surface,
      appBar: AppBar(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Slip Gaji',
              style: AppTypography.headlineMd.copyWith(color: s.onSurface),
            ),
            Text(
              namaKaryawan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: PdfPreview(
        build: (PdfPageFormat format) => PdfGenerator.generateSlipGajiPdf(
          penggajian: penggajian,
          namaUsaha: namaUsaha,
          alamatUsaha: alamatUsaha,
        ),
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        pdfPreviewPageDecoration: BoxDecoration(
          color: s.surfaceContainerHigh,
          borderRadius: AppRadius.rSm,
        ),
        actionBarTheme: AppTheme.actionBarThemeFor(s),
      ),
    );
  }
}
