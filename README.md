# 🎬 CineLog+

**CineLog+** adalah aplikasi mobile berbasis **Flutter** yang berfungsi sebagai aplikasi katalog dan catatan film pribadi.  
Pada versi **Ujian Akhir Semester (UAS)**, aplikasi ini telah dikembangkan dengan **integrasi API publik The Movie Database (TMDB)** untuk menampilkan data film secara real-time, serta dilengkapi fitur **CRUD lokal**, **pencarian film**, dan **Mode Gelap (Dark Mode)**.

Aplikasi ini dikembangkan sebagai bagian dari mata kuliah **Mobile Programming**.

---

## 🧩 Fitur Utama

- 🌐 **Integrasi API TMDB**
  - Mengambil data film Indonesia menggunakan HTTP GET
  - Parsing data JSON ke dalam Model Dart
- 🔍 **Pencarian Film**
  - Mencari film berdasarkan judul langsung dari API TMDB
- ✏️ **CRUD Lokal**
  - Tambah, ubah, dan hapus data film (rating, status, review)
- ⭐ **Film Favorit**
  - Film dengan rating ≥ 4 otomatis masuk daftar favorit
- 🗂️ **Explore Genre**
  - Pengelompokan film berdasarkan genre
- 🌙 **Mode Gelap (Dark Mode)**
  - Tema aplikasi dapat diubah antara Light dan Dark Mode
- 👤 **Login & Signup**
  - Autentikasi sederhana dengan penyimpanan lokal
- 📱 **Navigasi BottomNavigationBar**
  - Home, Tambah, Explore, Favorit, Akun
- 💾 **Penyimpanan Lokal**
  - SharedPreferences (Android)
  - LocalStorage JSON (Web)

---

## 🎨 Desain Antarmuka (UI Design)

Aplikasi menggunakan **tema biru profesional** dengan gaya **Material Design** bawaan Flutter.  
UI dirancang sederhana, bersih, dan responsif di berbagai ukuran layar.

| Elemen          | Fungsi                           | Warna / Kode |
|-----------------|----------------------------------|--------------|
| Warna Utama     | AppBar, tombol utama             | `#1565C0`    |
| Warna Sekunder  | Latar belakang                   | `#E3F2FD`    |
| Aksen           | Gradien & tombol tambahan        | `#2196F3`    |
| Teks Utama      | Judul & isi teks                 | `#0D47A1`    |
| Teks Sekunder   | Teks di latar gelap              | `#FFFFFF`    |

Mode Gelap (Dark Mode) mengubah keseluruhan tampilan aplikasi ke tema gelap tanpa mengubah struktur navigasi.

---

## 🗂️ Struktur Navigasi Aplikasi

| Halaman   | File Dart             | Fungsi Utama                         |
|-----------|-----------------------|--------------------------------------|
| Splash    | `splash_page.dart`    | Logo dan animasi awal                |
| Login     | `login_page.dart`     | Autentikasi pengguna                 |
| Signup    | `signup_page.dart`    | Registrasi akun baru                 |
| Main      | `main_page.dart`      | BottomNavigationBar                  |
| Home      | `home_page.dart`      | Daftar film dari API TMDB            |
| Add/Edit  | `add_edit_page.dart`  | Tambah & edit data film              |
| Detail    | `detail_page.dart`    | Detail lengkap film                  |
| Explore   | `explore_page.dart`   | Film berdasarkan genre               |
| Favorit   | `favorite_page.dart`  | Film rating ≥ 4                      |
| Akun      | `account_page.dart`   | Profil, dark mode, logout            |

> **Akun contoh untuk pengujian:**  
> `admin / 12345` dan `nafisa / 12345` (gunakan untuk log in saat pengujian).

---
<img width="180" height="400" alt="Screenshot 2025-12-12 160822" src="https://github.com/user-attachments/assets/8ee4fde6-551b-4f76-93de-5765d022d535" />
<img width="180" height="400" alt="Screenshot 2025-12-12 155504" src="https://github.com/user-attachments/assets/165e7fd9-a481-4b6e-a549-ad16c2ce3564" />


---

## 🧠 Teknologi yang Digunakan

- Flutter SDK
- Dart Programming Language
- HTTP Package
- The Movie Database (TMDB) API
- SharedPreferences (Android)
- LocalStorage JSON (Web)
- Material Icons
- Widget Flutter:  
  `ListView`, `GridView`, `Card`, `DropdownButton`, `Form`

---

## 🧪 Hasil Pengujian

- ✅ Data film berhasil dimuat dari API TMDB
- ✅ Pencarian film berjalan sesuai query
- ✅ CRUD lokal (tambah, edit, hapus) berfungsi dengan baik
- ✅ Navigasi antarhalaman lancar
- ✅ Mode Gelap dapat diaktifkan dan dinonaktifkan
- ✅ Data tetap tersimpan setelah aplikasi ditutup
- ✅ Tidak ditemukan crash fatal pada alur utama aplikasi

> **Catatan:**  
> Review singkat dari film API TMDB bersifat kosong secara default karena TMDB tidak menyediakan review pribadi pengguna. Review pada aplikasi ini merupakan input manual pengguna.

---

## 📁 Lisensi

Proyek ini dibuat untuk **keperluan akademik (UAS Mobile Programming)**  
dan dapat digunakan sebagai **media pembelajaran pribadi**.

---

## 👩‍💻 Pengembang

**Nama:** Nafisa Devi Nur Rusydah  
**NIM:** 230605110182  
**Program Studi:** Teknik Informatika  
**Universitas Islam Negeri Maulana Malik Ibrahim Malang**  
**Semester:** Ganjil 2025/2026



