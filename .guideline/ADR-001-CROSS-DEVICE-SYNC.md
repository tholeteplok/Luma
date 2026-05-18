# ADR-001 — Cross-Device Sync & Encryption Key Strategy

**Status**: ACCEPTED  
**Tanggal**: 16 Mei 2026  
**Berlaku untuk**: Phase 0–3  
**Tidak boleh diubah tanpa**: Data migration plan + user notification  
**Keputusan dibuat setelah mempertimbangkan**: Opsi A, B, C1, C2

---

## Keputusan

**Gunakan Google Drive Key Wrapping (Varian C1).**

Encryption key adalah **random 32-byte key** yang di-generate saat
pertama kali user sign in. Key ini disimpan sebagai file tersembunyi
di Google Drive milik user sendiri. Server Luma tidak pernah menyentuh
key dalam bentuk apapun.

---

## Konteks & Alasan

### Tiga constraint yang harus dipenuhi bersamaan

```
1. Zero friction cross-device
   → Login Google = semua data kembali, tanpa langkah tambahan

2. Absolute ZK dari server
   → Server Luma tidak bisa membaca data user, bahkan jika
     database di-breach atau developer penasaran

3. Semua skenario cross-device
   → Ganti HP, HP hilang, dua HP bersamaan
```

### Mengapa bukan Opsi A (Google-Anchored Key)

Opsi A memenuhi semua constraint fungsional, tapi APP_SECRET
tertanam di APK. Siapapun yang decompile APK dapat nilai ini.
Kombinasi APP_SECRET + googleUserId + akses Supabase = data terbuka.
Untuk consumer privacy app ini acceptable secara industri, tapi
C1 memberikan jaminan yang lebih kuat tanpa menambah friction.

### Mengapa bukan Opsi B (Split Key + PIN)

PIN tambahan berarti user bisa lupa. Lupa PIN = kehilangan semua
riwayat. Ini bertentangan langsung dengan filosofi Luma yang tidak
boleh menambah beban ke user.

### Mengapa bukan C2 (Server-Side Escrow)

C2 pada dasarnya adalah Opsi A dengan satu layer indirection.
Wrapping key di C2 masih derived dari googleUserId + APP_SECRET,
sehingga tidak ada keunggulan keamanan nyata. Menambah kompleksitas
tanpa manfaat = utang teknis tanpa nilai.

### Mengapa C1

```
Key = random 32 bytes (bukan derived)
    → Tidak ada secret yang perlu disembunyikan di APK
    → Tidak bergantung pada APP_SECRET untuk keamanan

Key disimpan di Google Drive user (bukan server Luma)
    → Server Luma benar-benar tidak pernah menyentuh key
    → ZK terjaga secara teknis, bukan hanya klaim marketing

Cross-device bekerja via Google Drive
    → Login Google = akses ke Drive = ambil key = decrypt data
    → Zero friction, tidak ada langkah tambahan untuk user
```

---

## Arsitektur Teknis

### Struktur File di Google Drive

```
Google Drive user (hidden/appDataFolder scope)
└── luma/
    └── key.json
        {
          "version": "1",
          "key": "<base64-encoded 32 bytes>",
          "created_at": "2026-05-16T09:00:00Z",
          "device_hint": "Pixel 8 Pro"  ← opsional, untuk info saja
        }
```

Menggunakan `appDataFolder` scope — bukan folder Drive biasa.
User tidak bisa melihat file ini di Drive UI mereka. Ini
penting agar user tidak bingung atau tidak sengaja menghapusnya.

### Flow Lengkap

#### Setup Pertama (Device Pertama)

```
[User tap "Lanjutkan dengan Google"]
        │
        ▼
[Google Sign-In]
  → Scope diminta:
    • openid (untuk identitas)
    • email (untuk display)
    • https://www.googleapis.com/auth/drive.appdata  ← key storage
        │
        ▼
[Check: apakah key.json sudah ada di Drive?]
        │
    ┌───┴───┐
   TIDAK    YA
    │        │
    ▼        ▼
[Generate  [Download key.json]
 random        │
 32-byte   [Decrypt key dari JSON]
 key]          │
    │          └──────────────┐
    │                         │
    ▼                         ▼
[Simpan ke Drive          [Key siap di memory]
 sebagai key.json]              │
    │                           ▼
    ▼                    [Pull ciphertext dari Supabase]
[Key siap di memory]           │
    │                           ▼
    ▼                    [Decrypt → tampilkan data] ✓
[Mulai collect data]
[Encrypt → push ke Supabase]
```

