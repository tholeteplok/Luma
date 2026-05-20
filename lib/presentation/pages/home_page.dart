import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../bloc/home_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/ambient_orb.dart';
import '../widgets/first_insight_card.dart';import '../widgets/insight_card.dart';
import '../widgets/luma_app_header.dart';
import '../painters/fading_line_painter.dart';
import '../../core/themes/colors.dart';

/// Home page — Cermin ritme Luma
///
/// Layout (dari atas ke bawah):
///   Header → Orb (50% layar) → Insight → Timeline ringkasan
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeNotifier>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Scaffold(
      backgroundColor: p.bgBase,
      body: Consumer3<HomeNotifier, ThemeNotifier, SettingsNotifier>(
        builder: (context, homeState, themeState, settingsState, child) {
          return CustomScrollView(
            slivers: [
              // ── Header ────────────────────────────────────────────
              const SliverToBoxAdapter(child: LumaAppHeader()),

              // ── Loading ───────────────────────────────────────────
              if (homeState.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 1.5,
                    ),
                  ),
                )
              else if (homeState.error != null)
                SliverFillRemaining(
                  child: _buildErrorState(context, homeState),
                )
              else ...[
                // ── Orb — 50% layar ───────────────────────────────
                SliverToBoxAdapter(
                  child: _buildOrbSection(context, homeState),
                ),

                // ── Insight header ────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildInsightHeader(context, homeState),
                ),

                // ── Insight list / silent / empty ─────────────────
                ..._buildInsightSlivers(homeState, settingsState),

                // ── Timeline ringkasan (di bawah insight) ─────────
                SliverToBoxAdapter(
                  child: _buildTimelineSection(
                    context,
                    homeState,
                    settingsState.reduceMotion,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ],
          );
        },
      ),
    );
  }

  // ── Orb: 50% tinggi layar ──────────────────────────────────────────────────
  Widget _buildOrbSection(BuildContext context, HomeNotifier homeState) {
    final screenH = MediaQuery.sizeOf(context).height;
    final orbAreaH = screenH * 0.50;
    final orbSize = orbAreaH * 0.70;
    final reduceMotion = context.read<SettingsNotifier>().reduceMotion;

    return SizedBox(
      height: orbAreaH,
      child: Center(
        child: AmbientOrb(
          state: homeState.orbState,
          profile: homeState.ambienceProfile,
          size: orbSize,
          reduceMotion: reduceMotion,
          nostalgiaActive: homeState.nostalgiaActive,
        ),
      ),
    );
  }

  // ── Timeline ringkasan ─────────────────────────────────────────────────────
  Widget _buildTimelineSection(
    BuildContext context,
    HomeNotifier homeState,
    bool reduceMotion,
  ) {
    final p = context.luma;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MINGGU INI',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: p.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          FadingLineChart(
            weeklyData: homeState.weeklyData,
            height: 60,
            reduceMotion: reduceMotion,
            baselineDays: homeState.weeklyData
                .where((d) => (d['screenTimeSeconds'] as int? ?? 0) > 0)
                .length,
          ),
        ],
      ),
    );
  }

  // ── Insight header ─────────────────────────────────────────────────────────
  Widget _buildInsightHeader(BuildContext context, HomeNotifier homeState) {
    final p = context.luma;
    final showHistoryToggle =
        homeState.isSilent && homeState.history.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Insight',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: p.textPrimary,
            ),
          ),
          if (showHistoryToggle)
            GestureDetector(
              onTap: () => setState(() => _showHistory = !_showHistory),
              child: Text(
                _showHistory ? 'Sembunyikan' : 'Lihat insight sebelumnya',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: p.accent,
                ),
              ),
            )
          else
            Text(
              'Lihat Semua',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: p.accent,
              ),
            ),
        ],
      ),
    );
  }

  // ── Insight slivers ────────────────────────────────────────────────────────
  List<Widget> _buildInsightSlivers(
    HomeNotifier homeState,
    SettingsNotifier settingsState,
  ) {
    if (homeState.isSilent) {
      return [
        SliverToBoxAdapter(
          child: _buildSilentCard(settingsState),
        ),
        if (_showHistory && homeState.history.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InsightCard(
                  id: homeState.history[index]['id'] as String? ??
                      index.toString(),
                  title: homeState.history[index]['title'] as String? ?? '',
                  message: homeState.history[index]['message'] as String? ?? '',
                  severity:
                      homeState.history[index]['severity'] as String? ?? 'info',
                  timestamp:
                      homeState.history[index]['timestamp'] is DateTime
                          ? homeState.history[index]['timestamp'] as DateTime
                          : DateTime.now(),
                  isRead: true,
                  onTap: () {},
                  onDismiss: () {},
                ),
              ),
              childCount: homeState.history.length,
            ),
          ),
      ];
    }

    if (homeState.insights.isEmpty) {
      return [
        SliverToBoxAdapter(child: _buildEmptyInsight(settingsState)),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final insight = homeState.insights[index];
            // First insight (hari 1–3): widget khusus tanpa badge/feedback
            if (homeState.isFirstInsight) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FirstInsightCard(
                  title: insight['title'] as String? ?? '',
                  subtitle: insight['message'] as String? ?? '',
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InsightCard(
                id: insight['id'] as String? ?? index.toString(),
                title: insight['title'] as String? ?? '',
                message: insight['message'] as String? ?? '',
                severity: insight['severity'] as String? ?? 'info',
                timestamp: insight['timestamp'] is DateTime
                    ? insight['timestamp'] as DateTime
                    : DateTime.now(),
                isRead: insight['isRead'] as bool? ?? false,
                nostalgiaActive: homeState.nostalgiaActive &&
                    (insight['timestamp'] is DateTime
                        ? DateTime.now()
                            .difference(insight['timestamp'] as DateTime)
                            .inDays > 30
                        : false),
                onTap: () {},
                onDismiss: () {},
              ),
            );
          },
          childCount: homeState.insights.length,
        ),
      ),
    ];
  }

  // ── Silent card ────────────────────────────────────────────────────────────
  Widget _buildSilentCard(SettingsNotifier settingsState) {
    final p = context.luma;
    final isId = settingsState.languageCode == 'id';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: p.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(width: 2, color: p.gentleInd.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isId
                ? 'Luma sedang mengamati hari ini.'
                : 'Luma is quietly observing today.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 19,
              fontStyle: FontStyle.italic,
              color: p.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isId
                ? 'Tidak setiap hari perlu diberi nama.'
                : 'Not every day needs to be named.',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: p.textSubtle,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty insight ──────────────────────────────────────────────────────────
  Widget _buildEmptyInsight(SettingsNotifier settingsState) {
    final p = context.luma;
    final isId = settingsState.languageCode == 'id';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: p.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            isId
                ? 'Luma masih mengamati ritmemu.'
                : 'Luma is still observing your rhythm.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: p.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isId
                ? 'Biasanya pola mulai terlihat setelah beberapa hari.'
                : 'Patterns usually begin to appear after a few days.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: p.textSubtle,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildErrorState(BuildContext context, HomeNotifier homeState) {
    final p = context.luma;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sesuatu berbeda hari ini.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: p.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.read<HomeNotifier>().refresh(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: p.borderSubtle),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Coba lagi',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: p.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
