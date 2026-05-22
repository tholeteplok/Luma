/* app.js - Luma Interactive Experience Logic with Deep Code Integration */

// Global State
let currentLang = 'id'; // default language
let currentTab = 'timeline';
let daysOld = 0;
let isGoogleSignedIn = false;
let isFirstInsightMode = false; // toggle for first insight stricter validation (max 1 sentence)

// Bilingual Dictionaries
const dict = {
  id: {
    // Header
    navFeatures: "Fitur",
    navPhilosophy: "Filosofi",
    navArchitecture: "Arsitektur",
    navDeveloper: "Developer",
    navCTA: "Kode Sumber",
    
    // Hero
    heroTag: "Personal Digital Behavior Intelligence",
    heroTitle: "Mengenal dirimu melalui pola digitalmu.",
    heroDesc: "Luma mengamati pola perilaku digitalmu secara pasif, memberikan insight tentang fokus, distraksi, dan keseimbangan hidup digital — tanpa penghakiman, tanpa friksi.",
    heroCtaPrimary: "Unduh Aplikasi",
    heroCtaSecondary: "Pelajari Filosofi",
    
    // Interactive Section
    interTitle: "Rasakan Pengalaman Luma",
    interDesc: "Lihat langsung bagaimana filosofi ketenangan dan privasi mutlak diimplementasikan secara interaktif melalui simulasi antarmuka aplikasi di bawah ini.",
    tabTimelineTitle: "Visualisasi Timeline Fading",
    tabTimelineDesc: "Data memudar seiring waktu seperti ingatan alami.",
    tabOnboardTitle: "Zero Friction & Zero Knowledge",
    tabOnboardDesc: "Masuk dengan Google, enkripsi instan.",
    tabNvcTitle: "Insight Berbasis NVC",
    tabNvcDesc: "Insight yang observasional, bukan menghakimi.",
    tabBackupTitle: "Pilihan Emosional Backup",
    tabBackupDesc: "Menjaga detail tetap hidup atau membiarkannya memudar.",
    
    // Timeline Simulator
    tlTitle: "FADE GRANULARITY SIMULATOR",
    tlLabel: "Usia Data:",
    tlHintTitle: "MINGGU INI",
    tlLabelToday: "Hari ini",
    tlLabelYesterday: "Kemarin",
    tlLabelFaded: "Bulan lalu",
    tlInsightTitle: "INSIGHT HARI INI",
    tlBtnLabel: "PILIH USIA DATA",
    
    // Onboarding Simulator
    obTitle: "Selamat Datang di Luma",
    obDesc: "Mulai perjalanan pengenalan diri digital Anda tanpa konfigurasi rumit. Hubungkan akun Google untuk memulai penyimpanan aman terenkripsi.",
    obShield: "Zero-Knowledge: Hanya Anda yang memegang kunci.",
    obGoogleBtn: "Masuk dengan Google",
    obSuccess: "Google Terkoneksi. Kunci AES-256-GCM Lokal Berhasil Disegel!",
    
    // NVC Simulator
    nvcHeader: "LIVE NVC VALIDATOR PLAYGROUND",
    nvcPlaceholder: "Ketik teks insight digital di sini atau pilih skenario di bawah...",
    nvcLabelPreset: "Pilih Skenario Kasar:",
    nvcRulesTitle: "ATURAN GUARDRAIL NVC LUMA",
    nvcRuleWords: "Tanpa kata menghakimi",
    nvcRuleNumbers: "Tanpa angka absolut",
    nvcRuleImperative: "Tanpa kalimat perintah",
    nvcRuleLength: "Batas 2 kalimat saja",
    nvcRuleOpener: "Mulai dengan observasi",
    nvcBtnValidate: "Validasi & Render",
    nvcBtnSanitize: "Bersihkan Kata Terlarang",
    nvcBtnReset: "Reset Input",
    nvcSuccessTitle: "✓ LOLOS GUARDRAIL LUMA",
    nvcFailTitle: "🚫 DITOLAK ENGINE TONE",
    nvcWarnTitle: "⚠️ LOLOS DENGAN CATATAN",
    nvcFirstInsightLabel: "Mode Hari Pertama (Maks 1 Kalimat)",
    
    // Backup Simulator
    backupQuote: "\"Jika ingin menjaga detail lebih lama, simpan salinan ke Google Drive. Jika tidak, Luma akan merangkumnya seperti ingatan biasa.\"",
    backupBtn: "Cadangkan Sekarang",
    backupLast: "Cadangan terakhir: Belum pernah",
    backupSize: "Ukuran: 0 KB",
    backupBtnActive: "Sedang Mencadangkan...",
    backupSuccess: "Cadangan berhasil dibuat!",
    backupListTitle: "CADANGAN TERSEDIA",
    backupItem1: "Hari ini",
    backupItem2: "1 minggu yang lalu",
    
    // Philosophy Section
    philoTitle: "Sebuah Filosofi Desain Baru",
    philoCard1Num: "01",
    philoCard1Title: "Memory-Inspired Design",
    philoCard1Desc: "Kami percaya data tidak harus dihapus paksa. Melalui Fade Granularity, data lama memudar menjadi siluet abstrak, meniru sifat alami ingatan manusia yang menyaring detail agar pola hidup tetap menetap.",
    philoCard2Num: "02",
    philoCard2Title: "Non-Violent Communication",
    philoCard2Desc: "Insight Luma dirancang menggunakan kaidah NVC. Kami tidak akan pernah mengatakan 'Kamu kecanduan HP'. Luma mengamati: 'Malam ini layar tetap menyala lebih lama. Istirahatlah sejenak, tidak apa-apa.'",
    
    // Architecture Section
    archTitle: "Arsitektur Zero-Knowledge",
    archDesc: "Luma adalah aplikasi offline-first tanpa server terpusat. Keamanan Anda terjamin secara matematis di perangkat Anda sendiri.",
    archThreatTitle: "Tabel Threat Model",
    archThreatCol1: "Ancaman",
    archThreatCol2: "Status Luma",
    archThreatCol3: "Mekanisme Proteksi",
    archThreatT1: "Server Luma membaca data",
    archThreatS1: "Aman",
    archThreatM1: "Server tidak ada (Pure Offline)",
    archThreatT2: "Pencurian Akun Google",
    archThreatS2: "Aman",
    archThreatM2: "Butuh otentikasi Google Device",
    archThreatT3: "Forensik Perangkat Fisik",
    archThreatS3: "Aman",
    archThreatM3: "Enkripsi AES-256-GCM Lokal",
    archCodeTitle: "nvc_validator.dart",
    
    // Developer Section
    devTitle: "Mulai Membangun Bersama Luma",
    devStep1Title: "Persiapan Lingkungan",
    devStep1Desc: "Instal Flutter SDK 3.x dan inisialisasi dependensi lokal proyek.",
    devStep2Title: "Generate Model Database",
    devStep2Desc: "Gunakan Isar build runner untuk memetakan skema penyimpanan terenkripsi.",
    devStep3Title: "Jalankan Proyek",
    devStep3Desc: "Jalankan emulator Android/iOS dan rasakan antarmuka yang menenangkan."
  },
  en: {
    // Header
    navFeatures: "Features",
    navPhilosophy: "Philosophy",
    navArchitecture: "Architecture",
    navDeveloper: "Developer",
    navCTA: "Source Code",
    
    // Hero
    heroTag: "Personal Digital Behavior Intelligence",
    heroTitle: "Observe your digital behavior patterns passively.",
    heroDesc: "Luma passively monitors your digital screen patterns, offering insights about focus, distraction, and life balance — without judgment, without friction.",
    heroCtaPrimary: "Download App",
    heroCtaSecondary: "Explore Philosophy",
    
    // Interactive Section
    interTitle: "Experience Luma Interactiveness",
    interDesc: "See firsthand how the philosophy of absolute privacy and digital calm is implemented interactively through our device simulation below.",
    tabTimelineTitle: "Fading Timeline Visualization",
    tabTimelineDesc: "Data decays progressively over time like human memory.",
    tabOnboardTitle: "Zero Friction & Zero Knowledge",
    tabOnboardDesc: "Google Sign-In, instant AES encryption.",
    tabNvcTitle: "NVC-Aligned Smart Insights",
    tabNvcDesc: "Observational, non-judgmental feedback.",
    tabBackupTitle: "Backup as an Emotional Choice",
    tabBackupDesc: "Save rich details or let them fade away naturally.",
    
    // Timeline Simulator
    tlTitle: "FADE GRANULARITY SIMULATOR",
    tlLabel: "Data Age:",
    tlHintTitle: "THIS WEEK",
    tlLabelToday: "Today",
    tlLabelYesterday: "Yesterday",
    tlLabelFaded: "Last month",
    tlInsightTitle: "INSIGHT TODAY",
    tlBtnLabel: "SELECT DATA AGE",
    
    // Onboarding Simulator
    obTitle: "Welcome to Luma",
    obDesc: "Begin your self-knowledge journey without tedious configurations. Connect your Google account to initialize private end-to-end encrypted storage.",
    obShield: "Zero-Knowledge: Only you hold the encryption key.",
    obGoogleBtn: "Sign In with Google",
    obSuccess: "Google Connected. Local AES-256-GCM Key Successfully Sealed!",
    
    // NVC Simulator
    nvcHeader: "LIVE NVC VALIDATOR PLAYGROUND",
    nvcPlaceholder: "Type your digital insight text here or select a raw scenario below...",
    nvcLabelPreset: "Select Raw Scenario:",
    nvcRulesTitle: "LUMA NVC GUARDRAIL RULES",
    nvcRuleWords: "No judgmental words",
    nvcRuleNumbers: "No absolute numbers",
    nvcRuleImperative: "No imperative sentences",
    nvcRuleLength: "Max 2 sentences limit",
    nvcRuleOpener: "Start with observation",
    nvcBtnValidate: "Validate & Render",
    nvcBtnSanitize: "Sanitize Forbidden Words",
    nvcBtnReset: "Reset Input",
    nvcSuccessTitle: "✓ PASSED LUMA GUARDRAIL",
    nvcFailTitle: "🚫 REJECTED BY TONE ENGINE",
    nvcWarnTitle: "⚠️ PASSED WITH WARNINGS",
    nvcFirstInsightLabel: "Day 1-3 Mode (Max 1 Sentence)",
    
    // Backup Simulator
    backupQuote: "\"If you want to keep details longer, save a copy to Google Drive. If not, Luma will summarize them like ordinary memory.\"",
    backupBtn: "Backup Now",
    backupLast: "Last backup: Never",
    backupSize: "Size: 0 KB",
    backupBtnActive: "Backing up...",
    backupSuccess: "Backup successfully created!",
    backupListTitle: "AVAILABLE BACKUPS",
    backupItem1: "Today",
    backupItem2: "1 week ago",
    
    // Philosophy Section
    philoTitle: "A Brand New Design Philosophy",
    philoCard1Num: "01",
    philoCard1Title: "Memory-Inspired Design",
    philoCard1Desc: "We believe data shouldn't be violently purged or hoarded forever. Through Fade Granularity, old events blur into abstract silhouettes, mimicking human memory to keep core patterns alive while details melt.",
    philoCard2Num: "02",
    philoCard2Title: "Non-Violent Communication",
    philoCard2Desc: "Luma insights are built on NVC principles. We never finger-point or tell you 'You are addicted'. Instead, Luma observes: 'The last 3 nights, your screen stayed on longer. It's okay to rest - your rhythm is shifting.'",
    
    // Architecture Section
    archTitle: "Zero-Knowledge Architecture",
    archDesc: "Luma is a pure offline-first app without central databases. Your security is mathematically verified right on your private device.",
    archThreatTitle: "Threat Model Analysis",
    archThreatCol1: "Threat Vector",
    archThreatCol2: "Luma Status",
    archThreatCol3: "Security Defense",
    archThreatT1: "Luma server reads user data",
    archThreatS1: "Secure",
    archThreatM1: "No Luma server exists (Pure Offline)",
    archThreatT2: "Google Account compromised",
    archThreatS2: "Secure",
    archThreatM2: "Requires local Google Device Auth",
    archThreatT3: "Physical device seizure",
    archThreatS3: "Secure",
    archThreatM3: "AES-256-GCM Local Database Encryption",
    archCodeTitle: "nvc_validator.dart",
    
    // Developer Section
    devTitle: "Build with Luma",
    devStep1Title: "Environment Setup",
    devStep1Desc: "Install Flutter SDK 3.x and fetch package dependencies.",
    devStep2Title: "Database Generation",
    devStep2Desc: "Compile Isar collections using code generators to map encrypted models.",
    devStep3Title: "Boot Up Project",
    devStep3Desc: "Run Android/iOS local build targets and feel the peaceful ambient design."
  }
};

