import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/penggajian_model.dart';
import 'currency_formatter.dart';
import 'date_formatter.dart';

/// Slip gaji A5 — mengikuti bahasa visual "Ledger Lapangan".
///
/// Semua nominal memakai IBM Plex Mono, label memakai Plex Sans, aksen amber
/// hanya untuk angka utama. Dokumen tetap terbaca saat dicetak hitam-putih.
class PdfGenerator {
  static const PdfColor _ink = PdfColor.fromInt(0xFF101826);
  static const PdfColor _paper = PdfColor.fromInt(0xFFF6F3EC);
  static const PdfColor _amber = PdfColor.fromInt(0xFFE3A72F);
  static const PdfColor _amberSoft = PdfColor.fromInt(0xFFFBEFD2);
  static const PdfColor _muted = PdfColor.fromInt(0xFF6E6656);
  static const PdfColor _line = PdfColor.fromInt(0xFFE3DCCC);
  static const PdfColor _success = PdfColor.fromInt(0xFF1F7A5A);
  static const PdfColor _successSoft = PdfColor.fromInt(0xFFDFF1E9);
  static const PdfColor _info = PdfColor.fromInt(0xFF2C5C8A);
  static const PdfColor _infoSoft = PdfColor.fromInt(0xFFE1ECF7);
  static const PdfColor _warning = PdfColor.fromInt(0xFFA9701A);
  static const PdfColor _warningSoft = PdfColor.fromInt(0xFFFBEBD2);
  static const PdfColor _danger = PdfColor.fromInt(0xFFB23A2E);
  static const PdfColor _dangerSoft = PdfColor.fromInt(0xFFF7E1DE);