#### Restore di Device Baru

```
[User buka Luma di HP baru]
        │
        ▼
[Login Google — sama seperti biasa]
        │
        ▼
[Fetch key.json dari Drive — background, <1 detik]
        │
        ▼
[Pull ciphertext dari Supabase]
        │
        ▼
[Decrypt → data muncul] ✓

Total langkah yang user lihat: LOGIN GOOGLE SAJA.
```

#### Dua HP Bersamaan

```
Phone A (kerja)            Google Drive         Supabase          Phone B (pribadi)
      │                         │                   │                    │
      │ key.json ───────────────►                   │                    │
      │                         │◄──────────────────────────── key.json  │
      │ (key sama di kedua HP)  │                   │                    │
      │                         │                   │                    │
      │ push data ──────────────────────────────────►                    │
      │                         │                   │◄─────── push data  │
      │                         │                   │                    │
      │              [Conflict Resolution: last-write-wins per date]     │
```

### Conflict Resolution

```dart
// last-write-wins per daily_summary.date
// Tidak ada merge, tidak ada CRDT — MVP appropriate

Future<void> resolveConflicts({
  required List<DailySummary> local,
  required List<DailySummary> remote,
}) async {
  for (final remoteItem in remote) {
    final localItem = local.firstWhereOrNull(
      (l) => l.date.isSameDay(remoteItem.date),
    );

    final remoteWins = localItem == null ||
        (remoteItem.syncedAt ?? DateTime(0))
            .isAfter(localItem.syncedAt ?? DateTime(0));

    if (remoteWins) {
      await localDb.save(remoteItem);
    }
    // else: local wins, tidak perlu action
  }
}
```

---

## Flutter Implementation

### Dependencies Tambahan

```yaml
# pubspec.yaml — tambahan untuk C1

dependencies:
  googleapis: ^12.0.0          # Google Drive API
  googleapis_auth: ^1.4.1      # Google Auth untuk googleapis
  google_sign_in: ^6.1.0       # Sudah ada, tambah scope
```

### Google Sign-In Scope Update

```dart
// lib/core/services/auth_service.dart

final _googleSignIn = GoogleSignIn(
  scopes: [
    'openid',
    'email',
    'profile',
    // TAMBAHAN untuk C1:
    'https://www.googleapis.com/auth/drive.appdata',
  ],
);
```

### Key Manager Service

```dart
// lib/data/encryption/drive_key_manager.dart

class DriveKeyManager {
  static const _fileName = 'key.json';
  static const _folderName = 'appDataFolder';

  final GoogleSignIn _googleSignIn;

  DriveKeyManager(this._googleSignIn);

  /// Entry point utama. Dipanggil setelah Google Sign-In berhasil.
  /// Return: encryption key siap pakai (32 bytes).
  /// User tidak perlu melakukan apapun selain login Google.
  Future<Uint8List> getOrCreateKey() async {
    // Step 1: Cek apakah key sudah ada di Drive
    final existingKey = await _fetchKeyFromDrive();

    if (existingKey != null) {
      return existingKey; // Restore scenario
    }

    // Step 2: Belum ada — generate key baru (setup pertama)
    final newKey = _generateSecureKey();
    await _saveKeyToDrive(newKey);
    return newKey;
  }

  Uint8List _generateSecureKey() {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
  }

  Future<Uint8List?> _fetchKeyFromDrive() async {
    try {
      final authHeaders = await _getAuthHeaders();
      final driveApi = drive.DriveApi(
        _AuthenticatedClient(authHeaders),
      );

      // List files in appDataFolder
      final fileList = await driveApi.files.list(
        spaces: _folderName,
        q: "name = '$_fileName'",
        fields: 'files(id, name)',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        return null; // Key belum pernah dibuat
      }

      final fileId = fileList.files!.first.id!;

      // Download file content
      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = await media.stream.expand((b) => b).toList();
      final jsonStr = utf8.decode(bytes);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      return base64Decode(json['key'] as String);
    } on drive.DetailedApiRequestError catch (e) {
      if (e.status == 404) return null;
      rethrow;
    }
  }

  Future<void> _saveKeyToDrive(Uint8List key) async {
    final authHeaders = await _getAuthHeaders();
    final driveApi = drive.DriveApi(
      _AuthenticatedClient(authHeaders),
    );

    final payload = jsonEncode({
      'version': '1',
      'key': base64Encode(key),
      'created_at': DateTime.now().toIso8601String(),
    });

    final fileContent = utf8.encode(payload);
    final stream = Stream.value(fileContent);

    await driveApi.files.create(
      drive.File()
        ..name = _fileName
        ..parents = [_folderName],
      uploadMedia: drive.Media(stream, fileContent.length),
    );
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw Exception('Not signed in');
    return await account.authHeaders;
  }
}

// HTTP client helper untuk googleapis
class _AuthenticatedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  _AuthenticatedClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
```