// Raw Scenarios mapped to presets
const rawScenarios = {
  id: [
    {
      title: "Begadang & Main HP",
      text: "Kamu begadang lagi main HP. Ini buruk bagi kesehatanmu, kamu harus segera tidur agar besok tidak lelah."
    },
    {
      title: "Kerja Berlebihan",
      text: "Kamu bekerja terlalu keras hari ini dan memaksakan diri di depan komputer selama 6 jam tanpa jeda. Jangan diulangi lagi!"
    },
    {
      title: "Distraksi Sosmed",
      text: "Kamu kecanduan membuka HP minggu ini, selalu kurang istirahat, dan membuang waktu secara sia-sia."
    }
  ],
  en: [
    {
      title: "Late Night Phone",
      text: "You are staying up late on your phone again. This is bad for you, you must go to bed now to avoid being lazy."
    },
    {
      title: "Overworking",
      text: "You are pushing yourself too hard today and staring at the screen for 4 hours non-stop. Stop working immediately!"
    },
    {
      title: "Social Addiction",
      text: "You are screen addicted this week, sleeping horribly and wasting a massive amount of time constantly."
    }
  ]
};

// --- LIVE NVC VALIDATOR ENGINE (Ported from nvc_validator.dart) ---
class LumaNVCValidator {
  static forbiddenId = [
    'harus', 'seharusnya', 'wajib', 'jangan', 'perlu', 'cobalah', 'coba untuk',
    'sebaiknya', 'lebih baik', 'disarankan',
    'buruk', 'gagal', 'salah', 'malas', 'bodoh', 'payah', 'lemah',
    'tidak produktif', 'kecanduan', 'buang waktu', 'sia-sia',
    'tidak disiplin', 'tidak bisa', 'tidak mampu', 'malu', 'memalukan',
    'bagus sekali', 'hebat', 'luar biasa', 'sempurna',
    'selalu', 'tidak pernah', 'terus-menerus'
  ];

