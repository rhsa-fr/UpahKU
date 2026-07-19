import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Hitung Gaji Bersih Test', () {
    const double upahHarian = 150000;
    const double tarifLembur = 20000;
    const int totalHadir = 5;
    const double totalJamLembur = 3.5;
    const double totalBonus = 50000;
    const double totalPotongan = 10000;
    const double totalKasbon = 20000;

    final totalUpahKerja = totalHadir * upahHarian;
    final totalUpahLembur = totalJamLembur * tarifLembur;
    
    final totalGajiBersih = totalUpahKerja + totalUpahLembur + totalBonus - totalPotongan - totalKasbon;

    expect(totalUpahKerja, 750000);
    expect(totalUpahLembur, 70000);
    expect(totalGajiBersih, 840000);
  });
}
