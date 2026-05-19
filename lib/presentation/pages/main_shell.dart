import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';
import 'home_page.dart';
import 'rhythm_page.dart';
import 'settings_page.dart';

/// MainShell — Container utama aplikasi dengan bottom navigation.
///
/// Memakai [IndexedStack] supaya tiap tab mempertahankan state, scroll
/// position, dan animasi orb tidak ter-reset saat user berpindah tab.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _tabs = <Widget>[
    HomePage(),
    RhythmPage(),
    SettingsPage(showBackButton: false),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsNotifier>();
    final isId = settings.languageCode == 'id';

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: _LumaNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        labels: isId
            ? const ['Beranda', 'Ritme', 'Pengaturan']
            : const ['Home', 'Rhythm', 'Settings'],
      ),
    );
  }
}

/// Custom bottom nav — minimal, tanpa elevation, sesuai bahasa visual Luma.
class _LumaNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  const _LumaNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.labels,
  });

  static const _icons = [
    (Icons.circle_outlined, Icons.circle),
    (Icons.show_chart_outlined, Icons.show_chart),
    (Icons.settings_outlined, Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgBase,
        border: Border(
          top: BorderSide(
            color: AppColors.borderFaint,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(labels.length, (i) {
              final selected = i == currentIndex;
              final (outlined, filled) = _icons[i];
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          selected ? filled : outlined,
                          key: ValueKey(selected),
                          size: 22,
                          color: selected
                              ? AppColors.textPrimary
                              : AppColors.textSubtle,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[i],
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w500 : FontWeight.w400,
                          color: selected
                              ? AppColors.textPrimary
                              : AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
