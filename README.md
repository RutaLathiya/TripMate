# 🧳 TripMate — Travel Planning & Management App

> *Your all-in-one companion for stress-free group and solo travel.*

---

## 📖 About the Project

**TripMate** is a comprehensive mobile application designed to simplify the complete lifecycle of trip planning and execution. Whether you're a solo backpacker or organizing a group adventure, TripMate brings everything together — itineraries, expenses, documents, journals, and emergency tools — into one seamless iOS experience.

> 🎓 Developed as a **Graduation Project** | Academic Year: 2025–2026
> 📄 Document Version: 1.0 | Classification: Graduation Project

---

## 🎯 Problem Statement

Travelers today juggle multiple fragmented tools:
- 📊 Spreadsheets for expense tracking
- 💬 WhatsApp for group coordination
- 🗺️ Google Maps for navigation
- 📝 Notes apps for checklists and journals

**TripMate solves this** by consolidating everything into one intuitive platform.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 👤 User Auth | Phone OTP login (Firebase) + Google Sign-In |
| 🗺️ Trip Management | Create, view, edit, and delete trips |
| 📍 Stop Management | Add stops with GPS coordinates, dates & notes |
| 👥 Member Management | Add trip members and link to user accounts |
| 💰 Expense Tracking | Log expenses by category, payer, and date |
| 🔀 Bill Splitting | Auto-split bills and view personal balances |
| ✅ Checklist | Packing lists with done/not-done tracking |
| 📔 Travel Journal | Daily entries with text and photos |
| ⛽ Fuel & Mileage | Log refills and calculate road trip mileage |
| 🆘 SOS / Emergency | View nearby hospitals, garages, hotels & police via MapKit |
| 🌦️ Weather Info | Real-time weather at each stop via OpenWeatherMap |
| 💳 Payment | Razorpay Web Checkout integration for expense settlement |
| 🛡️ Admin Panel | Manage users, trips, and platform settings |

---

## 💳 Payment Module

> ⚠️ **Important Note:**
> The **Payment Module** backend is built using **Node.js**.
> - The **Node.js source code** has **not been uploaded** to this repository.
> - The **MySQL database** for the payment module has also **not been uploaded**.
> - These will be shared separately upon request.

On the **iOS side**, the payment module uses:
- 💸 **Razorpay Web Checkout** (via `WKWebView` — no SDK, Swift 6 compatible)
- 🧾 In-memory `PaymentStore` for local payment records
- 📋 Transaction history with statuses: `initiated / processing / success / failed / pending`
- 🏦 Supported methods: UPI, Card, Cash, Bank Transfer

---

## 🏗️ Tech Stack

### 📱 Frontend (iOS)
| Technology | Purpose |
|---|---|
| Swift / SwiftUI | iOS App Development |
| Xcode | Development IDE |
| CoreData | Local data persistence (trips, expenses, members, etc.) |
| MVVM Architecture | ViewModels + Repository pattern |
| MapKit | SOS nearby places search (hospitals, garages, hotels, police) |
| CocoaPods | Dependency management |

### 🔐 Authentication
| Technology | Purpose |
|---|---|
| Firebase Auth | Phone number OTP-based login |
| Google Sign-In | Google OAuth login |
| UserDefaults | Local session management |

### ☁️ External Services
| Service | Purpose |
|---|---|
| Firebase Auth | Phone OTP & Google Sign-In authentication |
| OpenWeatherMap API | Real-time weather data per stop |
| Razorpay Web Checkout | In-app payment gateway via WKWebView |
| MapKit | Maps, trip routes, SOS nearby places |

### 🖥️ Payment Backend *(Not Uploaded)*
| Technology | Purpose |
|---|---|
| Node.js | Payment module backend server |
| MySQL | Payment module database |

---

## 🗃️ Local Database — CoreData

All core app data is stored **locally on-device using CoreData** (SQLite under the hood). There is **no remote backend** for the core modules.

