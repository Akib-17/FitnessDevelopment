// lib/providers/auth_provider.dart
// Manages authentication state for the app using the Provider pattern.
// Handles login, signup, and logout logic.
// In a real app, this would make API calls to a backend server.

import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Possible states during an auth operation
enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  // ── State Variables ───────────────────────────────────────────────────────
  UserModel? _currentUser;    // The currently logged-in user (null if logged out)
  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // ── Getters (read-only access for UI) ─────────────────────────────────────
  UserModel? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // ── Mock User Database ────────────────────────────────────────────────────
  // Simulates a backend user store. In production, replace with real API calls.
  final List<Map<String, String>> _registeredUsers = [
    {
      'email': 'rahim@example.com',
      'password': 'password123',
      'name': 'Rahim Chowdhury',
    }
  ];

  // ── Login ─────────────────────────────────────────────────────────────────
  /// Validates credentials and sets the current user if successful.
  /// [email] and [password] are the user's credentials.
  Future<bool> login(String email, String password) async {
    // Set loading state so UI can show a spinner
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simulate a network delay (remove in production)
    await Future.delayed(const Duration(milliseconds: 1200));

    // Find a matching user in our mock database
    final match = _registeredUsers.firstWhere(
      (u) => u['email'] == email.trim().toLowerCase() &&
             u['password'] == password,
      orElse: () => {},
    );

    if (match.isEmpty) {
      // Credentials don't match — set error state
      _status = AuthStatus.error;
      _errorMessage = 'Invalid email or password. Please try again.';
      notifyListeners();
      return false;
    }

    // ✅ Login successful — create the user model
    _currentUser = UserModel(
      id: 'user_001',
      name: match['name']!,
      email: match['email']!,
      weight: 78,
      height: 175,
      goal: 'Fat Loss',
      memberSince: 'Jan 2024',
    );
    _isLoggedIn = true;
    _status = AuthStatus.success;
    notifyListeners();
    return true;
  }

  // ── Sign Up ───────────────────────────────────────────────────────────────
  /// Registers a new user and automatically logs them in.
  /// [name], [email], [password] are the registration fields.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Check if email is already registered
    final exists = _registeredUsers.any(
      (u) => u['email'] == email.trim().toLowerCase(),
    );

    if (exists) {
      _status = AuthStatus.error;
      _errorMessage = 'An account with this email already exists.';
      notifyListeners();
      return false;
    }

    // ✅ Registration successful — add to mock database
    _registeredUsers.add({
      'email': email.trim().toLowerCase(),
      'password': password,
      'name': name.trim(),
    });

    // Auto-login after registration
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      weight: 70,
      height: 170,
      goal: 'General Fitness',
      memberSince: 'Apr 2026',
    );
    _isLoggedIn = true;
    _status = AuthStatus.success;
    notifyListeners();
    return true;
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  /// Clears user session and redirects to login.
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Reset error state ─────────────────────────────────────────────────────
  /// Called when user starts typing again to clear the error banner.
  void clearError() {
    _errorMessage = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }
}
