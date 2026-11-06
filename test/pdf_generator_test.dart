import 'dart:io';

import 'package:daily_payroll/core/utils/date_formatter.dart';
import 'package:daily_payroll/core/utils/pdf_generator.dart';
import 'package:daily_payroll/data/models/karyawan_model.dart';
import 'package:daily_payroll/data/models/penggajian_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await DateFormatter.init();
  });

  test('slip gaji PDF dihasilkan dengan isi lengkap', () async {
    final KaryawanModel karyawan = KaryawanModel()
      ..id = 1
      ..nama = 'Joko Prasetyo'
      ..jabatan = 'Mandor'
      ..upahHarian = 225000
      ..tarifLembur = 42000
      ..statusAktif = true
      ..createdAt = DateTime(2026, 1, 1);

    final PenggajianModel payroll = PenggajianModel()
      ..tanggalGajian = DateTime(2026, 11, 7)
      ..periodeMulai = DateTime(2026, 11, 1)
      ..periodeSelesai = DateTime(2026, 11, 15)
      ..totalHadir = 12
      ..totalIzin = 1
      ..totalSakit = 0
      ..totalAlfa = 0
      ..totalJamLembur = 6
      ..upahHarianSaatItu = 225000
      ..tarifLemburSaatItu = 42000
      ..totalUpahKerja = 2700000
      ..totalUpahLembur = 252000
      ..totalBonus = 150000
      ..totalPotongan = 25000
      ..totalKasbon = 100000
      ..totalGajiBersih = 2977000;
    payroll.karyawan.value = karyawan;

    final bytes = await PdfGenerator.generateSlipGajiPdf(
      penggajian: payroll,
      namaUsaha: 'CV Karya Pantura',
      alamatUsaha: 'Jl. Raya Indramayu No. 12, Jawa Barat',
    );

    expect(bytes.length, greaterThan(2000));

    final File out = File('build/slip-test.pdf');
    out.parent.createSync(recursive: true);
    out.writeAsBytesSync(bytes);
    expect(out.existsSync(), isTrue);
  });
}