  static forbiddenEn = [
    'should', 'must', 'have to', 'need to', 'try to', 'you need',
    'you should', 'better', 'recommended',
    'bad', 'failed', 'failure', 'lazy', 'stupid', 'weak', 'shameful',
    'unproductive', 'addicted', 'wasting time', 'pointless',
    'undisciplined', 'cannot', 'unable',
    'amazing', 'perfect', 'excellent',
    'always', 'never', 'constantly',
    'you always', 'you never'
  ];

  // Regex patterns from nvc_validator.dart
  static absoluteNumberPattern = /\b\d+\s*(jam|menit|detik|kali|hari|hour|minute|second|time|day)s?\b/i;

  static imperativePatternId = /^(lakukan|mulai|hentikan|kurangi|tambah|perbaiki|ubah|coba|pastikan)/i;
  static imperativePatternEn = /^(do|start|stop|reduce|increase|fix|change|try|make sure|ensure)/i;

  // Observational openers
  static openersId = [
    'hari ini', 'ada', 'terlihat', 'pola', 'ritme', 'layar',
    'pikiran', 'malam', 'pagi', 'aktivitas', 'waktu'
  ];

  static openersEn = [
    'today', 'there', 'the screen', 'the mind', 'tonight',
    'this morning', 'activity', 'time', 'a pattern', 'the rhythm'
  ];

  static splitSentences(text) {
    if (!text.trim()) return [];
    // Split on . ! ? followed by whitespace (same as RegExp r'(?<=[.!?])\s+' in Dart)
    return text.trim().split(/(?<=[.!?])\s+/).filter(s => s.trim().length > 0);
  }

  static hasObservationalOpener(text, lang) {
    const openers = lang === 'id' ? this.openersId : this.openersEn;
    const lower = text.toLowerCase().trim();
    return openers.some(o => lower.startsWith(o));
  }

  static validate(text, lang, isFirstInsight = false) {
    const issues = [];
    const lowerText = text.toLowerCase().trim();

    if (!lowerText) {
      return {
        isValid: false,
        issues: [],
        hasObservationalOpener: false,
        sentenceCount: 0
      };
    }

    // ── Rule 1: Forbidden words ──────────────────────────────────────────────
    const forbidden = lang === 'id' ? this.forbiddenId : this.forbiddenEn;
    const foundWords = [];
    forbidden.forEach(word => {
      // Check full word match or containment depending on exact Dart contains
      if (lowerText.includes(word.toLowerCase())) {
        foundWords.push(word);
      }
    });
    if (foundWords.length > 0) {
      issues.push({
        rule: 'forbiddenWord',
        detail: foundWords.join(', '),
        severity: 'blocking'
      });
    }

    // ── Rule 2: No absolute numbers ─────────────────────────────────────────
    if (this.absoluteNumberPattern.test(lowerText)) {
      issues.push({
        rule: 'absoluteNumber',
        detail: lang === 'id' ? 'Angka absolut ditemukan' : 'Absolute numbers detected',
        severity: 'blocking'
      });
    }

    // ── Rule 3: No imperative sentences ─────────────────────────────────────
    const imperativePattern = lang === 'id' ? this.imperativePatternId : this.imperativePatternEn;
    const sentences = this.splitSentences(text);
    for (const sentence of sentences) {
      if (imperativePattern.test(sentence.trim())) {
        issues.push({
          rule: 'imperativeSentence',
          detail: sentence.trim(),
          severity: 'blocking'
        });
        break;
      }
    }

    // ── Rule 4: Max sentence count ───────────────────────────────────────────
    const maxSentences = isFirstInsight ? 1 : 2;
    if (sentences.length > maxSentences) {
      issues.push({
        rule: 'tooLong',
        detail: lang === 'id' 
          ? `${sentences.length} kalimat (maks ${maxSentences})` 
          : `${sentences.length} sentences (max ${maxSentences})`,
        severity: 'blocking'
      });
    }

    // ── Warning: No observational opener ──────────────────────────────────────
    const hasOpener = this.hasObservationalOpener(text, lang);
    if (!hasOpener && text.trim().length > 0) {
      issues.push({
        rule: 'missingObservationalOpener',
        detail: lang === 'id'
          ? 'Tidak dimulai dengan frasa observasional'
          : 'Does not start with an observational phrase',
        severity: 'warning'
      });
    }

    const blockingIssues = issues.filter(i => i.severity === 'blocking');

    return {
      isValid: blockingIssues.length === 0,
      issues: issues,
      hasObservationalOpener: hasOpener,
      sentenceCount: sentences.length
    };
  }

  static sanitize(text, lang) {
    const forbidden = lang === 'id' ? this.forbiddenId : this.forbiddenEn;
    let result = text;
    forbidden.forEach(word => {
      // Escape special characters in regex
      const escaped = word.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
      // Case insensitive globally
      const pattern = new RegExp(escaped, 'gi');
      result = result.replace(
        pattern,
        lang === 'id' ? 'terlihat' : 'appears to'
      );
    });
    return result;
  }

  static getFallback(lang) {
    return lang === 'id'
      ? 'Hari ini terlihat ada perubahan ritme aktivitas digital Anda. Tidak apa-apa untuk beristirahat sejenak.'
      : 'Today there appears to be a shift in your digital activity rhythm. It is okay to take a short rest.';
  }
}