  static Future<Uint8List> generateSlipGajiPdf({
    required PenggajianModel penggajian,
    required String namaUsaha,
    required String alamatUsaha,
  }) async {
    final pdf = pw.Document();

    // Font statis (bukan variable) agar aman di parser PDF.
    pw.Font? regular;
    pw.Font? semi;
    pw.Font? bold;
    pw.Font? mono;
    try {
      regular = pw.Font.ttf(await rootBundle.load('assets/fonts/IBMPlexSans-Regular.ttf'));
      semi = pw.Font.ttf(await rootBundle.load('assets/fonts/IBMPlexSans-SemiBold.ttf'));
      bold = pw.Font.ttf(await rootBundle.load('assets/fonts/IBMPlexSans-Bold.ttf'));
      mono = pw.Font.ttf(await rootBundle.load('assets/fonts/IBMPlexMono-SemiBold.ttf'));
    } catch (_) {
      // Fallback ke base-14 kalau aset font tidak tersedia.
    }
    final pw.Font body = regular ?? pw.Font.helvetica();
    final pw.Font bodySemi = semi ?? body;
    final pw.Font bodyBold = bold ?? bodySemi;
    final pw.Font monoFont = mono ?? bodySemi;

    pw.ImageProvider? logo;
    try {
      final ByteData bytes = await rootBundle.load('assets/images/logo_mark.png');
      logo = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      // Tetap bisa cetak tanpa logo.
    }

    final String namaKaryawan = penggajian.karyawan.value?.nama ?? 'Karyawan';
    final String jabatan = penggajian.karyawan.value?.jabatan ?? '-';
    final String periode =
        '${DateFormatter.formatShort(penggajian.periodeMulai)} — ${DateFormatter.formatShort(penggajian.periodeSelesai)}';
    final double totalPendapatan =
        penggajian.totalUpahKerja + penggajian.totalUpahLembur + penggajian.totalBonus;
    final double totalPotongan = penggajian.totalPotongan + penggajian.totalKasbon;

    pw.Widget infoRow(String key, String value) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 3),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 46,
                child: pw.Text(key, style: pw.TextStyle(font: body, fontSize: 7.2, color: _muted)),
              ),
              pw.Expanded(
                child: pw.Text(
                  value,
                  style: pw.TextStyle(font: bodySemi, fontSize: 7.6, color: _ink),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );

    pw.Widget amountRow(String text, double value, {bool deduction = false}) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(text, style: pw.TextStyle(font: body, fontSize: 7.2, color: _muted)),
              pw.Text(
                '${deduction ? '− ' : ''}${CurrencyFormatter.format(value)}',
                style: pw.TextStyle(
                  font: monoFont,
                  fontSize: 7.4,
                  color: deduction ? _danger : _ink,
                ),
              ),
            ],
          ),
        );

    pw.Widget chip(String text, String value, PdfColor color, PdfColor soft) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: pw.BoxDecoration(
            color: soft,
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                text,
                style: pw.TextStyle(font: bodySemi, fontSize: 6, color: color, letterSpacing: 0.4),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                value,
                style: pw.TextStyle(font: monoFont, fontSize: 9, color: color),
              ),
            ],
          ),
        );

    pw.Widget signature(String caption, String name) => pw.SizedBox(
          width: 42 * PdfPageFormat.mm,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(caption, style: pw.TextStyle(font: body, fontSize: 6.5, color: _muted)),
              pw.SizedBox(height: 24),
              pw.Container(height: 0.5, color: _line),
              pw.SizedBox(height: 3),
              pw.Text(name, style: pw.TextStyle(font: bodySemi, fontSize: 7, color: _ink)),
            ],
          ),
        );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(22),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (logo != null)
                    pw.Container(
                      width: 34,
                      height: 34,
                      child: pw.Image(logo, fit: pw.BoxFit.contain),
                    ),
                  if (logo != null) pw.SizedBox(width: 9),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          namaUsaha.isEmpty ? 'UpahKu' : namaUsaha,
                          style: pw.TextStyle(font: bodyBold, fontSize: 11, color: _ink),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          alamatUsaha.isEmpty ? 'Data lokal · tanpa server' : alamatUsaha,
                          style: pw.TextStyle(font: body, fontSize: 6.8, color: _muted),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'SLIP GAJI',
                        style: pw.TextStyle(font: bodyBold, fontSize: 12, color: _ink, letterSpacing: 0.8),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        periode,
                        style: pw.TextStyle(font: monoFont, fontSize: 6.8, color: _muted),
                      ),
                      pw.SizedBox(height: 1),
                      pw.Text(
                        'Dibuat ${DateFormatter.formatShort(penggajian.tanggalGajian)}',
                        style: pw.TextStyle(font: body, fontSize: 6.3, color: _muted),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 9),
              pw.Container(height: 2.5, color: _amber),
              pw.SizedBox(height: 10),

              // ── Identitas ─────────────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.all(9),
                decoration: pw.BoxDecoration(
                  color: _paper,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: _line, width: 0.6),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          infoRow('Nama', namaKaryawan),
                          infoRow('Jabatan', jabatan),
                          infoRow('Upah harian', CurrencyFormatter.format(penggajian.upahHarianSaatItu)),
                          infoRow('Tarif lembur', '${CurrencyFormatter.format(penggajian.tarifLemburSaatItu)}/jam'),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          infoRow('Periode', periode),
                          infoRow('Hari kerja', '${penggajian.totalHadir} hari'),
                          infoRow('Status', 'Final'),
                          infoRow('Pembayaran', 'Tunai / transfer'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // ── Kehadiran ─────────────────────────────────────────────
              pw.Row(
                children: [
                  pw.Expanded(child: chip('HADIR', '${penggajian.totalHadir}', _success, _successSoft)),
                  pw.SizedBox(width: 4),
                  pw.Expanded(child: chip('IZIN', '${penggajian.totalIzin}', _info, _infoSoft)),
                  pw.SizedBox(width: 4),
                  pw.Expanded(child: chip('SAKIT', '${penggajian.totalSakit}', _warning, _warningSoft)),
                  pw.SizedBox(width: 4),
                  pw.Expanded(child: chip('ALFA', '${penggajian.totalAlfa}', _danger, _dangerSoft)),
                  pw.SizedBox(width: 4),
                  pw.Expanded(child: chip('LEMBUR', '${_hours(penggajian.totalJamLembur)} jam', _warning, _amberSoft)),
                ],
              ),
              pw.SizedBox(height: 12),

              // ── Pendapatan & potongan ─────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: _amberSoft,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            'PENDAPATAN',
                            style: pw.TextStyle(font: bodyBold, fontSize: 6.5, color: _ink, letterSpacing: 0.6),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        amountRow('Upah kerja (${penggajian.totalHadir} hari)', penggajian.totalUpahKerja),
                        amountRow('Lembur (${_hours(penggajian.totalJamLembur)} jam)', penggajian.totalUpahLembur),
                        amountRow('Bonus', penggajian.totalBonus),
                        pw.Divider(thickness: 0.4, color: _line, height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total pendapatan', style: pw.TextStyle(font: bodySemi, fontSize: 7.2, color: _ink)),
                            pw.Text(
                              CurrencyFormatter.format(totalPendapatan),
                              style: pw.TextStyle(font: monoFont, fontSize: 7.6, color: _ink),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: _dangerSoft,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            'POTONGAN',
                            style: pw.TextStyle(font: bodyBold, fontSize: 6.5, color: _danger, letterSpacing: 0.6),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        amountRow('Potongan', penggajian.totalPotongan, deduction: true),
                        amountRow('Kasbon', penggajian.totalKasbon, deduction: true),
                        pw.Divider(thickness: 0.4, color: _line, height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total potongan', style: pw.TextStyle(font: bodySemi, fontSize: 7.2, color: _ink)),
                            pw.Text(
                              '− ${CurrencyFormatter.format(totalPotongan)}',
                              style: pw.TextStyle(font: monoFont, fontSize: 7.6, color: _danger),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              // ── Gaji bersih ───────────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: _ink,
                  borderRadius: pw.BorderRadius.circular(7),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'RINGKASAN',
                          style: pw.TextStyle(
                            font: bodyBold,
                            fontSize: 6.4,
                            color: PdfColors.grey400,
                            letterSpacing: 0.7,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Dibayarkan ke $namaKaryawan',
                          style: pw.TextStyle(font: body, fontSize: 6.8, color: PdfColors.grey400),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'GAJI BERSIH',
                          style: pw.TextStyle(font: bodyBold, fontSize: 6.4, color: _amber, letterSpacing: 0.8),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          CurrencyFormatter.format(penggajian.totalGajiBersih),
                          style: pw.TextStyle(font: monoFont, fontSize: 15, color: PdfColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // ── Tanda tangan ──────────────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  signature('Diterima oleh', namaKaryawan),
                  signature('Dibuat oleh', namaUsaha.isEmpty ? 'UpahKu' : namaUsaha),
                ],
              ),
              pw.SizedBox(height: 10),

              // ── Footer ────────────────────────────────────────────────
              pw.Divider(thickness: 0.4, color: _line),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Dibuat otomatis oleh UpahKu · Penggajian Harian Offline',
                    style: pw.TextStyle(font: body, fontSize: 5.8, color: _muted),
                  ),
                  pw.Text(
                    'Slip ini sah tanpa tanda tangan basah.',
                    style: pw.TextStyle(font: body, fontSize: 5.8, color: _muted),
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

  static String _hours(double value) {
    final String s = value.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s.replaceAll('.', ',');
  }
}
