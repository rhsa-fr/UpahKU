import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/background_wrapper.dart';
import 'dashboard/dashboard_page.dart';
import 'karyawan/karyawan_list_page.dart';
import 'absensi/absensi_page.dart';
import 'lembur/lembur_page.dart';
import 'bonus_potongan/bonus_potongan_page.dart';
import 'riwayat/riwayat_page.dart';
import 'settings/settings_page.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            DashboardPage(),
            KaryawanListPage(),
            _InputHarianTabs(),
            RiwayatPage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Karyawan',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Input Harian',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Penggajian',
          ),
        ],
      ),
    );
  }
}

class _InputHarianTabs extends StatelessWidget {
  const _InputHarianTabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Pencatatan Harian'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Absensi', icon: Icon(Icons.assignment_ind_outlined)),
              Tab(text: 'Lembur', icon: Icon(Icons.schedule_outlined)),
              Tab(text: 'Tambahan', icon: Icon(Icons.add_card_outlined)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AbsensiPage(),
            LemburPage(),
            BonusPotonganPage(),
          ],
        ),
      ),
    );
  }
}