// Fade Granularity levels for simulator (fade_granularity.dart)
function getFadeParams(days) {
  if (days <= 7) {
    return { opacity: 1.0, blur: 0, state: 'Sharp (0-7 hari)' };
  } else if (days <= 14) {
    return { opacity: 0.85, blur: 0, state: 'Dim (8-14 hari)' };
  } else if (days <= 28) {
    return { opacity: 0.65, blur: 1.5, state: 'Blurry (15-28 hari)' };
  } else {
    return { opacity: 0.45, blur: 2.5, state: 'Silhouette (28+ hari)' };
  }
}

function getTimelineLabel(days, lang) {
  const isId = lang === 'id';
  if (days <= 7) return isId ? 'Hari ini' : 'Today';
  if (days <= 14) return isId ? 'Minggu lalu' : 'Last week';
  if (days <= 28) return isId ? 'Pertengahan bulan' : 'Mid month';
  return isId ? 'Bulan lalu' : 'Last month';
}

function getHintText(days, lang) {
  const isId = lang === 'id';
  if (days <= 28) {
    return isId 
      ? 'Data ini akan dirangkum dalam beberapa hari. Pola tetap tersimpan.' 
      : 'This data will be summarized in a few days. Patterns remain.';
  } else {
    return isId
      ? 'Siluet ingatan. Detail kasar terhapus, namun garis besar kebiasaan Anda tetap abadi.'
      : 'Memory silhouette. Coarse details are gone, but your behavior outline remains eternal.';
  }
}

// Timeline daily dummy focus values
const timelineData = [
  { day: 'Sen', focus: 0.65 },
  { day: 'Sel', focus: 0.85 },
  { day: 'Rab', focus: 0.40 },
  { day: 'Kam', focus: 0.75 },
  { day: 'Jum', focus: 0.50 },
  { day: 'Sab', focus: 0.30 },
  { day: 'Min', focus: 0.90 }
];

// 3 Source code contents to load in Tabbed IDE Viewer
const sourceCodes = {
  nvc: `library;

import 'package:luma/core/utils/luma_language.dart';

class NVCValidator {
  static const _forbiddenId = <String>[
    'harus', 'seharusnya', 'wajib', 'jangan', 'perlu', 'cobalah',
    'sebaiknya', 'lebih baik', 'disarankan', 'buruk', 'gagal',
    'salah', 'malas', 'bodoh', 'tidak produktif', 'kecanduan'
  ];

  static final _absoluteNumberPattern = RegExp(
    r'\\b\\d+\\s*(jam|menit|detik|kali|hari|hour|minute|second)\\b',
    caseSensitive: false,
  );

  static NVCValidationResult validate(String text, LumaLanguage language) {
    final issues = <NVCIssue>[];
    final lowerText = text.toLowerCase().trim();

    // 1. Forbidden Words Check
    final forbidden = language == LumaLanguage.indonesian ? _forbiddenId : _forbiddenEn;
    for (final word in forbidden) {
      if (lowerText.contains(word)) {
        issues.add(NVCIssue(rule: NVCRule.forbiddenWord, detail: word));
      }
    }

    // 2. Absolute Numbers check
    if (_absoluteNumberPattern.hasMatch(lowerText)) {
      issues.add(const NVCIssue(rule: NVCRule.absoluteNumber));
    }
    
    // 3. Sentence Count check (max 2 sentences)
    final sentences = text.trim().split(RegExp(r'(?<=[.!?])\\s+'));
    if (sentences.length > 2) {
      issues.add(NVCIssue(rule: NVCRule.tooLong, detail: '\${sentences.length} sentences'));
    }

    return NVCValidationResult(isValid: issues.isEmpty, issues: issues);
  }
}`,
  encryption: `import 'dart:convert';
import 'package:cryptography/cryptography.dart';

/// EncryptionService - Zero-Knowledge Architecture
/// AES-256-GCM cryptography with random 96-bit IV
class EncryptionService {
  Uint8List? _encryptionKey;

  /// Encrypt plaintext to combined payload format
  /// Format output: base64(iv + ciphertext + authTag)
  Future<String> encrypt(String plaintext) async {
    final secretKey = SecretKey(_encryptionKey!);
    final algorithm = AesGcm.with256bits();
    
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
    );

    // Combine IV (nonce) + ciphertext + auth tag (mac)
    final combined = Uint8List.fromList([
      ...secretBox.nonce,       // 12 bytes
      ...secretBox.cipherText,  // encrypted payload
      ...secretBox.mac.bytes,   // 16 bytes auth tag
    ]);

    return base64Encode(combined);
  }

  /// Decrypt base64 combined payload back to plaintext
  Future<String> decrypt(String encryptedData) async {
    final combined = base64Decode(encryptedData);
    
    // Slice components
    final iv = combined.sublist(0, 12);
    final cipherText = combined.sublist(12, combined.length - 16);
    final macBytes = combined.sublist(combined.length - 16);

    final algorithm = AesGcm.with256bits();
    final plainText = await algorithm.decrypt(
      SecretBox(cipherText, nonce: iv, mac: Mac(macBytes)),
      secretKey: SecretKey(_encryptionKey!),
    );

    return utf8.decode(plainText);
  }
}`,
  backup: `import 'dart:convert';
import 'package:isar/isar.dart';

/// DriveBackupManager - Encrypted JSON backups to Google Drive
class DriveBackupManager {
  final DatabaseService _db = DatabaseService();
  final EncryptionService _encryption = EncryptionService();

  /// Collect and package secure JSON mapping
  Future<Map<String, dynamic>> _collectBackupData() async {
    final now = DateTime.now();
    final fourWeeksAgo = now.subtract(const Duration(days: 28));

    final insights = await _db.db.insights.where().findAll();
    final weeklyProfiles = await _db.db.weeklyProfiles
        .filter().weekStartGreaterThan(fourWeeksAgo).findAll();
    final baselines = await _db.db.baselines.where().findAll();
    final prefs = await _db.db.appPreferences.where().findAll();

    return {
      'version': 1,
      'exportedAt': now.toIso8601String(),
      'insights': insights.map(_insightToMap).toList(),
      'weeklyProfiles': weeklyProfiles.map(_weeklyProfileToMap).toList(),
      'baselines': baselines.map(_baselineToMap).toList(),
      'appPreferences': prefs.map(_prefsToMap).toList(),
    };
  }
}`
};

// Initialize and Listeners
document.addEventListener('DOMContentLoaded', () => {
  initBilingualTexts();
  initTimelineSimulator();
  initNvcSimulator();
  initIDEViewer();
  
  // Set initial phone notch dynamic time
  updatePhoneTime();
  setInterval(updatePhoneTime, 30000);
});

