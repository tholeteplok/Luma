import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/themes/colors.dart';
import '../../domain/entities/insight_id.dart';
import '../../domain/services/dimension_rotation.dart';
import '../bloc/home_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../painters/fading_line_painter.dart';
import '../widgets/insight_card.dart';
import '../widgets/luma_app_header.dart';

/// RhythmPage — Halaman ritme & detail.
///
/// Berisi:
/// - Timeline mingguan (FadingLineChart) versi lebih besar
/// - Konteks observasi Luma minggu ini (dimensi & kedalaman)
/// - Riwayat insight dari InsightMemory (read-only)
class RhythmPage extends StatelessWidget {
  const RhythmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Consumer2<HomeNotifier, SettingsNotifier>(
        builder: (context, home, settings, _) {
          final isId = settings.languageCode == 'id';
          final history = home.history;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: LumaAppHeader(
                  title: isId ? 'Ritme' : 'Rhythm',
                ),
              ),
              SliverToBoxAdapter(
                child: _buildTimelineCard(home, settings.reduceMotion),
              ),
              SliverToBoxAdapter(
                child: _buildContextCard(home, isId),
              ),
              SliverToBoxAdapter(
                child: _buildHistoryHeader(isId, history.length),
              ),
              if (history.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEmptyHistory(isId),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = history[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: InsightCard(
                          id: item['id'] as String? ?? index.toString(),
                          title: item['title'] as String? ?? '',
                          message: item['message'] as String? ?? '',
                          severity: item['severity'] as String? ?? 'info',
                          timestamp: item['timestamp'] is DateTime
                              ? item['timestamp'] as DateTime
                              : DateTime.now(),
                          isRead: true,
                          onTap: () {},
                          onDismiss: () {},
                        ),
                      );
                    },
                    childCount: history.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimelineCard(HomeNotifier home, bool reduceMotion) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
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
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          FadingLineChart(
            weeklyData: home.weeklyData,
            height: 96,
            reduceMotion: reduceMotion,
          ),
        ],
      ),
    );
  }

  Widget _buildContextCard(HomeNotifier home, bool isId) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isId ? 'PERHATIAN LUMA' : "LUMA'S ATTENTION",
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _dimensionPhrase(home.activeDimension, isId),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _depthPhrase(home.depth, isId),
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.textTertiary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(bool isId, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isId ? 'Catatan Sebelumnya' : 'Previous Notes',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (count > 0)
            Text(
              '$count',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory(bool isId) {
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
                ? 'Belum ada catatan tersimpan.'
                : 'No notes saved yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isId
                ? 'Setiap kali Luma berkata sesuatu, ia akan tinggal di sini.'
                : "Whenever Luma speaks, it will rest here.",
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

  String _dimensionPhrase(InsightDimension d, bool isId) {
    return switch (d) {
      InsightDimension.morningRhythm => isId
          ? 'Minggu ini, Luma lebih memperhatikan ritme pagimu.'
          : "This week, Luma is paying closer attention to your morning rhythm.",
      InsightDimension.distractionFlow => isId
          ? 'Minggu ini, Luma mengamati aliran perhatian dan distraksi.'
          : "This week, Luma is observing the flow of attention and distraction.",
      InsightDimension.restPattern => isId
          ? 'Minggu ini, Luma memperhatikan pola istirahat dan malammu.'
          : "This week, Luma is watching your rest and night patterns.",
      InsightDimension.energyRecovery => isId
          ? 'Minggu ini, Luma memperhatikan pemulihan energimu.'
          : "This week, Luma is attending to your energy recovery.",
    };
  }

  String _depthPhrase(DepthLevel depth, bool isId) {
    return switch (depth) {
      DepthLevel.surface => isId
          ? 'Masih hari-hari pertama — observasi ringan.'
          : 'Still the early days — light observations.',
      DepthLevel.pattern => isId
          ? 'Pola mingguan mulai terbaca.'
          : 'Weekly patterns are starting to emerge.',
      DepthLevel.relationship => isId
          ? 'Hubungan antar pola mulai terlihat.'
          : 'Relationships between patterns are becoming visible.',
      DepthLevel.longitudinal => isId
          ? 'Ritme jangka panjangmu mulai terdengar.'
          : 'Your long-term rhythm is becoming audible.',
    };
  }
}
