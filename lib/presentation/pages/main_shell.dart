import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';
import '../painters/liquid_indicator_painter.dart';
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
    with TickerProviderStateMixin {
  /// Animasi lift & scale untuk ikon yang aktif
  late AnimationController _controller;

  /// Animasi gelombang air berkesinambungan
  late AnimationController _waveController;

  /// Pengendali transisi geser horizontal indikator cairan
  late AnimationController _indicatorController;
  late Animation<double> _indicatorAnimation;
  late double _lastIndex;

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

    // Animasi gelombang cairan lambat looping terus-menerus
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Setup transisi geser indikator cairan air antar tab
    _lastIndex = widget.currentIndex.toDouble();
    _indicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _indicatorAnimation = AlwaysStoppedAnimation<double>(_lastIndex);
  }

  @override
  void didUpdateWidget(_LumaNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Trigger animasi lift ikon
      _controller.forward(from: 0);

      // Trigger transisi meluncur dinamis untuk indikator cairan air (efek springy)
      _lastIndex = _indicatorAnimation.value;
      _indicatorAnimation = Tween<double>(
        begin: _lastIndex,
        end: widget.currentIndex.toDouble(),
      ).animate(
        CurvedAnimation(
          parent: _indicatorController,
          curve: Curves.easeOutBack, // springy overshoot meniru inersia air!
        ),
      );
      _indicatorController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    
    return Container(
      margin: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: p.bgSurface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: p.borderFaint.withValues(alpha: 0.35),
                width: 0.8,
              ),
            ),
            child: Stack(
              children: [
                // 1. Background Layer: Liquid indicator yang dinamis & bergoyang lembut
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_indicatorController, _waveController]),
                    builder: (context, _) {
                      return CustomPaint(
                        painter: LiquidIndicatorPainter(
                          activeTabProgress: _indicatorAnimation.value,
                          waveAnimationValue: _waveController.value,
                          tabCount: widget.labels.length,
                          accentColor: p.accent,
                          accentLightColor: p.accentLight,
                        ),
                      );
                    },
                  ),
                ),
                
                // 2. Foreground Layer: Item Navigasi (Ikon + Label)
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu item nav dengan animasi naik + dot indicator digantikan spacer konstan
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

              // Spacer konstan setinggi 6px untuk menjaga keseimbangan layout vertikal
              // yang sebelumnya diisi oleh dot indicator (4px + 2px spacing)
              const SizedBox(height: 6),
            ],
          );
        },
      ),
    );
  }
}
