import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/home_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/insight_card.dart';
import '../widgets/timeline_visualizer.dart';
import '../widgets/theme_switcher.dart';
import '../../core/themes/colors.dart';
import 'settings_page.dart';

/// Home page - Main dashboard Luma
/// Menampilkan fading timeline, focus ring, dan insight feed
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load data saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeNotifier>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luma'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: Consumer3<HomeNotifier, ThemeNotifier, SettingsNotifier>(
        builder: (context, homeState, themeState, settingsState, child) {
          if (homeState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (homeState.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textDarkSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    homeState.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textDarkSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<HomeNotifier>().refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeNotifier>().refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Focus Ring section
                Center(
                  child: FocusRing(
                    focusLevel: homeState.focusLevel,
                    size: 140,
                  ),
                ),
                const SizedBox(height: 24),

                // Weekly Timeline
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '7 Hari Terakhir',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Icon(
                              Icons.trending_up,
                              color: AppColors.primaryDark,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TimelineVisualizer(
                          weeklyData: homeState.weeklyData,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Today's Summary
                if (homeState.todaySummary != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hari Ini',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                Icons.screen_share,
                                '${homeState.todaySummary!['screenTime']}',
                                'Jam Layar',
                              ),
                              _buildStatItem(
                                context,
                                Icons.phone_android,
                                '${homeState.todaySummary!['unlocks']}',
                                'Unlocks',
                              ),
                              _buildStatItem(
                                context,
                                Icons.psychology,
                                '${(homeState.todaySummary!['focusScore'] * 100).toInt()}%',
                                'Fokus',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Insights section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Insight',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all insights
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (homeState.insights.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 48,
                              color: AppColors.textDarkSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              settingsState.languageCode == 'id'
                                  ? 'Belum ada insight'
                                  : 'No insights yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              settingsState.languageCode == 'id'
                                  ? 'Luma butuh beberapa hari untuk mengenali polamu'
                                  : 'Luma needs a few days to recognize your patterns',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textDarkSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeState.insights.length,
                    itemBuilder: (context, index) {
                      final insight = homeState.insights[index];
                      return InsightCard(
                        id: insight['id'],
                        title: insight['title'],
                        message: insight['message'],
                        severity: insight['severity'],
                        timestamp: insight['timestamp'],
                        isRead: false,
                        onTap: () {
                          // TODO: Mark as read
                        },
                        onDismiss: () {
                          // TODO: Dismiss insight
                        },
                      );
                    },
                  ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryDark,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textDarkSecondary,
              ),
        ),
      ],
    );
  }

  void _navigateToSettings() {
    final settingsBloc = context.read<SettingsNotifier>();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          languageCode: settingsBloc.languageCode,
          notificationsEnabled: settingsBloc.notificationsEnabled,
          dataCollectionEnabled: settingsBloc.dataCollectionEnabled,
          themeMode: settingsBloc.themeMode,
          lastBackupDate: settingsBloc.lastBackupDate,
          onLanguageChanged: (code) => settingsBloc.setLanguage(code),
          onNotificationsToggled: (enabled) =>
              settingsBloc.toggleNotifications(),
          onDataCollectionToggled: (enabled) =>
              settingsBloc.toggleDataCollection(),
          onThemeChanged: (mode) => settingsBloc.setThemeMode(mode),
          onExportBackup: () => settingsBloc.exportBackup(),
          onImportBackup: () => settingsBloc.importBackup(),
        ),
      ),
    );
  }
}
