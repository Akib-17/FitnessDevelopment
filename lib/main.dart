// lib/main.dart
// Entry point of the Fitness App.
// Sets up the Provider state management and theming, then launches LoginScreen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/trainer_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/login_screen.dart';
import 'utils/app_theme.dart';

void main() {
  // Ensures Flutter framework is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ── Register all global state providers ───────────────────────────────
      // These are accessible anywhere in the widget tree via context.read/watch
      providers: [
        // AuthProvider: manages login/signup/logout state
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // WorkoutProvider: manages active session, exercise completion, rest timer
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),

        // NutritionProvider: diet tracking, meals, macro totals
        ChangeNotifierProvider(create: (_) => NutritionProvider()),

        // TrainerProvider: marketplace browsing & filtering
        ChangeNotifierProvider(create: (_) => TrainerProvider()),
      ],
      child: MaterialApp(
        title: 'FitApp',
        debugShowCheckedModeBanner: false, // Remove debug banner

        // ── Global App Theme ──────────────────────────────────────────────
        theme: AppTheme.lightTheme,

        // ── Start Screen ──────────────────────────────────────────────────
        // Always start at Login; auth state will redirect to Dashboard if needed
        home: const LoginScreen(),
      ),
    );
  }
}
