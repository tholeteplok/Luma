import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';
import 'home_page.dart';
import 'rhythm_page.dart';
import 'settings_page.dart';

/// MainShell — Container utama dengan bottom navigation.
/// IndexedStack mempertahankan state & animasi tiap tab.
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
    final p = context.luma;
    final settings = context.watch<SettingsNotifier>();
    final isId = settings.languageCode == 'id';

    return Scaffold(
      backgroundColor: p.bgBase,
      // extendBody: true agar konten bisa terlihat di belakang NavBar
      // sehingga BackdropFilter blur benar-benar melihat konten di belakangnya
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _tabs),
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

class _LumaNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  const _LumaNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.labels,
  });

  @override
  State<_LumaNavBar> createState() => _LumaNavBarState();
}

class _LumaNavBarState extends State<_LumaNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _icons = [
    (Icons.circle_outlined, Icons.circle),
    (Icons.show_chart_outlined, Icons.show_chart),
    (Icons.settings_outlined, Icons.settings),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void didUpdateWidget(_LumaNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: Container(
          decoration: BoxDecoration(
            color: p.bgBase.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(color: p.borderFaint, width: 0.5),
            ),
          ),
          child: SafeArea(
            top: false,
            // Overflow visible agar ikon aktif bisa naik ke atas border
            child: SizedBox(
              height: 64,
              child: Row(
                children: List.generate(widget.labels.length, (i) {
                  return Expanded(
                    child: _NavItem(
                      index: i,
                      currentIndex: widget.currentIndex,
                      icon: _icons[i].$1,
                      activeIcon: _icons[i].$2,
                      label: widget.labels[i],
                      controller: _controller,
                      onTap: () => widget.onTap(i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu item nav dengan animasi naik + dot indicator
class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final AnimationController controller;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.controller,
    required this.onTap,
  });

  bool get _isSelected => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    final p = context.luma;

    // Animasi lift: ikon aktif naik 8px, spring curve
    final liftAnim = _isSelected
        ? Tween<double>(begin: 0, end: -8).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          )
        : const AlwaysStoppedAnimation<double>(0);

    // Animasi scale: ikon aktif sedikit membesar
    final scaleAnim = _isSelected
        ? Tween<double>(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          )
        : const AlwaysStoppedAnimation<double>(1.0);

    // Animasi dot: muncul saat aktif
    final dotAnim = _isSelected
        ? Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
            ),
          )
        : const AlwaysStoppedAnimation<double>(0);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Ikon dengan lift + scale ──────────────────────────────────
              Transform.translate(
                offset: Offset(0, liftAnim.value),
                child: Transform.scale(
                  scale: scaleAnim.value,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isSelected ? activeIcon : icon,
                      key: ValueKey(_isSelected),
                      size: 22,
                      color: _isSelected
                          ? p.textPrimary
                          : p.textSubtle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 3),

              // ── Label — fade saat tidak aktif ─────────────────────────────
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight:
                      _isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: _isSelected ? p.textPrimary : p.textSubtle,
                ),
                child: Text(label),
              ),

              const SizedBox(height: 2),

              // ── Dot indicator — muncul saat aktif ─────────────────────────
              SizedBox(
                height: 4,
                child: FadeTransition(
                  opacity: dotAnim,
                  child: ScaleTransition(
                    scale: dotAnim,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.accent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
