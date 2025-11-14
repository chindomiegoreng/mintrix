## 🔍 Token Storage Debugging Guide

### Cara Memeriksa Apakah Token Disimpan:

1. **Dalam Console (saat login)**:
   - Cari log: `💾 Saving token...`
   - Cari log: `💾 Token saved: true`
   - Jika ada, maka token berhasil disimpan

2. **Dalam Console (saat app di-restart)**:
   - Cari log: `🔍 Checking token...`
   - Cari log: `✅ Token found in storage` ATAU `ℹ️ No valid token found in storage`
   - Ini akan menunjukkan apakah token berhasil dibaca

### Kemungkinan Masalah dan Solusi:

#### ❌ Problem: "No valid token found in storage"
**Penyebab**: Token tidak tersimpan setelah login
**Solusi**:
1. Cek log login, apakah ada `💾 Saving token...`?
2. Jika tidak ada, berarti token saving code tidak dijalankan
3. Pastikan API response memiliki field `token`

#### ❌ Problem: "Token expired"
**Penyebab**: Token sudah expired (default: 24 jam)
**Solusi**:
1. Login ulang
2. Token akan di-reset dengan expiry 24 jam ke depan

#### ❌ Problem: Navigation ke get-started padahal seharusnya ke main
**Penyebab**: Token tidak tersimpan atau tidak valid
**Solusi**:
1. Buka console dan cari log untuk token check
2. Verifikasi API response dari login endpoint
3. Pastikan `authResponse.token` tidak kosong

### Verifikasi Setup:

✅ File-file yang sudah dibuat:
- `lib/core/services/token_storage_service.dart` - Mengelola penyimpanan token
- `lib/features/auth/data/repositories/auth_repository.dart` - Repository layer
- Auth BLoC sudah diupdate dengan token saving logic

✅ Main.dart sudah diupdate:
- Token storage service diinisialisasi di main()
- AuthRepository dibuat dan di-pass ke AuthBloc

✅ Splash page sudah diupdate:
- Menjalankan CheckTokenEvent saat app start
- Navigasi sesuai dengan token validity

### Testing Steps:

1. **Login Test**:
   - Buka app
   - Login dengan credentials
   - Cek console apakah ada log `💾 Saving token...`
   - Cek apakah navigasi ke main page

2. **Persistent Login Test**:
   - Setelah login, close app
   - Open app lagi
   - Cek console apakah ada log `✅ Token found in storage`
   - Harusnya langsung ke main page tanpa perlu login

3. **Logout Test**:
   - Di main page, logout
   - Cek console apakah ada log `✅ Logout Success`
   - Seharusnya navigasi ke get-started page

### Debug Commands:

Tambahkan ini di app untuk clear token (untuk testing):
```dart
// Di tempat yang mudah diakses (misal: Settings page)
context.read<AuthBloc>().add(LogoutEvent());
```

Atau langsung di terminal:
```bash
flutter clean
flutter pub get
flutter run
```

### Log Pattern yang Diharapkan:

**Login Successful + Token Saved**:
```
💾 Saving token...
  - Token: [token_preview]...
  - User ID: [user_id]
  - Username: [username]
💾 Token saved: true
✅ Login Success: [message]
✅ Token saved to local storage
```

**App Restart + Valid Token**:
```
🔍 Checking token...
✅ Token found in storage
✅ Token is valid
📦 User data: {accessToken: ..., userId: ..., username: ...}
✅ Token is valid, user restored
```

**App Restart + No Token**:
```
🔍 Checking token...
ℹ️ No valid token found in storage
```

---

Jika masih ada masalah, screenshot console log-nya dan share untuk debugging lebih lanjut!
