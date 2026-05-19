import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../bloc/home_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/ambient_orb.dart';
import '../widgets/insight_card.dart';
import '../widgets/luma_app_header.dart';
import '../painters/fading_line_painter.dart';
import '../../core/themes/colors.dart';

/// Home page — Cermin ritme Luma
///
/// Tidak ada angka. Tidak ada penilaian.
/// Hanya refleksi tenang dari pola yang sudah ada.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Apakah panel "insight sebelumnya" sedang dibuka di mode silent
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeNotifier>().loadData();
    });
  }

  /// Mapping mood orb berdasarkan state.
  /// Saat silent, orb pindah ke mood `gentle` — Luma hadir tanpa berkata.
  AmbientMood _orbMood(HomeNotifier homeState) {
    if (homeState.isSilent) return AmbientMood.gentle;
    if (homeState.insights.isEmpty) return AmbientMood.rest;
    final top = homeState.insights.first['severity'] as String? ?? 'info';
    return moodFromSeverity(top);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Consumer3<HomeNotifier, ThemeNotifier, SettingsNotifier>(
        builder: (context, homeState, themeState, settingsState, child) {
          return CustomScrollView(
            slivers: [
              // ── Custom Header ──────────────────────────────────────
              const SliverToBoxAdapter(
                child: LumaAppHeader(),
              ),

              // ── Loading / Error State ──────────────────────────────
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
                // ── Ambient Orb Hero ───────────────────────────────
                SliverToBoxAdapter(
                  child: _buildAmbientSection(context, homeState),
                ),

                // ── Weekly Timeline ────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildTimelineSection(
                    context,
                    homeState,
                    settingsState.reduceMotion,
                  ),
                ),

                // ── Insights ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildInsightHeader(context, homeState),
                ),

                ..._buildInsightSlivers(homeState, settingsState),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Bangun bagian insight sesuai state:
  /// - Silent + ada history → kartu hening + opsi "lihat insight sebelumnya"
  /// - Silent tanpa history → empty state
  /// - Bicara → list insight hari ini
  List<Widget> _buildInsightSlivers(
    HomeNotifier homeState,
    SettingsNotifier settingsState,
  ) {
    if (homeState.isSilent) {
      return [
        SliverToBoxAdapter(
          child: _buildSilentCard(homeState, settingsState),
        ),
        if (_showHistory && homeState.history.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildHistoryInsightCard(
                  homeState.history[index],
                  index,
                ),
              ),
              childCount: homeState.history.length,
            ),
          ),
      ];
    }

    if (homeState.insights.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _buildEmptyInsight(context, settingsState),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final insight = homeState.insights[index];
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

  /// Ambient Orb section — hero visual tanpa angka
  Widget _buildAmbientSection(BuildContext context, HomeNotifier homeState) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AmbientOrb(
        mood: _orbMood(homeState),
        size: 140,
      ),
    );
  }

  /// Timeline section — "MINGGU INI" label + fading line chart
  Widget _buildTimelineSection(
    BuildContext context,
    HomeNotifier homeState,
    bool reduceMotion,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MINGGU INI',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FadingLineChart(
            weeklyData: homeState.weeklyData,
            height: 60,
            reduceMotion: reduceMotion,
          ),
        ],
      ),
    );
  }

  /// Insight section header — saat silent label + tombol berbeda
  Widget _buildInsightHeader(BuildContext context, HomeNotifier homeState) {
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
              color: AppColors.textPrimary,
            ),
          ),
          if (showHistoryToggle)
            GestureDetector(
              onTap: () => setState(() => _showHistory = !_showHistory),
              child: Text(
                _showHistory
                    ? 'Sembunyikan'
                    : 'Lihat insight sebelumnya',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accent,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                // TODO: Navigate to all insights (full archive)
              },
              child: Text(
                'Lihat Semua',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Kartu silent — Luma hadir tanpa berkata
  Widget _buildSilentCard(
    HomeNotifier homeState,
    SettingsNotifier settingsState,
  ) {
    final isId = settingsState.languageCode == 'id';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            width: 2,
            color: AppColors.gentleInd.withValues(alpha: 0.5),
          ),
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
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isId
                ? 'Tidak setiap hari perlu diberi nama.'
                : "Not every day needs to be named.",
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.textSubtle,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Insight card untuk history — tampilan ringkas, tanpa "BARU SAJA"
  Widget _buildHistoryInsightCard(Map<String, dynamic> item, int index) {
    return InsightCard(
      id: item['id'] as String? ?? index.toString(),
      title: item['title'] as String? ?? '',
      message: item['message'] as String? ?? '',
      severity: item['severity'] as String? ?? 'info',
      timestamp: item['timestamp'] is DateTime
          ? item['timestamp'] as DateTime
          : DateTime.now(),
      isRead: true, // history selalu dianggap sudah dibaca
      onTap: () {},
      onDismiss: () {},
    );
  }

  /// Empty state — hari pertama atau memang tidak ada data
  Widget _buildEmptyInsight(
    BuildContext context,
    SettingsNotifier settingsState,
  ) {
    final isId = settingsState.languageCode == 'id';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
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
              color: AppColors.textSecondary,
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
              color: AppColors.textSubtle,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Error state — minimal, tidak dramatis
  Widget _buildErrorState(BuildContext context, HomeNotifier homeState) {
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
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.read<HomeNotifier>().refresh(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderSubtle),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Coba lagi',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
