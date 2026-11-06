import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/onboarding_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import '../../widgets/ds/design_system.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _pageCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() => ref.read(onboardingProvider.notifier).completeOnboarding();

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isLast = _currentPage == _pageCount - 1;

    return Scaffold(
      backgroundColor: s.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        actions: [
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Lewati'),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int i) => setState(() => _currentPage = i),
                physics: const BouncingScrollPhysics(),
                children: [
                  _BrandSlide(logoAsset: _logoAsset(context)),
                  const _FeaturesSlide(),
                  const _OfflineSlide(),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(_pageCount, (int i) {
                        final bool active = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: active ? 26 : 8,
                          decoration: BoxDecoration(
                            color: active ? s.primary : s.outlineVariant,
                            borderRadius: AppRadius.rPill,
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 52,
                      width: isLast ? 168 : 52,
                      child: FilledButton(
                        onPressed: () {
                          if (isLast) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(borderRadius: AppRadius.rPill),
                        ),
                        child: isLast
                            ? const Text('Mulai Sekarang')
                            : const Icon(Icons.arrow_forward_rounded, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _logoAsset(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? 'assets/images/logo_dark.png'
          : 'assets/images/logo_light.png';
}

class _BrandSlide extends StatelessWidget {
  const _BrandSlide({required this.logoAsset});

  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: AppRadius.rXl,
            child: Image.asset(logoAsset, height: 112, width: 112, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('UpahKu', style: AppTypography.displayLg.copyWith(color: s.primary)),
          const SizedBox(height: AppSpacing.sm),
          const DsPill(
            label: 'Penggajian Harian Offline',
            tone: DsTone.secondary,
            icon: Icons.offline_bolt_rounded,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Kelola Penggajian Karyawan Lebih Mudah',
            textAlign: TextAlign.center,
            style: AppTypography.headlineLgMobile.copyWith(color: s.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Catat absensi, lembur, bonus, dan hitung gaji harian secara '
            'otomatis dalam satu aplikasi.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLg.copyWith(color: s.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSlide extends StatelessWidget {
  const _FeaturesSlide();

  static const List<({String title, IconData icon, DsTone tone})> _features = [
    (title: 'Data Karyawan', icon: Icons.badge_rounded, tone: DsTone.primary),
    (title: 'Absensi Harian', icon: Icons.fact_check_rounded, tone: DsTone.success),
    (title: 'Lembur', icon: Icons.schedule_rounded, tone: DsTone.warning),
    (title: 'Bonus & Potongan', icon: Icons.add_card_rounded, tone: DsTone.info),
    (title: 'Slip Gaji PDF', icon: Icons.picture_as_pdf_rounded, tone: DsTone.danger),
    (title: 'Backup Data', icon: Icons.backup_rounded, tone: DsTone.secondary),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Semua Kebutuhan dalam Satu Aplikasi',
            textAlign: TextAlign.center,
            style: AppTypography.headlineLgMobile.copyWith(color: s.onSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.55,
              children: [
                for (final ({IconData icon, DsTone tone, String title}) f in _features)
                  DsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: f.tone.bg(s),
                            borderRadius: AppRadius.rSm,
                          ),
                          child: Icon(f.icon, size: 18, color: f.tone.fg(s)),
                        ),
                        Text(
                          f.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMd.copyWith(
                            color: s.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineSlide extends StatelessWidget {
  const _OfflineSlide();

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: s.primary.withValues(alpha: 0.05),
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: s.secondaryContainer.withValues(alpha: 0.45),
                ),
              ),
              Container(
                width: 104,
                height: 168,
                decoration: BoxDecoration(
                  color: s.primary,
                  borderRadius: AppRadius.rXl,
                  boxShadow: AppShadows.level2,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: s.onPrimary,
                        borderRadius: AppRadius.rSm,
                      ),
                      child: Icon(Icons.payments_rounded, color: s.primary, size: 22),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final double w in const [56.0, 40.0, 48.0]) ...[
                      Container(
                        height: 6,
                        width: w,
                        decoration: BoxDecoration(
                          color: s.onPrimary.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
              Positioned(
                right: 6,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: s.primary,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.level2,
                  ),
                  child: Icon(Icons.shield_rounded, color: s.onPrimary, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Siap Digunakan Kapan Saja',
            textAlign: TextAlign.center,
            style: AppTypography.headlineLgMobile.copyWith(color: s.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Seluruh data disimpan langsung di perangkat Android tanpa internet '
            'maupun server. Aman, cepat, dan rahasia.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLg.copyWith(color: s.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
