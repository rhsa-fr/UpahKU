import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/penggajian_model.dart';
import 'currency_formatter.dart';
import 'date_formatter.dart';

class PdfGenerator {
  static Future<Uint8List> generateSlipGajiPdf({
    required PenggajianModel penggajian,
    required String namaUsaha,
    required String alamatUsaha,
  }) async {
    final pdf = pw.Document();
    
    final karyawan = penggajian.karyawan.value;
    final namaKaryawan = karyawan?.nama ?? 'Karyawan';
    final jabatanKaryawan = karyawan?.jabatan ?? '-';

    // Load logo image from assets
    pw.ImageProvider? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/logo_light.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      // Logo not available, continue without it
    }

    // Brand colors
    const navyColor = PdfColor.fromInt(0xFF0F1F3D);
    const emeraldColor = PdfColor.fromInt(0xFF10B981);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ─── Header with Logo ───
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        if (logoImage != null)
                          pw.Container(
                            width: 36,
                            height: 36,
                            child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                          ),
                        if (logoImage != null) pw.SizedBox(width: 8),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              namaUsaha.toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: navyColor,
                              ),
                            ),
                            pw.Text(
                              alamatUsaha,
                              style: const pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: navyColor,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'SLIP GAJI',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.Text(
                            DateFormatter.formatShort(penggajian.tanggalGajian),
                            style: const pw.TextStyle(
                              fontSize: 7,
                              color: PdfColors.grey300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Divider ───
              pw.Container(
                height: 2,
                decoration: const pw.BoxDecoration(
                  color: emeraldColor,
                ),
              ),
              pw.SizedBox(height: 10),

              // ─── Employee Info ───
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nama', namaKaryawan),
                      _buildInfoRow('Jabatan', jabatanKaryawan),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildInfoRow('Periode', DateFormatter.formatPeriode(penggajian.periodeMulai, penggajian.periodeSelesai)),
                      _buildInfoRow('Status', 'Lunas'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              // ─── Earnings & Deductions ───
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Pendapatan Column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: const PdfColor.fromInt(0xFFECFDF5), // emerald 50
                            borderRadius: pw.BorderRadius.circular(3),
                          ),
                          child: pw.Text(
                            'PENDAPATAN',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: emeraldColor,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        _buildAmountRow('Gaji Pokok (${penggajian.totalHadir} Hari)', penggajian.totalUpahKerja),
                        _buildAmountRow('Lembur (${penggajian.totalJamLembur.toStringAsFixed(1)} Jam)', penggajian.totalUpahLembur),
                        _buildAmountRow('Bonus', penggajian.totalBonus),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  // Potongan Column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: const PdfColor.fromInt(0xFFFEF2F2), // red 50
                            borderRadius: pw.BorderRadius.circular(3),
                          ),
                          child: pw.Text(
                            'POTONGAN',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor.fromInt(0xFFEF4444),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        _buildAmountRow('Potongan', penggajian.totalPotongan),
                        _buildAmountRow('Kasbon', penggajian.totalKasbon),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 14),
              pw.Divider(thickness: 0.5, color: PdfColors.grey300),
              pw.SizedBox(height: 8),

              // ─── Total Summary Box ───
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow('Total Pendapatan', penggajian.totalUpahKerja + penggajian.totalUpahLembur + penggajian.totalBonus, fontSize: 8),
                      _buildSummaryRow('Total Potongan', penggajian.totalPotongan + penggajian.totalKasbon, fontSize: 8),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: navyColor,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'GAJI BERSIH',
                          style: pw.TextStyle(
                            fontSize: 7,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey300,
                          ),
                        ),
                        pw.Text(
                          CurrencyFormatter.format(penggajian.totalGajiBersih),
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // ─── Footer ───
              pw.Divider(thickness: 0.3, color: PdfColors.grey300),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Dibuat oleh UpahKu • Penggajian Harian Offline',
                    style: const pw.TextStyle(
                      fontSize: 6,
                      color: PdfColors.grey500,
                    ),
                  ),
                  pw.Text(
                    'Dokumen ini digenerate secara otomatis',
                    style: const pw.TextStyle(
                      fontSize: 6,
                      color: PdfColors.grey500,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _buildAmountRow(String label, double val) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
          pw.Text(CurrencyFormatter.format(val), style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryRow(String label, double val, {double fontSize = 8}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: pw.TextStyle(fontSize: fontSize)),
          pw.Text(CurrencyFormatter.format(val), style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
