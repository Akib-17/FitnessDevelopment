# 🏋️ Fitness App — Flutter

A mobile fitness platform built with Flutter, featuring health tracking, workout planning, and AI-driven recommendations.

---

## 📱 Screens Implemented

| Screen | File | Description |
|--------|------|-------------|
| Login | `lib/screens/login_screen.dart` | Email/password login with validation |
| Sign Up | `lib/screens/signup_screen.dart` | User registration with form validation |
| Health Dashboard | `lib/screens/dashboard_screen.dart` | Steps, calories, heart rate, weekly chart |
| Workout Tracking | `lib/screens/workout_screen.dart` | Active session, exercise list, rest timer |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                    # App entry point, Provider setup
├── models/
│   ├── user_model.dart          # User data class (name, weight, height, goal)
│   └── workout_model.dart       # Exercise & WorkoutSession data classes + mock data
├── providers/
│   ├── auth_provider.dart       # Login/signup/logout state management
│   └── workout_provider.dart    # Active session, timer, exercise completion
├── screens/
│   ├── login_screen.dart        # Screen 1: Login
│   ├── signup_screen.dart       # Screen 1b: Sign Up
│   ├── dashboard_screen.dart    # Screen 2: Health Dashboard
│   └── workout_screen.dart      # Screen 3: Workout Tracking
└── utils/
    └── app_theme.dart           # Global colors, text styles, theme data
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android Studio or VS Code with Flutter extension

### Installation

```bash
# 1. Navigate to project folder
cd fitness_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### For physical device or emulator
```bash
flutter devices           # List connected devices
flutter run -d <device>   # Run on specific device
```

---

## 🔑 Demo Login Credentials

```
Email:    rahim@example.com
Password: password123
```

You can also create a new account via **Sign Up**.

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management (AuthProvider, WorkoutProvider) |
| `shared_preferences` | Local storage (future auth persistence) |
| `fl_chart` | Bar chart for weekly activity on Dashboard |
| `percent_indicator` | Progress indicators |
| `intl` | Date formatting |

---

## 🏗️ Architecture

This app follows a **Provider + MVC-like** pattern:

- **Models** — Pure data classes (no logic)
- **Providers** — Business logic + state (ChangeNotifier)
- **Screens** — UI only, reads from providers via `context.watch`
- **Utils** — Shared constants (theme, colors)

**Navigation Flow (matches schema diagram):**
```
LoginScreen ──sign in──▶ DashboardScreen
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        WorkoutScreen   NutritionScreen  ProfileScreen
              │
          (back) ──────────▶ DashboardScreen
```

---

## 💡 Viva Notes

### Why Provider?
Provider is Flutter's recommended lightweight state management. `ChangeNotifier` + `notifyListeners()` updates all listening widgets when state changes.

### Why separate providers?
- **AuthProvider** handles only auth logic (login, signup, logout)
- **WorkoutProvider** handles only workout logic (session, timer, exercises)
- This is the **Single Responsibility Principle** — each class does one thing

### How does navigation work?
- `Navigator.push()` — pushes a new screen on the stack
- `Navigator.pushReplacement()` — replaces current screen (used after login)
- `Navigator.pushAndRemoveUntil()` — clears entire stack (used after signup)

### How does the rest timer work?
`WorkoutProvider` uses Dart's `Timer.periodic()` which fires every second, decrements `_restSeconds`, and calls `notifyListeners()` to update the UI countdown display.

### Form validation
Flutter's `Form` + `GlobalKey<FormState>` allows running `validate()` on all fields at once. Each `TextFormField` has a `validator` callback that returns an error string or null.
