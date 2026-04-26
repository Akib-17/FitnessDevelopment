import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/trainer_booking_model.dart';
import '../models/trainer_model.dart';

class TrainerProvider extends ChangeNotifier {
  static const _bookingsKey = 'trainer_bookings_v1';

  final List<Trainer> _all = const [
    Trainer(
      id: 't_alex',
      name: 'Alex Carter',
      tags: ['Strength'],
      yearsExperience: 7,
      pricePerSessionUsd: 45,
      about:
          'Strength-focused coaching with progressive overload, clean technique, and sustainable routines.',
    ),
    Trainer(
      id: 't_maria',
      name: 'Maria Gomez',
      tags: ['HIIT', 'Nutrition'],
      yearsExperience: 5,
      pricePerSessionUsd: 35,
      about:
          'High-energy HIIT programming plus nutrition guidance to help you lean out while staying strong.',
    ),
    Trainer(
      id: 't_sam',
      name: 'Sam Okonkwo',
      tags: ['Cardio', 'Weight loss'],
      yearsExperience: 4,
      pricePerSessionUsd: 30,
      about:
          'Cardio and fat-loss coaching with achievable weekly targets and simple habit systems.',
    ),
    Trainer(
      id: 't_riya',
      name: 'Riya Sen',
      tags: ['Yoga', 'Mobility'],
      yearsExperience: 6,
      pricePerSessionUsd: 40,
      about:
          'Yoga, mobility, and recovery sessions to improve flexibility, reduce pain, and build balance.',
    ),
  ];

  String _searchQuery = '';
  String _category = 'All'; // All, Strength, Cardio, HIIT, Yoga

  final List<TrainerBooking> _bookings = [];
  bool _bookingsLoaded = false;

  TrainerProvider() {
    _loadBookings();
  }

  String get searchQuery => _searchQuery;
  String get category => _category;

  List<String> get categories => const ['All', 'Strength', 'Cardio', 'HIIT', 'Yoga'];

  bool get bookingsLoaded => _bookingsLoaded;

  List<TrainerBooking> get bookings {
    final list = _bookings.toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return list;
  }

  Trainer? getTrainerById(String id) {
    try {
      return _all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Trainer> get filtered {
    final q = _searchQuery.trim().toLowerCase();
    return _all.where((t) {
      final matchesCategory =
          _category == 'All' || t.tags.any((tag) => tag.toLowerCase() == _category.toLowerCase());
      final matchesQuery = q.isEmpty ||
          t.name.toLowerCase().contains(q) ||
          t.tags.any((tag) => tag.toLowerCase().contains(q));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  Future<void> bookTrainer({
    required String trainerId,
    required DateTime scheduledAt,
  }) async {
    final now = DateTime.now();
    final booking = TrainerBooking(
      id: 'bk_${now.microsecondsSinceEpoch}',
      trainerId: trainerId,
      scheduledAt: scheduledAt,
      createdAt: now,
    );
    _bookings.add(booking);
    notifyListeners();
    await _persistBookings();
  }

  Future<void> cancelBooking(String bookingId) async {
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
    await _persistBookings();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_bookingsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _bookings
            ..clear()
            ..addAll(decoded.whereType<Map>().map(
                (e) => TrainerBooking.fromJson(Map<String, dynamic>.from(e))));
        }
      } catch (_) {
        _bookings.clear();
      }
    }
    _bookingsLoaded = true;
    notifyListeners();
  }

  Future<void> _persistBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _bookings.map((b) => b.toJson()).toList();
    await prefs.setString(_bookingsKey, jsonEncode(payload));
  }
}

