# NontonSkuy! - TV Series & Shows App 🎬
**Latihan Responsi Praktikum Pemrograman Mobile SI-F**

- **NIM**: 124240002
- **Nama Repositori**: `Latres_Mobile_124240002`
- **Mata Kuliah**: Praktikum Pemrograman Mobile (SI-F)
- **Teknologi**: Flutter 3, Dart 3, GetX, Hive, SharedPreferences, TVMaze REST API

---

## 📱 Ringkasan Aplikasi & Tampilan Menarik
Aplikasi **NontonSkuy!** dirancang dengan estetika modern dark cinema (terinspirasi dari platform streaming terkemuka seperti Netflix & Disney+), dilengkapi aksen crimson red, rating gold badge, typography bersih Google Fonts Poppins, responsive grid, serta transisi yang halus.

### 🌟 Fitur Utama & Pemenuhan Kriteria Responsi:
1. **Login Page (15%)**:
   - Form autentikasi dengan validasi:
     - **Username**: `124240002` (NIM)
     - **Password**: `123`
   - Tersedia tombol cepat *Tap isi otomatis* untuk kemudahan pengujian.
   - Menyimpan sesi login menggunakan **`SharedPreferences`**.
   - Sesi bersifat persisten saat aplikasi dibuka kembali.
   - Logout menghapus sesi login dan mengarahkan kembali ke halaman Login.

2. **Home Page (Daftar Shows) (30%)**:
   - **`BottomNavigationBar`** modern dengan 3 navigasi: **Beranda**, **Favorit** (dengan badge jumlah), dan **Profil**.
   - Data diambil secara realtime dari REST API TVMaze: `https://api.tvmaze.com/shows`.
   - Menampilkan poster **Gambar**, **Judul**, dan **Rating** (Bintang emas + nilai rating).
   - Indikator loading (`CircularProgressIndicator`) saat data dimuat.
   - **Pemisahan Arsitektur**: Mekanisme fetch & parse data API dipisah penuh di file `lib/services/api_service.dart`.
   - **Fitur Tambahan Visual & Interaktif**:
     - *Featured Hero Banner* di bagian atas untuk serial dengan rating tertinggi.
     - *Live Search Bar* untuk memfilter judul show secara instan.
     - *Filter Genre Chips* (Drama, Action, Sci-Fi, Crime, Comedy, dll).
   - Klik kartu show navigasi langsung ke halaman **Detail**.

3. **Detail Page (25%)**:
   - Data diambil langsung dari endpoint `https://api.tvmaze.com/shows/{id}`.
   - Menampilkan rincian lengkap:
     - Backdrop & Poster gambar beresolusi tinggi
     - Judul serial TV
     - Rating & Premiered Year & Runtime & Status
     - Tag Genre serial
     - Summary/Overview yang bersih dari tag HTML
   - Tombol **Favorit** (ikon love) dengan animasi status suka/tidak suka dan notifikasi feedback.
   - Tombol **Nonton** untuk simulasi streaming episode.
   - Navigasi kembali ke halaman sebelumnya.

4. **Favorite Page (20%)**:
   - Menampilkan daftar serial favorit pengguna.
   - Data disimpan secara lokal menggunakan database **`Hive`** (`hive_flutter`).
   - Dapat dihapus dari daftar favorit dengan konfirmasi dialog dan tombol hapus (ikon trash merah).
   - Klik pada item favorit langsung mengarahkan ke halaman Detail show tersebut.
   - State reaktif instan (daftar langsung diperbarui tanpa reload manual).

5. **Profile Page (10%)**:
   - Menampilkan identitas pengguna & username yang diambil dari **`SharedPreferences`** (`124240002`).
   - Kartu **Kesan** dan **Pesan** selama mengikuti praktikum pemrograman mobile.
   - Tombol **Logout** fungsional dengan dialog konfirmasi yang membersihkan sesi pengguna.

6. **State Management & Poin Tambahan**:
   - Menggunakan **`GetX`** (`GetxController`, `Obx`, `Get.to`, `Get.offAll`, `Get.snackbar`, `Get.defaultDialog`) untuk pengelolaan state reaktif, routing bersih, dan notifikasi modern.

---

## 📂 Struktur Proyek
```
lib/
├── controllers/
│   ├── auth_controller.dart        # Logika login, logout, sesi SharedPreferences
│   ├── favorite_controller.dart    # State reaktif daftar favorit dengan Hive
│   └── home_controller.dart        # Fetch API shows, pencarian & filter genre
├── models/
│   └── show_model.dart             # Model data TV Show & pembersihan tag HTML
├── services/
│   ├── api_service.dart            # Pemisahan mekanisme HTTP API TVMaze
│   ├── auth_service.dart           # Wrapper SharedPreferences
│   └── hive_service.dart           # Database lokal Hive untuk favorit
├── theme/
│   └── app_theme.dart              # Desain tema cinema dark mode & palette warna
├── views/
│   ├── detail_view.dart            # Halaman detail show (API /shows/{id})
│   ├── favorite_view.dart          # Halaman daftar favorit (Hive)
│   ├── home_view.dart              # Halaman beranda daftar shows & filter
│   ├── login_view.dart             # Halaman login NIM 124240002
│   ├── main_nav_view.dart          # BottomNavigationBar container
│   └── profile_view.dart           # Halaman profil, kesan pesan, & logout
└── main.dart                       # Entry point aplikasi & inisialisasi storage
```

---

## 🚀 Cara Menjalankan Aplikasi
1. Clone repositori:
   ```bash
   git clone <URL_REPO>
   cd Latres_Mobile_124240002
   ```
2. Ambil dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan unit test:
   ```bash
   flutter test
   ```
4. Jalankan aplikasi di perangkat / emulator yang diinginkan:
   ```bash
   flutter run
   ```