// Update dynamic time inside phone mockup notch
function updatePhoneTime() {
  const now = new Date();
  let hrs = now.getHours().toString().padStart(2, '0');
  let mins = now.getMinutes().toString().padStart(2, '0');
  const timeStr = `${hrs}:${mins}`;
  document.querySelectorAll('.phone-time').forEach(el => el.innerText = timeStr);
}

// Bilingual Switching Engine
window.setLanguage = function(lang) {
  currentLang = lang;
  
  // Update toggle buttons active class
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-lang') === lang);
  });
  
  // Update HTML lang attribute for accessibility/SEO
  document.documentElement.setAttribute('lang', lang);
  
  initBilingualTexts();
  updateTimelineSimulatorUI();
  updateNvcSimulatorUI();
  updateBackupSimulatorUI();
};

function initBilingualTexts() {
  const dictionary = dict[currentLang];
  
  // Traverse and replace text contents of data-bil elements
  document.querySelectorAll('[data-bil]').forEach(el => {
    const key = el.getAttribute('data-bil');
    if (dictionary[key]) {
      el.innerText = dictionary[key];
    }
  });

  // Handle placeholders
  document.querySelectorAll('[data-bil-placeholder]').forEach(el => {
    const key = el.getAttribute('data-bil-placeholder');
    if (dictionary[key]) {
      el.setAttribute('placeholder', dictionary[key]);
    }
  });
}

// Smartphone Tab Navigation
window.switchPhoneTab = function(tabName) {
  currentTab = tabName;
  
  // Update mockup active tabs
  document.querySelectorAll('.phone-tab-screen').forEach(screen => {
    screen.classList.remove('active');
  });
  const activeScreen = document.getElementById(`phone-screen-${tabName}`);
  if (activeScreen) {
    activeScreen.classList.add('active');
  }
  
  // Update sidebar menu highlight
  document.querySelectorAll('.tab-menu-item').forEach(item => {
    item.classList.toggle('active', item.getAttribute('data-tab') === tabName);
  });

  // Re-render sub components if needed to solve render issues
  if (tabName === 'timeline') {
    updateTimelineSimulatorUI();
  } else if (tabName === 'nvc') {
    runLiveNVCValidation();
  }
};

// --- TIMELINE SIMULATOR LOGIC ---
function initTimelineSimulator() {
  const slider = document.getElementById('fade-slider');
  if (slider) {
    slider.addEventListener('input', (e) => {
      daysOld = parseInt(e.target.value);
      updateTimelineSimulatorUI();
    });
  }
  updateTimelineSimulatorUI();
}

function updateTimelineSimulatorUI() {
  const sliderVal = document.getElementById('slider-val-display');
  if (sliderVal) {
    sliderVal.innerText = `${daysOld} ${currentLang === 'id' ? 'Hari' : 'Days'}`;
  }
  
  const params = getFadeParams(daysOld);
  
  // Apply fade styling directly to the mockup elements
  const timelineContent = document.getElementById('phone-timeline-content');
  if (timelineContent) {
    timelineContent.style.opacity = params.opacity;
    // Apply blur using standard CSS filters
    timelineContent.style.filter = params.blur > 0 ? `blur(${params.blur}px)` : 'none';
    
    // isItalic implementation from fade_granularity.dart (daysOld > 28 -> Italic silhouette)
    if (daysOld > 28) {
      timelineContent.classList.add('silhouette-italic');
    } else {
      timelineContent.classList.remove('silhouette-italic');
    }
  }
  
  // Update subtitle indicator inside phone mockup card
  const phoneLabel = document.getElementById('phone-timeline-state-label');
  if (phoneLabel) {
    phoneLabel.innerText = getTimelineLabel(daysOld, currentLang);
  }
  
  // Update lower descriptive hint
  const hintText = document.getElementById('phone-timeline-hint-desc');
  if (hintText) {
    hintText.innerText = getHintText(daysOld, currentLang);
  }
  
  // Update the daily timeline bars
  renderTimelineBars(params.opacity, params.blur);
}

function renderTimelineBars(opacity, blur) {
  const container = document.getElementById('phone-bars-container');
  if (!container) return;
  
  container.innerHTML = '';
  
  timelineData.forEach((item, index) => {
    const barHeight = Math.max(12, item.focus * 40); // min height 12px
    
    // Choose ambient color representing focus quality
    let color = 'var(--rest-color)';
    if (item.focus > 0.7) {
      color = 'var(--focus-color)';
    } else if (item.focus > 0.4) {
      color = 'var(--accent)';
    } else {
      color = 'var(--distract-color)';
    }
    
    // Create DOM structure
    const barWrapper = document.createElement('div');
    barWrapper.className = 'phone-timeline-bar-wrapper';
    
    const bar = document.createElement('div');
    bar.className = 'phone-timeline-bar';
    bar.style.height = `${barHeight}px`;
    bar.style.backgroundColor = color;
    // Keep individual bars matching global decay
    bar.style.opacity = opacity;
    if (blur > 0) {
      bar.style.filter = `blur(${blur * 0.7}px)`;
    }
    
    const dayLabel = document.createElement('span');
    dayLabel.className = 'phone-timeline-day';
    dayLabel.innerText = item.day;
    
    barWrapper.appendChild(bar);
    barWrapper.appendChild(dayLabel);
    
    if (index === timelineData.length - 1) {
      const todayDot = document.createElement('div');
      todayDot.className = 'phone-timeline-today-dot';
      barWrapper.appendChild(todayDot);
    }
    
    container.appendChild(barWrapper);
  });
}

// --- ONBOARDING GOOGLE SIMULATOR ---
window.triggerGoogleSignIn = function() {
  const btn = document.getElementById('phone-google-sign-btn');
  const successBox = document.getElementById('phone-signin-success-box');
  
  if (!btn || isGoogleSignedIn) return;
  
  btn.style.opacity = '0.6';
  btn.innerHTML = `<span style="border: 2px solid var(--text-tertiary); border-top-color: var(--text-primary); border-radius: 50%; width: 14px; height: 14px; display: inline-block; animation: spin 0.8s linear infinite; margin-right: 8px;"></span> ${currentLang === 'id' ? 'Menghubungkan...' : 'Connecting...'}`;
  
  setTimeout(() => {
    btn.style.display = 'none';
    if (successBox) {
      successBox.style.display = 'flex';
      const textNode = successBox.querySelector('span');
      if (textNode) {
        textNode.innerText = dict[currentLang].obSuccess;
      }
    }
    isGoogleSignedIn = true;
  }, 1800);
};

