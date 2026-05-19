/// AppCategoryClassifier — Mengklasifikasikan paket Android ke kategori perilaku.
///
/// Tidak butuh API eksternal. Berbasis prefix matching pada packageName.
/// Luma tidak peduli NAMA aplikasinya — hanya kategori perilakunya.
library;

enum AppCategory {
  social, // Instagram, TikTok, Twitter, Reddit, Pinterest
  communication, // WhatsApp, Telegram, Gmail, Zoom, Meet
  productivity, // Docs, Notion, Calendar, Sheets, To-do
  entertainment, // YouTube, Netflix, Spotify, Games
  browsing, // Chrome, Firefox, DuckDuckGo
  health, // Gojek/Grab fitness, Samsung Health, Strava
  finance, // Banking, GoPay, OVO, Dana
  news, // Detik, Kompas, BBC, Reddit (news mode)
  unknown, // Default — tidak dikenali
}

class AppCategoryClassifier {
  // Semua perbandingan case-insensitive & prefix-based
  static const _social = [
    'com.instagram.android',
    'com.facebook.katana',
    'com.facebook.lite',
    'com.twitter.android',
    'com.twitter.lite',
    'com.snapchat.android',
    'com.tiktok',
    'com.zhiliaoapp.musically',
    'com.pinterest',
    'com.linkedin.android',
    'com.reddit.frontpage',
    'com.tumblr',
    'com.bereal',
    'com.discord',
    'com.vkontakte.android',
    'jp.naver.line.android',
    'com.kakao.talk',
  ];

  static const _communication = [
    'com.whatsapp',
    'com.whatsapp.w4b',
    'org.telegram.messenger',
    'org.telegram.plus',
    'org.thoughtcrime.securesms', // Signal
    'com.google.android.gm', // Gmail
    'com.microsoft.teams',
    'com.google.android.apps.meetings',
    'us.zoom.videomeetings',
    'com.skype.raider',
    'com.slack',
    'com.microsoft.office.outlook',
    'com.viber.voip',
    'com.truecaller',
    'com.android.mms',
    'com.google.android.apps.messaging',
  ];

  static const _productivity = [
    'com.google.android.apps.docs',
    'com.google.android.apps.sheets',
    'com.google.android.apps.slides',
    'com.google.android.apps.keep',
    'com.google.android.calendar',
    'com.microsoft.office.word',
    'com.microsoft.office.excel',
    'com.microsoft.office.powerpoint',
    'com.microsoft.launcher',
    'com.notion.id',
    'com.todoist',
    'com.evernote',
    'com.adobe.reader',
    'md.obsidian',
    'com.ticktick.task',
    'com.anydo',
    'com.onenote.android',
    'com.airtable.airtable',
    'com.clickup.team.pro',
    'com.asana.biz',
    'com.linear.app',
  ];

  static const _entertainment = [
    'com.google.android.youtube',
    'com.google.android.youtube.tv',
    'com.netflix.mediaclient',
    'com.spotify.music',
    'com.amazon.avod.thirdpartyclient', // Prime Video
    'com.disney.disneyplus',
    'com.hbo.hbonow',
    'com.apple.android.music',
    'com.soundcloud.android',
    'com.joox.client',
    'com.genie.app',
    'com.twitch.android.app',
    'com.deezer.android',
    'com.anghami',
    'tv.pluto.android',
    'com.mxtech.videoplayer.ad',
    'org.videolan.vlc',
    'com.viu',
    'com.vidio.android',
    'com.iflix',
    'com.apple.android.music',
  ];

  static const _browsing = [
    'com.android.chrome',
    'com.google.android.browser',
    'org.mozilla.firefox',
    'org.mozilla.focus',
    'com.brave.browser',
    'com.opera.browser',
    'com.microsoft.emmx', // Edge
    'com.duckduckgo.mobile.android',
    'com.UCMobile.intl',
    'com.UCMobile',
    'com.kiwibrowser.browser',
    'com.vivaldi.browser',
  ];

  static const _health = [
    'com.samsung.android.shealth',
    'com.fitbit.fitbitmobile',
    'com.garmin.android.apps.connectmobile',
    'com.strava',
    'com.nike.plusgps',
    'com.google.android.apps.fitness',
    'com.adidas.app',
    'com.calm.android',
    'com.headspace.android',
    'com.insight.insight_timer',
    'com.mycalmbeat',
    'com.woebot',
    'com.betterhelp',
  ];

  static const _finance = [
    'com.bca',
    'com.bni',
    'com.bri',
    'com.mandiri',
    'com.danamon',
    'id.co.gopay',
    'com.gojek.app',
    'com.grab',
    'id.ovo',
    'id.dana',
    'com.shopeepay',
    'com.tokopedia.tkpd',
    'com.bukalapak.android',
    'com.shopee.id',
    'com.lazada.android',
    'com.paypal.android.p2pmobile',
    'com.binance.dev',
    'com.coinbase.android',
  ];

  static const _news = [
    'com.detik.news',
    'com.kompas.android',
    'com.cnnindonesia',
    'com.bbc.mobile.news.ww',
    'com.nytimes.android',
    'com.google.android.apps.magazines', // Google News
    'com.flipboard.app',
    'com.inoreader',
    'com.newsbreak.android',
    'com.medium.reader',
    'app.substack',
  ];

  /// Klasifikasikan packageName ke AppCategory.
  static AppCategory classify(String packageName) {
    final pkg = packageName.toLowerCase().trim();

    if (_matchesAny(pkg, _social)) return AppCategory.social;
    if (_matchesAny(pkg, _communication)) return AppCategory.communication;
    if (_matchesAny(pkg, _productivity)) return AppCategory.productivity;
    if (_matchesAny(pkg, _entertainment)) return AppCategory.entertainment;
    if (_matchesAny(pkg, _browsing)) return AppCategory.browsing;
    if (_matchesAny(pkg, _health)) return AppCategory.health;
    if (_matchesAny(pkg, _finance)) return AppCategory.finance;
    if (_matchesAny(pkg, _news)) return AppCategory.news;

    // Heuristic: game apps
    if (_looksLikeGame(pkg)) return AppCategory.entertainment;

    return AppCategory.unknown;
  }

  /// Klasifikasikan map {packageName: durationSeconds} → {AppCategory: totalSeconds}
  static Map<AppCategory, int> classifyUsageMap(Map<String, int> usage) {
    final result = <AppCategory, int>{};
    for (final entry in usage.entries) {
      final category = classify(entry.key);
      result[category] = (result[category] ?? 0) + entry.value;
    }
    return result;
  }

  /// Cari kategori dominan dari usage map
  static AppCategory dominantCategory(Map<AppCategory, int> categoryUsage) {
    if (categoryUsage.isEmpty) return AppCategory.unknown;
    return categoryUsage.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  static bool _matchesAny(String pkg, List<String> list) {
    return list.any((pattern) => pkg == pattern || pkg.startsWith('$pattern.'));
  }

  /// Heuristic: game biasanya ada "game", "play", "rpg", atau pola tertentu
  static bool _looksLikeGame(String pkg) {
    const gameKeywords = ['game', '.games.', 'supercell', 'king.com', 'rovio', 'zynga', 'gameloft', 'com.ea.', 'com.square', 'com.ubisoft'];
    return gameKeywords.any((kw) => pkg.contains(kw));
  }
}
