import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/date_formatter.dart';
import 'data/datasources/local/isar_service_impl.dart';
import 'presentation/providers/karyawan_provider.dart'; // holds isarServiceProvider
import 'presentation/providers/onboarding_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/pages/welcome/welcome_page.dart';
import 'presentation/pages/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting for Indonesian locale
  await DateFormatter.init();

  // Initialize Isar database synchronously on startup (Android only)
  final isarService = IsarServiceImpl();
  if (!kIsWeb) {
    await isarService.init();
  }

  runApp(
    ProviderScope(
      overrides: [
        isarServiceProvider.overrideWithValue(isarService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboarding = ref.watch(onboardingProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'UpahKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: hasCompletedOnboarding ? const MainShell() : const WelcomePage(),
    );
  }
}
