import 'package:flutter/foundation.dart';

@immutable
class Trainer {
  final String id;
  final String name;
  final List<String> tags; // Strength, Cardio, HIIT, Nutrition, etc.
  final int yearsExperience;
  final int pricePerSessionUsd;
  final String about;

  const Trainer({
    required this.id,
    required this.name,
    required this.tags,
    required this.yearsExperience,
    required this.pricePerSessionUsd,
    required this.about,
  });

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'T';
    String firstLetter(String s) => s.isEmpty ? '' : s.substring(0, 1).toUpperCase();
    if (parts.length == 1) return firstLetter(parts.first);
    return '${firstLetter(parts[0])}${firstLetter(parts[1])}';
  }
}

