import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/typography.dart';
import '../widgets/ds/design_system.dart';
import '../widgets/ds/ds_bottom_nav.dart';
import 'dashboard/hari_ini_page.dart';
import 'karyawan/karyawan_list_page.dart';
import 'absensi/absensi_page.dart';
import 'lembur/lembur_page.dart';
import 'bonus_potongan/bonus_potongan_page.dart';
import 'gaji/gaji_hub_page.dart';
import 'lainnya/lainnya_page.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = _initialIndex();

  static int _initialIndex() {
    if (!kIsWeb) return 0;
    final int? tab = int.tryParse(Uri.base.queryParameters['tab'] ?? '');
    if (tab == null || tab < 0 || tab > 4) return 0;
    return tab;
  }

  static const List<DsNavItem> _items = [
    DsNavItem(
      label: 'Hari Ini',
      icon: Icons.today_outlined,
      selectedIcon: Icons.today_rounded,
    ),
    DsNavItem(
      label: 'Absensi',
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check_rounded,
    ),
    DsNavItem(
      label: 'Gaji',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
    ),
    DsNavItem(
      label: 'Data',
      icon: Icons.badge_outlined,
      selectedIcon: Icons.badge_rounded,
    ),
    DsNavItem(
      label: 'Lainnya',
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HariIniPage(
            onOpenMenu: () => setState(() => _currentIndex = 4),
            onOpenAbsensi: () => setState(() => _currentIndex = 1),
            onOpenGaji: () => setState(() => _currentIndex = 2),
            onOpenData: () => setState(() => _currentIndex = 3),
          ),
          const _InputHarianTabs(),
          const GajiHubPage(),
          const KaryawanListPage(),
          const LainnyaPage(),
        ],
      ),
      bottomNavigationBar: DsBottomNav(
        currentIndex: _currentIndex,
        onTap: (int i) => setState(() => _currentIndex = i),
        items: _items,
      ),
    );
  }
}

class _InputHarianTabs extends StatelessWidget {
  const _InputHarianTabs();

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: s.surface,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        isDark
                            ? 'assets/images/logo_mark_dark.png'
                            : 'assets/images/logo_mark.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PENCATATAN HARIAN',
                            style: AppTypography.monoLabel.copyWith(color: s.onSurfaceVariant),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Absensi',
                            style: AppTypography.headlineLg.copyWith(color: s.onSurface),
                          ),
                        ],
                      ),
                    ),
                    const DsPill(label: 'Harian', tone: DsTone.neutral, dense: true),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: s.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: s.outlineVariant),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: s.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: s.outlineVariant),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: s.onSurface,
                  unselectedLabelColor: s.onSurfaceVariant,
                  labelStyle: AppTypography.labelMd.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: AppTypography.labelMd.copyWith(fontSize: 11.5),
                  tabs: const [
                    Tab(
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fact_check_outlined, size: 16),
                          SizedBox(width: 5),
                          Text('Absensi'),
                        ],
                      ),
                    ),
                    Tab(
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule_outlined, size: 16),
                          SizedBox(width: 5),
                          Text('Lembur'),
                        ],
                      ),
                    ),
                    Tab(
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_card_outlined, size: 16),
                          SizedBox(width: 5),
                          Text('Bonus'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Expanded(
                child: TabBarView(
                  children: [
                    AbsensiPage(),
                    LemburPage(),
                    BonusPotonganPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
