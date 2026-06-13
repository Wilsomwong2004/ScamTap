# 🛡️ ScamTap

A Malaysian-focused mobile app for detecting scams includes phone numbers, URLs, and messages that are powered by multiple threat intelligence APIs and Firebase.

---

## 📱 Features

### User Features
- **Phone Number Check** — Validates numbers via [NumVerify](https://numverify.com/) and cross-references with [PenipuMY](https://semakmule.rmp.gov.my/) scam databases
- **URL Scanner** — Scans links using [VirusTotal](https://www.virustotal.com/) and [Google Safe Browsing](https://safebrowsing.google.com/)
- **Message Analyser** — Detects spam using a HuggingFace ML model combined with Malaysian scam keyword matching
- **Bulk Scan** — Scan multiple inputs at once *(premium)*
- **Monitor** — Ongoing monitoring for watched numbers/URLs *(premium)*
- **AI Risk Scoring** — Powered by Firebase AI Logic (Gemini) with a visual score gauge
- **Scam Alerts** — Browse all reported scam alerts in Malaysia
- **Search History** — All scan results saved to Firestore under each user's account
- **Scam Tip of the Day** — Cycles through 31 Malaysia-relevant scam types to educate users
- **Authentication** — Email/password login and registration via Firebase Auth, with username support

### Admin Features
- **Dashboard** — Overview of platform analytics and stats
- **Manage Users** — View and manage user accounts
- **Manage Reports** — Review and act on scam reports submitted by users
- **Scan History** — View all scan activity across the platform
- **Notifications** — Send announcements to users
- **Settings** — Platform configuration

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| Backend / Database | Firebase Firestore |
| Authentication | Firebase Auth |
| AI / ML | Firebase AI Logic (Gemini), HuggingFace |
| APIs | NumVerify, VirusTotal, Google Safe Browsing, PenipuMY |
| Environment Config | `flutter_dotenv` (`.env` file) |

---

## 📁 Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── admin_stats_model.dart
│   ├── auth_result_model.dart
│   ├── news_model.dart
│   ├── search_record_model.dart
│   └── users_model.dart
├── pages/
│   ├── admin/
│   │   ├── admin_dashboard_page.dart
│   │   ├── manage_reports_page.dart
│   │   ├── manage_users_page.dart
│   │   ├── notifications_page.dart
│   │   ├── scan_history_page.dart
│   │   └── settings_page.dart
│   └── free_users/
│       ├── all_scam_alert_page.dart
│       ├── bulk_scan_page.dart
│       ├── home.dart
│       ├── login_page.dart
│       ├── lookup_page.dart
│       ├── message_page.dart
│       ├── monitor_page.dart
│       ├── premium_purchase_page.dart
│       ├── register_page.dart
│       ├── scamreport_page.dart
│       └── scanning_page.dart
├── services/
│   ├── admin_service.dart
│   ├── analytics_service.dart
│   ├── auth_service.dart
│   ├── cache_service.dart
│   ├── firebase_options.dart
│   ├── firestore_service.dart
│   ├── premium_service.dart
│   ├── report_service.dart
│   ├── scam_service.dart
│   ├── user_service.dart
│   └── validation_service.dart
└── widgets/
    ├── animatedhinttextfield.dart
    ├── miniprofile.dart
    ├── navibar.dart
    ├── news_section.dart
    ├── scamdetectedcolorcontainer.dart
    ├── scamTipOfTheDay.dart
    └── scoregauge.dart
```

---

## ⚙️ Setup & Installation

### Prerequisites

- Flutter SDK (stable channel)
- Firebase project with Firestore, Auth, and AI Logic enabled
- Java 17 (required for Gradle compatibility — Java 21+ causes build errors)

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/ScamTap.git
cd ScamTap
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure environment variables

Create a `.env` file in the project root:

```env
NUMVERIFY_API_KEY=your_key_here
VIRUSTOTAL_API_KEY=your_key_here
GOOGLE_SAFE_BROWSING_API_KEY=your_key_here
HUGGINGFACE_API_KEY=your_key_here
```

> ⚠️ Never commit your `.env` file. Add it to `.gitignore`.

### 4. Firebase setup

- Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) from the Firebase Console
- Enable **Firestore**, **Authentication (Email/Password)**, and **Firebase AI Logic** in your project

### 5. Run the app

```bash
flutter run
```

---

## 🗄️ Firestore Data Structure

```
usersData/
└── {uid}/
    ├── username: "string"
    ├── email: "string"
    └── searchRecord/
        └── {documentId}/
            ├── type: "phone" | "url" | "message"
            ├── input: "string"
            ├── result: "Safe" | "Suspicious" | "Scam"
            ├── riskScore: number
            └── timestamp: Timestamp
```

---

## 🧪 Running Tests

Unit tests are located in the `test/` directory and cover:

- Email / password / phone / link / message input validation
- Risk score classification logic
- Scam detection service result handling

```bash
flutter test
```

---

## 📋 Scam Categories Covered

ScamTap's tip system and classification engine covers 31 scam types relevant to Malaysia, including:

- Macau Scam, Love Scam, Job Scam, Investment Scam
- Parcel Scam, Phishing, Clone Website, SIM Swap
- WhatsApp Takeover, MSISDN Scam, and more

---

## 🔒 Privacy

- All scan data is stored per-user and is not shared
- API keys are loaded from `.env` at runtime and never hardcoded
- No personally identifiable information beyond email and username is collected