// --- LIVE NVC INSIGHT SIMULATOR PLAYGROUND ---
function initNvcSimulator() {
  const textarea = document.getElementById('nvc-input-text');
  const toggleFirst = document.getElementById('nvc-toggle-first');
  const selectPreset = document.getElementById('nvc-preset-select');
  
  if (textarea) {
    textarea.addEventListener('input', () => {
      runLiveNVCValidation();
    });
  }
  
  if (toggleFirst) {
    toggleFirst.addEventListener('change', (e) => {
      isFirstInsightMode = e.target.checked;
      runLiveNVCValidation();
    });
  }
  
  if (selectPreset) {
    selectPreset.addEventListener('change', (e) => {
      const val = parseInt(e.target.value);
      if (val >= 0) {
        loadPresetScenario(val);
      }
    });
  }

  // Load first scenario as default into input
  loadPresetScenario(0);
}

function loadPresetScenario(idx) {
  const textarea = document.getElementById('nvc-input-text');
  if (textarea) {
    const list = rawScenarios[currentLang];
    if (list && list[idx]) {
      textarea.value = list[idx].text;
      runLiveNVCValidation();
    }
  }
}

function updateNvcSimulatorUI() {
  // Re-synchronize dropdown items with bilingual texts
  const selectPreset = document.getElementById('nvc-preset-select');
  if (selectPreset) {
    const presets = rawScenarios[currentLang];
    const savedIdx = selectPreset.selectedIndex;
    
    // Clear and rebuild options
    selectPreset.innerHTML = `<option value="-1" data-bil="nvcPlaceholder">${dict[currentLang].nvcPlaceholder.substring(0, 30)}...</option>`;
    presets.forEach((p, idx) => {
      const opt = document.createElement('option');
      opt.value = idx;
      opt.innerText = p.title;
      selectPreset.appendChild(opt);
    });
    
    // Restore index selection
    if (savedIdx >= 0 && savedIdx < selectPreset.options.length) {
      selectPreset.selectedIndex = savedIdx;
    }
  }

  // Run validation
  runLiveNVCValidation();
}

function runLiveNVCValidation() {
  const textInput = document.getElementById('nvc-input-text');
  if (!textInput) return;
  
  const text = textInput.value;
  const result = LumaNVCValidator.validate(text, currentLang, isFirstInsightMode);
  
  // Update Checklist Items status (Centang jika memenuhi syarat)
  const isNoForbidden = !result.issues.some(i => i.rule === 'forbiddenWord');
  const isNoNumbers = !result.issues.some(i => i.rule === 'absoluteNumber');
  const isNoImperative = !result.issues.some(i => i.rule === 'imperativeSentence');
  const isWithinLength = !result.issues.some(i => i.rule === 'tooLong');
  const isObservationStart = result.hasObservationalOpener;
  
  updateChecklistBadge('rule-words', isNoForbidden);
  updateChecklistBadge('rule-numbers', isNoNumbers);
  updateChecklistBadge('rule-imperative', isNoImperative);
  updateChecklistBadge('rule-length', isWithinLength);
  updateChecklistBadge('rule-opener', isObservationStart, true); // warning level (does not block)
  
  // Render Status indicator
  const ledger = document.getElementById('nvc-sim-indicator');
  const statusTitle = document.getElementById('nvc-status-title');
  const statusDetails = document.getElementById('nvc-status-details');
  const validateBtn = document.getElementById('nvc-validate-btn');
  const sanitizeBtn = document.getElementById('nvc-sanitize-btn');
  
  if (!text.trim()) {
    if (ledger) ledger.style.background = 'var(--border-medium)';
    if (statusTitle) {
      statusTitle.innerText = currentLang === 'id' ? 'Menunggu input...' : 'Waiting for input...';
      statusTitle.className = 'nvc-title-state neutral';
    }
    if (statusDetails) statusDetails.innerHTML = '';
    if (validateBtn) validateBtn.disabled = true;
    if (sanitizeBtn) sanitizeBtn.disabled = true;
    return;
  }
  
  if (validateBtn) validateBtn.disabled = false;
  if (sanitizeBtn) sanitizeBtn.disabled = isNoForbidden; // Disable sanitize if there are no forbidden words

  if (!result.isValid) {
    if (ledger) ledger.style.background = 'var(--warn-text)';
    if (statusTitle) {
      statusTitle.innerText = dict[currentLang].nvcFailTitle;
      statusTitle.className = 'nvc-title-state fail';
    }
    
    // Build blocking issue bullet list
    if (statusDetails) {
      let html = '<ul class="nvc-issue-list">';
      result.issues.forEach(issue => {
        if (issue.severity === 'blocking') {
          let ruleLabel = '';
          if (issue.rule === 'forbiddenWord') ruleLabel = currentLang === 'id' ? `Kata terlarang: "${issue.detail}"` : `Forbidden word: "${issue.detail}"`;
          else if (issue.rule === 'absoluteNumber') ruleLabel = currentLang === 'id' ? 'Menyebutkan angka absolut' : 'Mentions absolute values';
          else if (issue.rule === 'imperativeSentence') ruleLabel = currentLang === 'id' ? `Kalimat perintah: "${issue.detail}"` : `Command tone: "${issue.detail}"`;
          else if (issue.rule === 'tooLong') ruleLabel = currentLang === 'id' ? `Terlalu panjang: ${issue.detail}` : `Too long: ${issue.detail}`;
          
          html += `<li>⚠️ ${ruleLabel}</li>`;
        }
      });
      html += '</ul>';
      statusDetails.innerHTML = html;
    }
  } else {
    // Valid NVC! Check if there's a warning (missing observational opener)
    if (!result.hasObservationalOpener) {
      if (ledger) ledger.style.background = 'var(--notice-text)';
      if (statusTitle) {
        statusTitle.innerText = dict[currentLang].nvcWarnTitle;
        statusTitle.className = 'nvc-title-state warn';
      }
      if (statusDetails) {
        statusDetails.innerHTML = `<div class="nvc-warn-box">💡 ${
          currentLang === 'id' 
            ? 'Insight akan lebih tenang jika dimulai dengan frasa observasi netral.' 
            : 'Insights sound calmer when starting with a neutral observational phrase.'
        }</div>`;
      }
    } else {
      if (ledger) ledger.style.background = 'var(--gentle-text)';
      if (statusTitle) {
        statusTitle.innerText = dict[currentLang].nvcSuccessTitle;
        statusTitle.className = 'nvc-title-state pass';
      }
      if (statusDetails) {
        statusDetails.innerHTML = `<div class="nvc-pass-box">✓ ${
          currentLang === 'id' 
            ? 'Format leksikal insight memenuhi standar etika komparatif Luma.' 
            : 'Insight lexical format perfectly matches Luma ethical criteria.'
        }</div>`;
      }
    }
  }
}