```
CoreData Entities:
👤 UserEntity
🗺️ TripEntity       → 📍 StopEntity
                    → 👥 TripMemberEntity
                    → 💰 ExpenseEntity → 🔀 ExpenseMemberEntity
                    → ✅ ChecklistItem
                    → 📔 JournalEntry
                    → ⛽ FuelLogEntity

💳 Payment (Node.js + MySQL — NOT uploaded)
```

---

## 📐 Architecture

TripMate follows **MVVM (Model-View-ViewModel)** with a Repository pattern:

```
📱 SwiftUI Views
    ↓
⚙️  ViewModels
    ↓
🗂️  Repositories (AuthRepository, TripRepository, ExpenseRepository, etc.)
    ↓
💾  CoreData (local) + Firebase Auth + OpenWeatherMap + Razorpay
```

---

## 🔐 Authentication Flow

```
📱 User opens app
    ↓
📞 Enter phone number → Firebase sends OTP SMS
    ↓
🔢 Enter OTP → Firebase verifies → User signed in
    — OR —
🔵 Tap Google Sign-In → Firebase Auth → User signed in
    ↓
💾 Session saved in UserDefaults via SessionManager
```

> ℹ️ **Note:** JWT is **not used**. Session is managed via `UserDefaults` storing the CoreData `NSManagedObjectID`.

---

## 🚀 Getting Started

### Prerequisites
- macOS with **Xcode** installed
- **iOS 16.0+** device or simulator
- CocoaPods installed (`sudo gem install cocoapods`)
- Firebase project with `GoogleService-Info.plist` configured
- OpenWeatherMap API key
- Razorpay account (for payment testing)
- Node.js + MySQL *(for Payment Module — setup separately)*

### Installation

```bash
# Clone the repository
git clone https://github.com/RutaLathiya/TripMate.git
cd TripMate/TripMate

# Install CocoaPods dependencies
pod install

# Open the workspace (NOT .xcodeproj)
open TripMate.xcworkspace
```

> 📌 **Payment Module:** The Node.js backend and MySQL schema are not included in this repo. Contact the team for separate setup instructions.

---

## 📅 Development Timeline

| Sprint | Weeks | Deliverables |
|---|---|---|
| 🛠️ Sprint 1 – Setup | 1–2 | Project setup, CoreData schema, Firebase Auth |
| 🗺️ Sprint 2 – Core | 3–5 | Trip, Stop, Member management |
| 💰 Sprint 3 – Expense | 6–7 | Expense tracking, Bill splitting |
| ✅ Sprint 4 – Utilities | 8–9 | Checklist, Journal, Fuel calculator |
| 🆘 Sprint 5 – Advanced | 10–11 | SOS (MapKit), Weather (OpenWeatherMap), Admin, Razorpay |
| 🧪 Sprint 6 – Testing | 12–13 | Unit & Integration testing, Bug fixes |
| 📦 Sprint 7 – Final | 14 | Documentation, deployment prep |

---

## 🔮 Future Enhancements

- 🤖 **AI Trip Recommendations** — Smart destination & budget suggestions
- 🌍 **Android Support** — Flutter or React Native cross-platform version
- 💱 **Currency Conversion** — Real-time forex for international trips
- 🗺️ **Offline Maps** — Downloadable maps for low-connectivity areas
- 🌐 **Multi-language Support** — Hindi, Gujarati, and more regional languages
- 📊 **Trip Analytics** — Visual spending reports and travel trends
- ⌚ **Apple Watch App** — Quick expense logging and SOS from wrist

---

## 👨‍💻 Team

Developed by **B.Sc. IT students** as part of the Graduation Project.

> 🏫 Guided by Faculty Mentor | Academic Year 2025–202

---

## 📜 License

This project is developed for academic purposes. All rights reserved © 2026 TripMate Team.

---

> 💡 *"Because every great trip deserves great planning."* 🌏
