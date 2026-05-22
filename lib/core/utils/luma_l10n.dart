import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/bloc/settings_bloc.dart';

/// LumaL10n — Helper lokalisasi ringan untuk Luma.
///
/// Tidak menggunakan flutter_localizations / ARB files — terlalu berat
/// untuk dua bahasa dengan string yang relatif sedikit.
///
/// Cara pakai:
///   final l = context.l10n;
///   Text(l.insight)          // → 'Insight' atau 'Insight' (sama)
///   Text(l.thisWeek)         // → 'MINGGU INI' atau 'THIS WEEK'
///
/// Atau shortcut:
///   Text(context.t('MINGGU INI', 'THIS WEEK'))
extension LumaL10nContext on BuildContext {
  /// True jika bahasa aktif adalah Bahasa Indonesia
  bool get isId {
    try {
      final settings = read<SettingsNotifier>();
      return settings.languageCode == 'id';
    } catch (_) {
      // SettingsNotifier tidak tersedia (mis. di onboarding sebelum provider)
      // Fallback ke locale sistem
      return Localizations.localeOf(this).languageCode == 'id';
    }
  }

  /// Shortcut: pilih string berdasarkan bahasa aktif
  String t(String id, String en) => isId ? id : en;

  /// Accessor ke semua string terlokalisasi
  LumaStrings get l10n => LumaStrings(isId);
}

/// Semua string user-visible Luma dalam dua bahasa.
/// Diakses via `context.l10n.namaString`.
class LumaStrings {
  final bool _isId;
  const LumaStrings(this._isId);

  String _t(String id, String en) => _isId ? id : en;

  // ── Navigation ─────────────────────────────────────────────────────────────
  String get navHome       => _t('Beranda', 'Home');
  String get navRhythm     => _t('Ritme', 'Rhythm');
  String get navSettings   => _t('Pengaturan', 'Settings');

  // ── Home page ──────────────────────────────────────────────────────────────
  String get thisWeek      => _t('MINGGU INI', 'THIS WEEK');
  String get insight       => 'Insight';
  String get viewAll       => _t('Lihat Semua', 'View All');
  String get hide          => _t('Sembunyikan', 'Hide');
  String get viewPrevious  => _t('Lihat insight sebelumnya', 'View previous insights');
  String get somethingDiff => _t('Sesuatu berbeda hari ini.', 'Something feels different today.');
  String get tryAgain      => _t('Coba lagi', 'Try again');
  String get lumaObserving => _t('Luma sedang mengamati hari ini.', 'Luma is quietly observing today.');
  String get notEveryDay   => _t('Tidak setiap hari perlu diberi nama.', 'Not every day needs to be named.');
  String get lumaWatching  => _t('Luma masih mengamati ritmemu.', 'Luma is still observing your rhythm.');
  String get patternsAppear => _t('Biasanya pola mulai terlihat setelah beberapa hari.', 'Patterns usually begin to appear after a few days.');

  // ── Rhythm page ────────────────────────────────────────────────────────────
  String get rhythmTitle   => _t('Ritme', 'Rhythm');
  String get lumaAttention => _t('PERHATIAN LUMA', "LUMA'S ATTENTION");
  String get prevNotes     => _t('Catatan Sebelumnya', 'Previous Notes');
  String get noNotes       => _t('Belum ada catatan tersimpan.', 'No notes saved yet.');
  String get noNotesHint   => _t('Setiap kali Luma berkata sesuatu, ia akan tinggal di sini.', 'Whenever Luma speaks, it will rest here.');

  // ── InsightCard ────────────────────────────────────────────────────────────
  String get badgeWarning  => _t('PERHATIAN', 'WARNING');
  String get badgeNotice   => _t('CATATAN', 'NOTE');
  String get badgePattern  => _t('POLA', 'PATTERN');
  String get badgeInfo     => 'INFO';
  String get timeJustNow   => _t('BARU SAJA', 'JUST NOW');
  String get timeYesterday => _t('KEMARIN', 'YESTERDAY');
  String daysAgo(int d)    => _isId ? '${d}H LALU' : '${d}D AGO';
  String get timeLastWeek  => _t('MINGGU LALU', 'LAST WEEK');
  String get insightFooter => _t(
    'Luma akan terus mengamati. Pola biasanya muncul setelah beberapa hari.',
    'Luma will keep observing. Patterns usually emerge after a few days.',
  );
  String get firstInsightFooter => _t(
    'Ini baru permulaan. Luma akan semakin mengenalmu.',
    'This is just the beginning. Luma will come to know you.',
  );