function updateChecklistBadge(id, isPassed, isWarningOnly = false) {
  const el = document.getElementById(id);
  if (!el) return;
  
  const indicator = el.querySelector('.rule-indicator');
  if (!indicator) return;
  
  if (isPassed) {
    indicator.innerText = '✓';
    indicator.className = 'rule-indicator pass';
    el.classList.add('passed');
  } else {
    if (isWarningOnly) {
      indicator.innerText = '⚠';
      indicator.className = 'rule-indicator warn';
      el.classList.remove('passed');
    } else {
      indicator.innerText = '✕';
      indicator.className = 'rule-indicator fail';
      el.classList.remove('passed');
    }
  }
}

window.sanitizeLiveInput = function() {
  const textarea = document.getElementById('nvc-input-text');
  if (textarea) {
    const cleaned = LumaNVCValidator.sanitize(textarea.value, currentLang);
    textarea.value = cleaned;
    
    // Trigger smooth border pulse to show action completed
    textarea.classList.add('pulse-glow');
    setTimeout(() => textarea.classList.remove('pulse-glow'), 800);
    
    runLiveNVCValidation();
  }
};

window.resetLiveInput = function() {
  const textarea = document.getElementById('nvc-input-text');
  if (textarea) {
    textarea.value = '';
    
    const dropdown = document.getElementById('nvc-preset-select');
    if (dropdown) dropdown.selectedIndex = 0;
    
    runLiveNVCValidation();
  }
};

window.animateNvcConversion = function() {
  const textInput = document.getElementById('nvc-input-text');
  if (!textInput || !textInput.value.trim()) return;
  
  const result = LumaNVCValidator.validate(textInput.value, currentLang, isFirstInsightMode);
  
  const validateBtn = document.getElementById('nvc-validate-btn');
  const screenArea = document.getElementById('phone-screen-nvc');
  
  if (validateBtn) validateBtn.disabled = true;
  
  // Save orisinal screen state
  const originalHtml = screenArea.innerHTML;
  
  // Show stunning fading conversion state
  screenArea.style.opacity = '0.3';
  screenArea.style.filter = 'blur(2px)';
  screenArea.style.transition = 'all 0.6s ease';
  
  setTimeout(() => {
    screenArea.style.opacity = '1.0';
    screenArea.style.filter = 'none';
    
    // Choose theme colors depending on validity
    let badgeClass = 'info';
    let badgeText = 'INFO';
    let lumaObservation = textInput.value;
    
    if (!result.isValid) {
      // If invalid NVC, force load a soothing fallback text to demonstrate protection!
      lumaObservation = LumaNVCValidator.getFallback(currentLang);
      badgeClass = 'warn';
      badgeText = currentLang === 'id' ? 'FALLBACK INSIGHT' : 'FALLBACK INSIGHT';
    } else {
      // Use parsed content
      const sentences = LumaNVCValidator.splitSentences(textInput.value);
      lumaObservation = sentences.join(' ');
      
      // Determine severity tag
      if (textInput.value.toLowerCase().includes('begadang') || textInput.value.toLowerCase().includes('late')) {
        badgeClass = 'notice';
        badgeText = currentLang === 'id' ? 'CATATAN' : 'NOTE';
      } else if (textInput.value.toLowerCase().includes('kerja') || textInput.value.toLowerCase().includes('work')) {
        badgeClass = 'gentle';
        badgeText = currentLang === 'id' ? 'RITME GENTLE' : 'GENTLE RHYTHM';
      } else {
        badgeClass = 'info';
        badgeText = 'INFO';
      }
    }
    
    // Replace mockup contents with compiled Insight card
    screenArea.innerHTML = `
      <div style="text-align: center; margin: 30px 0 10px;">
        <div style="font-size: 28px; margin-bottom: 8px;">🧘</div>
        <div class="nvc-sim-header" style="letter-spacing: 0.5px; text-transform: uppercase;">LUMA COMPASSIONATE FEED</div>
      </div>
      
      <div class="phone-card" style="margin-top: 10px; animation: phoneSignInAnim 0.6s ease forwards;">
        <div class="phone-card-indicator" style="background: var(--${badgeClass === 'gentle' ? 'gentle' : (badgeClass === 'notice' ? 'notice' : 'accent')});"></div>
        <div class="phone-card-inner">
          <span class="phone-badge" style="background: var(--${badgeClass}-ind); color: var(--${badgeClass}-text);">${badgeText}</span>
          <div class="phone-insight-text" style="font-size: 15px; line-height: 1.5; font-family: 'Cormorant Garamond', serif;">
            "${lumaObservation}"
          </div>
          <div class="phone-insight-date">✓ ${currentLang === 'id' ? 'TONE DISARING SECARA PASIF' : 'PASSIVELY FILTERED TONE'}</div>
        </div>
      </div>

      <p class="phone-backup-quote" style="font-size: 11px; margin-top: 10px; color: var(--text-tertiary);">
        ${currentLang === 'id' ? 'Luma mendeteksi pola digitalmu tanpa menghakimi perilakumu.' : 'Luma highlights digital patterns without judging your character.'}
      </p>
      
      <button class="phone-backup-main-btn" onclick="restoreLiveNvcScreen(\`${escapeHtml(originalHtml)}\`)" style="margin-top: auto; background: var(--bg-surface); border-color: var(--border-medium);">
        ${currentLang === 'id' ? 'Kembali ke Playground' : 'Back to Playground'}
      </button>
    `;
  }, 1000);
};

// Helper function to restore playground
window.restoreLiveNvcScreen = function(storedHtml) {
  const screenArea = document.getElementById('phone-screen-nvc');
  if (screenArea) {
    screenArea.innerHTML = storedHtml;
    // Re-initialize event listeners
    initNvcSimulator();
  }
};

