library;

/// InsightId — Identitas konseptual setiap insight Luma.
///
/// Ini yang ditrack cooldown-nya — BUKAN teks.
/// Teks bisa bervariasi, konsep yang sama tidak boleh berulang terlalu cepat.
///
/// Dibagi 3 lapisan:
/// - Surface (0–6 hari data): observasi hari ini
/// - Pattern (7–29 hari): pola mingguan yang terbentuk
/// - Relationship (30+ hari): hubungan antar pola jangka panjang

enum InsightId {
  // ── SURFACE LAYER ── (tersedia dari hari pertama)
  lateNightActivity,       // Malam lebih panjang dari biasanya
  morningStart,            // Hari dimulai lebih awal
  screenQuiet,             // Layar lebih sedikit dari biasanya
  screenPresent,           // Layar lebih banyak dari biasanya
  deepFocusSession,        // Satu sesi panjang tanpa berpindah
  scatteredAttention,      // Banyak berpindah-pindah
  socialSpace,             // Ruang sosial digital dominan
  communicationDay,        // Banyak menjaga koneksi
  curiosityDriven,         // Browsing / rasa ingin tahu dominan
  productivityFocus,       // Produktivitas dominan
  entertainmentMode,       // Hiburan / penerimaan dominan
  eveningFlow,             // Energi mengalir ke malam
  waitingBehavior,         // Layar sering dibuka — menunggu sesuatu
  recoveringDay,           // Layar sangat sedikit + jarang buka

  // ── PATTERN LAYER ── (muncul setelah 7+ hari data)
  patternMorningConsistent,  // Pagi konsisten dalam seminggu
  patternFocusShift,         // Fokus bergeser dari biasanya
  patternNightDrift,         // Pola malam berubah dibanding minggu lalu
  patternWeekendEffect,      // Sabtu/Minggu berbeda signifikan
  patternAppShiftCategory,   // Kategori dominan bergeser minggu ini

  // ── RELATIONSHIP LAYER ── (muncul setelah 30+ hari data)
  relationshipMorningNight,  // Pagi tenang → malam lebih pendek
  relationshipFocusCycle,    // Fokus tinggi → pemulihan beberapa hari
  relationshipSocialBurnout, // Intensitas sosial → hari quieter setelahnya
  relationshipWeekRhythm,    // Ritme minggu mulai terbaca
}

/// Cooldown minimum per insight type.
/// Engine tidak akan menampilkan insight yang sama sebelum cooldown habis.
const Map<InsightId, Duration> insightCooldowns = {
  // Surface — cooldown 7–14 hari
  InsightId.lateNightActivity:     Duration(days: 12),
  InsightId.morningStart:          Duration(days: 14),
  InsightId.screenQuiet:           Duration(days: 10),
  InsightId.screenPresent:         Duration(days: 8),
  InsightId.deepFocusSession:      Duration(days: 9),
  InsightId.scatteredAttention:    Duration(days: 10),
  InsightId.socialSpace:           Duration(days: 7),
  InsightId.communicationDay:      Duration(days: 7),
  InsightId.curiosityDriven:       Duration(days: 8),
  InsightId.productivityFocus:     Duration(days: 6),
  InsightId.entertainmentMode:     Duration(days: 8),
  InsightId.eveningFlow:           Duration(days: 7),
  InsightId.waitingBehavior:       Duration(days: 12),
  InsightId.recoveringDay:         Duration(days: 10),

  // Pattern — cooldown lebih panjang
  InsightId.patternMorningConsistent: Duration(days: 14),
  InsightId.patternFocusShift:        Duration(days: 14),
  InsightId.patternNightDrift:        Duration(days: 14),
  InsightId.patternWeekendEffect:     Duration(days: 21),
  InsightId.patternAppShiftCategory:  Duration(days: 14),

  // Relationship — jarang, berharga
  InsightId.relationshipMorningNight:  Duration(days: 21),
  InsightId.relationshipFocusCycle:    Duration(days: 21),
  InsightId.relationshipSocialBurnout: Duration(days: 21),
  InsightId.relationshipWeekRhythm:    Duration(days: 28),
};

/// Berapa minimum hari data sebelum setiap insight boleh muncul
const Map<InsightId, int> insightDataThreshold = {
  // Surface: dari hari pertama
  InsightId.lateNightActivity:  0,
  InsightId.morningStart:       0,
  InsightId.screenQuiet:        0,
  InsightId.screenPresent:      0,
  InsightId.deepFocusSession:   0,
  InsightId.scatteredAttention: 0,
  InsightId.socialSpace:        0,
  InsightId.communicationDay:   0,
  InsightId.curiosityDriven:    0,
  InsightId.productivityFocus:  0,
  InsightId.entertainmentMode:  0,
  InsightId.eveningFlow:        0,
  InsightId.waitingBehavior:    0,
  InsightId.recoveringDay:      0,

  // Pattern: butuh minimal 7 hari
  InsightId.patternMorningConsistent: 7,
  InsightId.patternFocusShift:        7,
  InsightId.patternNightDrift:        7,
  InsightId.patternWeekendEffect:     7,
  InsightId.patternAppShiftCategory:  7,

  // Relationship: butuh minimal 30 hari
  InsightId.relationshipMorningNight:  30,
  InsightId.relationshipFocusCycle:    30,
  InsightId.relationshipSocialBurnout: 30,
  InsightId.relationshipWeekRhythm:    30,
};

/// Dimensi perhatian Luma — dirotasi tiap minggu
enum InsightDimension {
  morningRhythm,    // Fokus ke ritme pagi
  distractionFlow,  // Fokus ke switching & distraksi
  restPattern,      // Fokus ke pola malam & istirahat
  energyRecovery,   // Fokus ke pemulihan & hari tenang
}

/// Insight mana yang relevan per dimensi
const Map<InsightDimension, List<InsightId>> dimensionInsights = {
  InsightDimension.morningRhythm: [
    InsightId.morningStart,
    InsightId.productivityFocus,
    InsightId.deepFocusSession,
    InsightId.patternMorningConsistent,
    InsightId.relationshipMorningNight,
  ],
  InsightDimension.distractionFlow: [
    InsightId.scatteredAttention,
    InsightId.waitingBehavior,
    InsightId.socialSpace,
    InsightId.patternFocusShift,
    InsightId.patternAppShiftCategory,
  ],
  InsightDimension.restPattern: [
    InsightId.lateNightActivity,
    InsightId.eveningFlow,
    InsightId.screenPresent,
    InsightId.patternNightDrift,
    InsightId.patternWeekendEffect,
    InsightId.relationshipMorningNight,
  ],
  InsightDimension.energyRecovery: [
    InsightId.screenQuiet,
    InsightId.recoveringDay,
    InsightId.entertainmentMode,
    InsightId.communicationDay,
    InsightId.curiosityDriven,
    InsightId.relationshipFocusCycle,
    InsightId.relationshipSocialBurnout,
  ],
};