  // ── Permission gate ────────────────────────────────────────────────────────
  String get permTitle     => _t('Luma butuh izin\nuntuk bekerja.', 'Luma needs permission\nto work.');
  String get permSubtitle  => _t('Tidak ada yang dinilai. Semua data hanya ada di perangkatmu.', 'Nothing is judged. All data stays on your device.');
  String get permUsageTitle   => _t('Akses ke daftar aplikasi', 'App usage access');
  String get permUsageSubtitle => _t('Luma melihat app apa saja yang kamu buka — ini satu-satunya cara Luma bisa mengamati.', 'Luma sees which apps you open — this is the only way Luma can observe.');
  String get permNotifTitle   => _t('Notifikasi insight', 'Insight notifications');
  String get permNotifSubtitle => _t('Luma memberi tahu saat ada pola baru yang muncul.', 'Luma notifies you when new patterns emerge.');
  String get permNotifDenied  => _t('Buka Pengaturan untuk mengaktifkan notifikasi.', 'Open Settings to enable notifications.');
  String get permRequired  => _t('WAJIB', 'REQUIRED');
  String get permOptional  => _t('OPSIONAL', 'OPTIONAL');
  String get permContinue  => _t('Lanjut', 'Continue');
  String get permSkip      => _t('Lewati dulu', 'Skip for now');
  String get permOpenSettings => _t('Buka Pengaturan', 'Open Settings');

  // ── Onboarding ─────────────────────────────────────────────────────────────
  // Onboarding selalu dalam bahasa Indonesia (filosofi: Luma adalah produk lokal)
  // tapi tetap disediakan EN untuk konsistensi
  String get slide1Title   => _t('Luma belum mengenal\nritmemu.', "Luma doesn't know\nyour rhythm yet.");
  String get slide1Sub     => _t(
    'Tidak ada form. Tidak ada target.\nLuma belajar kapan pagimu dimulai — bisa jam 6 pagi, bisa jam 10 malam.',
    'No forms. No targets.\nLuma learns when your morning starts — could be 6am, could be 10pm.',
  );
  String get slide1Btn     => _t('Lanjut', 'Continue');
  String get slide2Title   => _t('Luma mengamati.\nBukan menghakimi.', 'Luma observes.\nNot judges.');
  String get slide2Sub     => _t('Semua data hanya ada di perangkatmu.\nKami tidak bisa melihatnya.', 'All data stays on your device.\nWe cannot see it.');
  String get slide2Btn     => _t('Aku percaya.', 'I trust this.');
  String get slide3Title   => _t('Beberapa hari ke depan,\nLuma akan menyapamu.', 'In the coming days,\nLuma will greet you.');
  String get slide3Sub     => _t('Tidak ada yang perlu dilakukan.\nHanya... gunakan perangkatmu.', 'Nothing to do.\nJust... use your device.');
  String get slide3Btn     => _t('Mulai Gunakan', 'Get Started');
  String get timelineDay12 => _t('Hari 1–2', 'Day 1–2');
  String get timelineDay3  => _t('Hari 3', 'Day 3');
  String get timelineDay7  => _t('Hari 7', 'Day 7');
  String get timelineObs   => _t('Mengamati...', 'Observing...');
  String get timelineGreet => _t('Sapaan pertama', 'First greeting');
  String get timelineWeekly => _t('Refleksi mingguan', 'Weekly reflection');

  // ── Header ─────────────────────────────────────────────────────────────────
  String get lumaTitle     => 'Luma';

  // ── FadingLineChart ────────────────────────────────────────────────────────
  String get patternsSaved => _t('Pola tetap tersimpan.', 'Patterns remain.');
  String get lumaObservingRhythm => _t('Luma mengamati ritmemu.', 'Luma is observing your rhythm.');
  String get patternLearning => _t('Pola masih dipelajari...', 'Pattern still being learned...');
  String get lumaMorningObservation => _t('Luma menangkap awal pagimu yang sunyi...', 'Luma catches the silence of your early morning...');
  String get lumaNightObservation => _t('Mendengarkan frekuensi malammu...', 'Listening to the frequency of your night...');
  String get lumaDayObservation => _t('Menyelaraskan dengan deru harimu...', 'Aligning with the hum of your day...');
}
