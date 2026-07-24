# senagamedeals_hub

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 🎮 Senagamedeals Hub

Aplikasi mobile berbasis Flutter untuk mencari dan melihat promo game terbaik dari berbagai platform menggunakan CheapShark API. Aplikasi ini juga dilengkapi fitur autentikasi, wishlist, review game, dan dashboard statistik yang terhubung dengan Laravel REST API.

---

## 📱 Fitur Utama

- 🔐 Login & Register User
- 🎮 Menampilkan daftar game promo
- 🔍 Pencarian game
- ❤️ Wishlist Game
- ⭐ Review dan Rating Game
- 📊 Dashboard Statistik
- 👤 Profil Pengguna
- 🌐 Integrasi REST API Laravel
- 💾 Penyimpanan data ke MySQL

---

## 🛠️ Teknologi yang Digunakan

### Frontend
- Flutter
- Dart

### Backend
- Laravel 10
- REST API
- Sanctum Authentication

### Database
- MySQL

### API Eksternal
- CheapShark API

---

# 📸 Tampilan Aplikasi

## Splash Screen

![Splash Screen](assets/images/awal.jpeg)

---

## Login Screen

![Login Screen](assets/images/login.jpeg)

---

## Register Screen

![Register Screen](assets/images/register.jpeg)

---

## Home Screen

![Home Screen](assets/images/1.jpeg)


# 📂 Struktur Project

```bash
lib/
│
├── models/
├── services/
├── screens/
├── widgets/
├── main.dart
│
backend/
│
├── app/
├── routes/
├── database/
├── public/
└── .env
```

---

# 🚀 Cara Menjalankan Project

## 1. Clone Repository

```bash
git clone https://github.com/USERNAME/senagamedeals_hub.git
```

Masuk ke folder project:

```bash
cd senagamedeals_hub
```

---

## 2. Install Dependency Flutter

```bash
flutter pub get
```

---

## 3. Konfigurasi API

Buka file:

```dart
lib/services/api_service.dart
```

Pastikan Base URL sesuai:

```dart
class ApiService {
  static const String baseUrl =
      "https://pwmhs.web.id/garneza/api";
}
```

---

## 4. Jalankan Aplikasi

```bash
flutter run
```

---

# 🔗 REST API Endpoint

## Authentication

| Method | Endpoint |
|----------|------------|
| POST | /register |
| POST | /login |
| POST | /logout |

---

## Wishlist

| Method | Endpoint |
|----------|------------|
| GET | /wishlists?user_id=1 |
| GET | /wishlists/{id} |
| POST | /wishlists |
| PUT | /wishlists/{id} |
| DELETE | /wishlists/{id} |

---

## Review

| Method | Endpoint |
|----------|------------|
| GET | /reviews |
| GET | /reviews/{id} |
| POST | /reviews |
| PUT | /reviews/{id} |
| DELETE | /reviews/{id} |

---

# 📊 Database

Database menggunakan MySQL dengan beberapa tabel utama:

- users
- wishlists
- reviews
- personal_access_tokens

---

# 👨‍💻 Developer

**Garneza Bima Priambada**

Teknik Informatika  
Universitas Duta Bangsa Surakarta

---

# 📜 Lisensi

Project ini dibuat untuk keperluan pembelajaran dan tugas UAS Mobile Programming.