### Encryption Service Update

```dart
// lib/data/encryption/encryption_service.dart
// Update: key tidak lagi derived dari googleUserId
// Key sekarang random, datang dari DriveKeyManager

class EncryptionService {
  final Uint8List _key; // 32-byte random key dari Drive

  // Key di-inject dari DriveKeyManager, bukan di-derive di sini
  EncryptionService(this._key) {
    assert(_key.length == 32, 'Key must be 32 bytes for AES-256');
  }

  Future<EncryptedData> encrypt(String plaintext) async {
    final iv = _generateIV();
    final cipher = AesGcm.with256bits();
    final secretKey = await cipher.newSecretKeyFromBytes(_key);

    final secretBox = await cipher.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: iv,
    );

    return EncryptedData(
      ciphertext: base64Encode(secretBox.cipherText),
      iv: base64Encode(iv),
      mac: base64Encode(secretBox.mac.bytes),
      algorithm: 'AES-256-GCM',
      version: 'v1',
    );
  }

  Future<String> decrypt(EncryptedData data) async {
    final cipher = AesGcm.with256bits();
    final secretKey = await cipher.newSecretKeyFromBytes(_key);

    final secretBox = SecretBox(
      base64Decode(data.ciphertext),
      nonce: base64Decode(data.iv),
      mac: Mac(base64Decode(data.mac)),
    );

    final plaintext = await cipher.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(plaintext);
  }

  Uint8List _generateIV() {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(12, (_) => random.nextInt(256)),
    );
  }
}
```

### Auth Flow Integration

```dart
// lib/core/services/auth_service.dart

class AuthService {
  final GoogleSignIn _googleSignIn;
  final DriveKeyManager _driveKeyManager;
  final EncryptionServiceFactory _encryptionFactory;

  /// Dipanggil saat user tap "Lanjutkan dengan Google"
  /// Return: EncryptionService siap pakai, atau throw jika gagal
  Future<AuthResult> signIn() async {
    // Step 1: Google Sign-In
    final account = await _googleSignIn.signIn();
    if (account == null) throw AuthCancelledException();

    // Step 2: Ambil atau buat key dari Drive (background)
    // User tidak melihat langkah ini — terjadi saat splash/loading
    final key = await _driveKeyManager.getOrCreateKey();

    // Step 3: Inisialisasi EncryptionService dengan key
    final encryptionService = _encryptionFactory.create(key);

    // Step 4: Cek apakah ada data di Supabase (restore scenario)
    final hasCloudData = await _syncService.hasCloudData(account.id);

    return AuthResult(
      userId: account.id,
      email: account.email,
      encryptionService: encryptionService,
      shouldRestore: hasCloudData,
    );
  }

  Future<void> signOut() async {
    // Key otomatis tidak bisa diakses setelah sign out
    // karena Drive access dicabut
    await _googleSignIn.signOut();
    await _encryptionFactory.clear(); // Clear key dari memory
  }
}
```

### Restore Screen (Muncul Otomatis)

