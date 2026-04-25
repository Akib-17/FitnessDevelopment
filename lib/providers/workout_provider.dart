// lib/providers/workout_provider.dart
// Manages the state for workout sessions.
// Tracks active sessions, exercise completion, and rest timers.

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  // ── State Variables ───────────────────────────────────────────────────────
  WorkoutSession? _activeSession;      // Currently running workout session
  List<WorkoutSession> _history = [];  // Past workout sessions
  bool _sessionStarted = false;        // Whether a session is active

  // Rest timer state
  int _restSeconds = 0;            // Remaining rest seconds
  Timer? _restTimer;               // Timer object (nullable)
  bool _isResting = false;         // Whether rest countdown is active

  // ── Getters ───────────────────────────────────────────────────────────────
  WorkoutSession? get activeSession => _activeSession;
  List<WorkoutSession> get history => _history;
  bool get sessionStarted => _sessionStarted;
  int get restSeconds => _restSeconds;
  bool get isResting => _isResting;

  // ── Initialize ────────────────────────────────────────────────────────────
  /// Loads sample workout history on startup.
  /// In production, this would load from a local database or API.
  WorkoutProvider() {
    _history = WorkoutData.sampleHistory;
    // Pre-load today's workout as the active session (not started yet)
    _activeSession = _history.first;
  }

  // ── Start Session ─────────────────────────────────────────────────────────
  /// Marks a workout session as started and activates it.
  void startSession(WorkoutSession session) {
    _activeSession = session;
    _sessionStarted = true;
    notifyListeners();
  }

  // ── Complete Exercise ─────────────────────────────────────────────────────
  /// Marks an individual exercise as done and starts rest timer.
  /// [exerciseId] is the id of the exercise to mark complete.
  void completeExercise(String exerciseId) {
    if (_activeSession == null) return;

    // Find the exercise and mark it complete
    final exercise = _activeSession!.exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => Exercise(id: '', name: '', sets: 0, reps: 0, weightKg: 0),
    );

    if (exercise.id.isNotEmpty) {
      exercise.isCompleted = true;
      notifyListeners();

      // Start rest timer (45 seconds) after completing an exercise
      _startRestTimer(45);
    }
  }

  // ── Rest Timer ────────────────────────────────────────────────────────────
  /// Starts a countdown timer for the rest period.
  /// [seconds] is the rest duration (default 45s).
  void _startRestTimer(int seconds) {
    // Cancel any existing timer first
    _restTimer?.cancel();
    _restSeconds = seconds;
    _isResting = true;
    notifyListeners();

    // Tick every second and decrement counter
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSeconds > 0) {
        _restSeconds--;
        notifyListeners();
      } else {
        // Timer done — stop resting
        _isResting = false;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  /// Manually skip the rest timer
  void skipRest() {
    _restTimer?.cancel();
    _isResting = false;
    _restSeconds = 0;
    notifyListeners();
  }

  // ── End Session ───────────────────────────────────────────────────────────
  /// Ends the current session and moves it to history.
  void endSession() {
    _restTimer?.cancel();
    _isResting = false;
    _sessionStarted = false;
    notifyListeners();
  }

  // ── Dispose ───────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _restTimer?.cancel(); // Clean up timer to prevent memory leaks
    super.dispose();
  }
}