function escapeHtml(string) {
  return String(string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

// --- BACKUP SIMULATOR LOGIC ---
window.triggerBackupSimulation = function() {
  const btn = document.getElementById('phone-backup-trigger-btn');
  const metadata = document.getElementById('phone-backup-metadata-box');
  const list = document.getElementById('phone-backup-list-box');
  
  if (!btn) return;
  
  btn.disabled = true;
  btn.innerText = dict[currentLang].backupBtnActive;
  btn.style.opacity = '0.7';
  
  // Progress simulation
  let progress = 0;
  const interval = setInterval(() => {
    progress += 10;
    btn.innerText = `${dict[currentLang].backupBtnActive} (${progress}%)`;
    if (progress >= 100) {
      clearInterval(interval);
      completeBackupSimulation();
    }
  }, 150);
};

function completeBackupSimulation() {
  const btn = document.getElementById('phone-backup-trigger-btn');
  const metadata = document.getElementById('phone-backup-metadata-box');
  const list = document.getElementById('phone-backup-list-box');
  
  if (btn) {
    btn.innerText = dict[currentLang].backupSuccess;
    btn.style.background = 'var(--gentle-ind)';
    btn.style.borderColor = 'var(--gentle-text)';
    btn.style.color = 'var(--gentle-text)';
  }
  
  const todayStr = currentLang === 'id' ? 'Hari ini' : 'Today';
  
  if (metadata) {
    metadata.innerHTML = `
      <span>${dict[currentLang].backupLast.replace('Belum pernah', todayStr).replace('Never', todayStr)}</span>
      <span>${dict[currentLang].backupSize.replace('0 KB', '1.2 MB')}</span>
    `;
  }
  
  if (list) {
    list.innerHTML = `
      <div class="phone-backup-list-title">${dict[currentLang].backupListTitle}</div>
      <div class="phone-backup-list-item">
        <span>• ${todayStr} (1.2 MB)</span>
        <span style="color: var(--accent-light); font-weight: 700; cursor: pointer;" onclick="triggerRestoreSimulation()">RESTORE</span>
      </div>
      <div class="phone-backup-list-item" style="opacity: 0.6;">
        <span>• 16 Mei 2026 (1.1 MB)</span>
        <span>RESTORE</span>
      </div>
    `;
  }
}

function updateBackupSimulatorUI() {
  const btn = document.getElementById('phone-backup-trigger-btn');
  const metadata = document.getElementById('phone-backup-metadata-box');
  
  if (btn && !btn.disabled) {
    btn.innerText = dict[currentLang].backupBtn;
  }
}

window.triggerRestoreSimulation = function() {
  const screenArea = document.getElementById('phone-screen-backup');
  if (!screenArea) return;
  
  const original = screenArea.innerHTML;
  
  screenArea.style.opacity = '0.3';
  screenArea.style.filter = 'blur(2px)';
  screenArea.style.transition = 'all 0.5s ease';
  
  setTimeout(() => {
    screenArea.style.opacity = '1.0';
    screenArea.style.filter = 'none';
    screenArea.innerHTML = `
      <div style="text-align: center; margin: 50px 0 10px; animation: phoneSignInAnim 0.6s ease forwards;">
        <div style="font-size: 32px; margin-bottom: 12px;">🗝️</div>
        <h3 class="phone-ob-title" style="font-size: 18px;">
          ${currentLang === 'id' ? 'Dekripsi & Sinkronisasi Isar' : 'Decryption & Isar Sync'}
        </h3>
        <p class="phone-backup-quote" style="font-size: 12px; margin-top: 10px;">
          ${
            currentLang === 'id'
              ? 'Mengekstrak 96-bit IV, mendekripsi database lokal Isar dengan kunci AES-256-GCM dari Google Drive.'
              : 'Extracting 96-bit IV, decrypting local Isar database using secure AES-256-GCM Google Drive key.'
          }
        </p>
        <div style="margin: 20px auto; border: 2px solid var(--gentle-text); border-top-color: transparent; border-radius: 50%; width: 24px; height: 24px; animation: spin 0.8s linear infinite;"></div>
      </div>
    `;
    
    setTimeout(() => {
      screenArea.innerHTML = `
        <div style="text-align: center; margin: 60px 0 10px; animation: phoneSignInAnim 0.6s ease forwards;">
          <div style="font-size: 36px; margin-bottom: 12px; color: var(--gentle-text);">✓</div>
          <h3 class="phone-ob-title" style="font-size: 16px; color: var(--gentle-text);">
            ${currentLang === 'id' ? 'Data Berhasil Dipulihkan!' : 'Database Restored!'}
          </h3>
          <p class="phone-backup-quote" style="font-size: 11px;">
            ${currentLang === 'id' ? 'Seluruh insight dan Weekly Profiles berhasil dimuat kembali.' : 'All local insights and Weekly Profiles successfully re-synced.'}
          </p>
          <button class="phone-backup-main-btn" onclick="restoreOriginalBackupScreen(\`${escapeHtml(original)}\`)" style="margin-top: 20px;">
            ${currentLang === 'id' ? 'Selesai' : 'Dismiss'}
          </button>
        </div>
      `;
    }, 1500);
    
  }, 600);
};

window.restoreOriginalBackupScreen = function(storedHtml) {
  const screenArea = document.getElementById('phone-screen-backup');
  if (screenArea) {
    screenArea.innerHTML = storedHtml;
  }
};


// --- TABBED IDE MOCKUP VIEW CONTROLLER ---
function initIDEViewer() {
  // Load default file (NVC)
  switchIDEFile('nvc');
}

window.switchIDEFile = function(fileName) {
  const snippetBox = document.getElementById('code-snippet-nvc');
  if (!snippetBox) return;
  
  // Remove active state from all tab buttons
  document.querySelectorAll('.code-tab-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  
  // Highlight targeted tab button
  const activeBtn = document.getElementById(`ide-tab-${fileName}`);
  if (activeBtn) activeBtn.classList.add('active');
  
  // Inject source code matching file
  const rawCode = sourceCodes[fileName];
  snippetBox.innerHTML = syntaxHighlight(rawCode);
};

// Extremely lightweight regex syntax highlighter for mockup IDE styling
function syntaxHighlight(code) {
  if (!code) return '';
  return code
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    // Key words
    .replace(/\b(class|static|const|final|var|return|if|for|in|instanceof|future|async|await|library|import|Uint8List|String|bool|int|double|void)\b/g, '<span class="c-keyword">$1</span>')
    // Built-in types
    .replace(/\b(NVCValidator|NVCValidationResult|NVCIssue|RegExp|LumaLanguage|EncryptionService|SecretKey|AesGcm|SecretBox|Mac|DriveBackupManager|DatabaseService|Baseline|AppPreferences|DateTime|Map)\b/g, '<span class="c-class">$1</span>')
    // Comments
    .replace(/(\/\/[^\n]*)/g, '<span class="c-comment">$1</span>')
    // Strings
    .replace(/'([^'\n]*)'/g, '<span class="c-string">\'$1\'</span>');
}

// Developer code copy implementation
window.copyToClipboard = function(elementId, btnEl) {
  const text = document.getElementById(elementId).innerText;
  navigator.clipboard.writeText(text).then(() => {
    const originalHtml = btnEl.innerHTML;
    btnEl.innerHTML = '<span style="color: var(--gentle-text); font-weight: 700;">✓ Copied</span>';
    setTimeout(() => {
      btnEl.innerHTML = originalHtml;
    }, 2000);
  });
};