```dart
// lib/presentation/pages/restore_page.dart
// Muncul HANYA jika hasCloudData == true saat login di device baru

class RestorePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: LumaColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),

              // Ambient visualization
              AmbientVisualization(progress: 1.0),

              SizedBox(height: 48),

              // Title
              Text(
                'Luma menemukan\nriwayatmu.',
                style: LumaTypography.displayMedium,
              ),

              SizedBox(height: 16),

              // Subtitle — data yang ditemukan
              Text(
                'Ada 47 hari catatan yang bisa dipulihkan.',
                style: LumaTypography.bodyMedium,
              ),

              Spacer(),

              // Primary action
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(syncProvider.notifier)
                      .restore(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: LumaColors.borderSubtle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Pulihkan riwayat',
                    style: LumaTypography.bodyMedium.copyWith(
                      color: LumaColors.textPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Secondary action
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(
                    'Mulai baru',
                    style: LumaTypography.bodyMedium.copyWith(
                      color: LumaColors.textTertiary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Supabase Storage Structure

```
supabase/storage/
└── luma-encrypted/
    └── {sha256(userId)}/        ← hashed, bukan plaintext userId
        ├── daily/
        │   ├── 2026-05-10.enc   ← satu file per hari
        │   ├── 2026-05-11.enc
        │   └── ...
        ├── weekly/
        │   └── 2026-W20.enc
        ├── insights/
        │   └── 2026-05-16.enc
        └── baseline.enc         ← satu file, selalu overwrite
```

### Supabase RLS Policy

```sql
-- Row Level Security: user hanya bisa akses folder mereka sendiri
-- userId di-hash sebelum dijadikan path

CREATE POLICY "Users can only access their own data"
ON storage.objects
FOR ALL
USING (
  bucket_id = 'luma-encrypted'
  AND (storage.foldername(name))[1] = encode(
    digest(auth.uid()::text, 'sha256'),
    'hex'
  )
);
```

---

## Skenario Edge Cases

### Skenario: User Hapus File dari Google Drive

```
Jika user masuk ke Google Drive dan menghapus folder luma/:
  → App tidak bisa ambil key
  → App throw DriveKeyNotFoundException
  → Tampilkan: "File kunci Luma tidak ditemukan di Google Drive."
  → Opsi: "Buat kunci baru" (data lama tidak bisa dibuka lagi)
           "Batal"

Catatan: appDataFolder scope membuat file TIDAK TERLIHAT
di Drive UI biasa. User hanya bisa menghapusnya via
Settings Google → Data & Privacy → Third-party apps → Luma.
Ini sangat unlikely terjadi secara tidak sengaja.
```

### Skenario: Google Drive Tidak Tersedia (Offline)

```
Saat setup pertama (device pertama):
  → Butuh internet untuk save key ke Drive
  → Jika offline: tampilkan "Butuh koneksi untuk setup awal"
  → Retry saat online

Saat sudah setup (device yang sama, buka app biasa):
  → Key sudah di-cache di Android Keystore (secure local cache)
  → Tidak perlu fetch dari Drive setiap kali buka app
  → Bisa offline sepenuhnya setelah setup

Saat restore di device baru:
  → Butuh internet untuk fetch key dari Drive
  → Jika offline: "Butuh koneksi untuk pulihkan data"
```

### Key Caching di Android Keystore

```dart
// Setelah key berhasil diambil dari Drive,
// cache ke Android Keystore agar tidak fetch Drive setiap launch

class DriveKeyManager {
  static const _keystoreAlias = 'luma_cached_key';

  Future<Uint8List> getOrCreateKey() async {
    // 1. Cek local cache dulu (Android Keystore)
    final cached = await _getCachedKey();
    if (cached != null) return cached; // Tidak perlu hit Drive

    // 2. Fetch dari Drive
    final key = await _fetchOrCreateFromDrive();

    // 3. Cache ke Keystore untuk launch berikutnya
    await _cacheKey(key);

    return key;
  }

  Future<Uint8List?> _getCachedKey() async {
    final storage = FlutterSecureStorage();
    final encoded = await storage.read(key: _keystoreAlias);
    if (encoded == null) return null;
    return base64Decode(encoded);
  }

  Future<void> _cacheKey(Uint8List key) async {
    final storage = FlutterSecureStorage();
    await storage.write(
      key: _keystoreAlias,
      value: base64Encode(key),
    );
  }

