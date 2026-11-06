import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/date_formatter.dart';
import 'data/models/absensi_model.dart';
import 'data/models/karyawan_model.dart';
import 'data/models/lembur_model.dart';
import 'data/models/transaksi_tambahan_model.dart';
import 'data/repositories/mock_repositories.dart';
import 'presentation/providers/onboarding_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/pages/welcome/welcome_page.dart';
import 'presentation/pages/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable dynamic font downloading to prevent app from hanging on startup in offline mode
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialize date formatting for Indonesian locale
  try {
    await DateFormatter.init();
  } catch (e) {
    debugPrint('Error initializing date formatting: $e');
  }

  // Demo data hanya untuk preview web (?preview=1). Tidak menyentuh mobile.
  if (kIsWeb && Uri.base.queryParameters['preview'] == '1') {
    _seedPreviewData();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

void _seedPreviewData() {
  if (InMemoryDb.karyawanList.isNotEmpty) return;

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);

  final List<(String, String, double, double, String, double)> rows =
      <(String, String, double, double, String, double)>[
    ('Joko Prasetyo', 'Mandor', 225000, 42000, 'Hadir', 1.0),
    ('Slamet Riyadi', 'Tukang Batu', 160000, 30000, 'Hadir', 0.5),
    ('Asep Saepudin', 'Tukang Kayu', 160000, 30000, 'Hadir', 0.0),
    ('Dedi Kurniawan', 'Kenek', 125000, 23500, 'Hadir', 1.0),
    ('Rudi Hartono', 'Tukang Besi', 155000, 29000, 'Izin', 0.0),
    ('Wawan Setiawan', 'Kenek', 125000, 23500, 'Sakit', 0.0),
    ('Agus Salim', 'Tukang Batu', 160000, 30000, 'Alfa', 0.0),
    ('H. Suryana', 'Pengawas', 200000, 37500, 'Hadir', 0.0),
  ];

  int id = 1;
  for (final (String nama, String jabatan, double upah, double tarif, String status, double jam) in rows) {
    final KaryawanModel k = KaryawanModel()
      ..id = id
      ..nama = nama
      ..jabatan = jabatan
      ..upahHarian = upah
      ..tarifLembur = tarif
      ..statusAktif = true
      ..createdAt = now;
    InMemoryDb.karyawanList.add(k);

    final AbsensiModel a = AbsensiModel()
      ..id = id
      ..tanggal = today
      ..status = status;
    a.karyawan.value = k;
    InMemoryDb.absensiList.add(a);

    if (jam > 0) {
      final LemburModel l = LemburModel()
        ..id = id
        ..tanggal = today
        ..jumlahJam = jam;
      l.karyawan.value = k;
      InMemoryDb.lemburList.add(l);
    }
    id++;
  }

  final TransaksiTambahanModel bonus = TransaksiTambahanModel()
    ..id = 1
    ..tanggal = today
    ..nominal = 150000
    ..tipe = 'Bonus'
    ..keterangan = 'Bonus lembur proyek';
  bonus.karyawan.value = InMemoryDb.karyawanList.first;
  InMemoryDb.transaksiList.add(bonus);

  final TransaksiTambahanModel kasbon = TransaksiTambahanModel()
    ..id = 2
    ..tanggal = today
    ..nominal = 100000
    ..tipe = 'Kasbon'
    ..keterangan = 'Kasbon harian';
  kasbon.karyawan.value = InMemoryDb.karyawanList[3];
  InMemoryDb.transaksiList.add(kasbon);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboarding = ref.watch(onboardingProvider);
    final themeMode = ref.watch(themeModeProvider);
    // Web preview hook: buka shell langsung tanpa mengubah data onboarding.
    final bool previewShell = kIsWeb && Uri.base.queryParameters['preview'] == '1';

    return MaterialApp(
      title: 'UpahKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (BuildContext context, Widget? child) {
        // Pin text scaling so the dense numeric layouts stay aligned.
        final MediaQueryData mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: mq.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.2)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: (hasCompletedOnboarding || previewShell) ? const MainShell() : const WelcomePage(),
    );
  }
}