  Future<void> clearCache() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: _keystoreAlias);
  }
}
```

---

## Implikasi ke Dokumen Lain

### Update: Onboarding Screen 2 (Janji)

Teks lama:
> "Semua data hanya ada di perangkatmu. Kami tidak bisa melihatnya."

Teks baru:
> "Datamu dienkripsi dan dikunci dengan akun Google-mu.
>  Kami tidak bisa membukanya — bahkan jika kami mau."

Tambahkan baris:
> "Kunci tersimpan di Google Drive-mu, bukan di server kami."

### Update: Settings Screen — Section Privasi

```
[Kunci enkripsi]
"Tersimpan di Google Drive-mu"
→ Tap → modal: "Jika kamu menghapus akun Luma dari Google Drive,
  data tidak bisa dibuka lagi. Ini by design."
```

### Update: Error States

```
DriveKeyNotFoundException:
  Title: "Kunci tidak ditemukan"
  Body: "File kunci Luma tidak ada di Google Drive-mu."
  Action: "Buat kunci baru" (data lama musnah)
          "Batal"

DriveAccessRevokedException:
  Title: "Akses Google Drive dicabut"
  Body: "Luma butuh akses Drive untuk membuka datamu."
  Action: "Hubungkan kembali"

DriveOfflineException:
  Title: "Butuh koneksi"
  Body: "Luma perlu mengambil kunci enkripsi dari Google Drive."
  Action: "Coba lagi"
```

---

## Threat Model Final

| Threat | Status | Mekanisme |
|--------|--------|-----------|
| Server Luma membaca data | ✅ Tidak bisa | Server tidak pernah menyentuh key |
| Database Supabase di-breach | ✅ Tidak berguna | Ciphertext tanpa key = noise |
| Developer Luma penasaran | ✅ Tidak bisa | Key ada di Drive user, bukan server |
| APK reverse engineering | ✅ Tidak berguna | Key adalah random, tidak ada secret di APK |
| Attacker punya APK + userId | ✅ Tidak cukup | Masih butuh akses ke Google Drive user |
| Google account di-compromise | ❌ Data terekspos | Google adalah root of trust |
| User revoke Drive access sengaja | ❌ Data tidak bisa dibuka | By design, dikomunikasikan ke user |
| Legal subpoena ke Google | ❌ Google punya account | Di luar scope Luma |

**Dibanding Opsi A:**
Opsi C1 menghilangkan dua threat yang ada di Opsi A:
- APK reverse engineering: tidak berguna karena key random
- Attacker punya APK + userId: tidak cukup karena key ada di Drive

---

## Checklist Implementasi

Tambahan ke Generate.md Wave checklist:

```
Wave 2.5 — Google Drive Key Manager (antara Auth dan DB)
  [ ] Tambah dependency: googleapis, googleapis_auth
  [ ] Update GoogleSignIn scope: tambah drive.appdata
  [ ] Implementasi DriveKeyManager.getOrCreateKey()
  [ ] Implementasi key caching di Android Keystore
  [ ] Update EncryptionService: terima key dari parameter, bukan derive
  [ ] Unit test: key round-trip (generate → save Drive → fetch Drive)
  [ ] Unit test: cache hit (tidak fetch Drive jika cache ada)
  [ ] Integration test: sign in → key tersedia → encrypt → decrypt

Wave 5.5 — Cross-Device Sync (antara Auth dan UI Shell)
  [ ] Implementasi SyncManager (push/pull/conflict)
  [ ] Supabase Storage structure dengan hashed userId path
  [ ] Supabase RLS policy
  [ ] RestorePage (muncul otomatis jika hasCloudData)
  [ ] Settings: "Backup terakhir" + "Backup sekarang"
  [ ] Error states: DriveKeyNotFound, DriveOffline, DriveRevoked
  [ ] End-to-end test: device A setup → wipe → device B restore
```

---

## Summary Satu Paragraf

Luma menggunakan Google Drive appDataFolder sebagai tempat
penyimpanan encryption key — bukan server Luma. Key adalah
32-byte random yang di-generate saat pertama kali sign in,
disimpan sebagai file tersembunyi di Google Drive user, dan
di-cache lokal di Android Keystore untuk akses offline.
Server Luma hanya menyimpan ciphertext. Kombinasi ini
menghasilkan zero-friction cross-device (login Google = data
kembali) dengan ZK yang benar-benar terjaga — bukan hanya
klaim, tapi secara teknis tidak mungkin server membuka data
user.
