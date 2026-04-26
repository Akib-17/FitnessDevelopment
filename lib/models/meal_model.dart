import 'package:flutter/foundation.dart';

@immutable
class MealEntry {
  final String id;
  final DateTime loggedAt;
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final String title;
  final int calories;
  final int carbsG;
  final int proteinG;
  final int fatG;

  const MealEntry({
    required this.id,
    required this.loggedAt,
    required this.mealType,
    required this.title,
    required this.calories,
    required this.carbsG,
    required this.proteinG,
    required this.fatG,
  });

  MealEntry copyWith({
    String? id,
    DateTime? loggedAt,
    String? mealType,
    String? title,
    int? calories,
    int? carbsG,
    int? proteinG,
    int? fatG,
  }) {
    return MealEntry(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      mealType: mealType ?? this.mealType,
      title: title ?? this.title,
      calories: calories ?? this.calories,
      carbsG: carbsG ?? this.carbsG,
      proteinG: proteinG ?? this.proteinG,
      fatG: fatG ?? this.fatG,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loggedAt': loggedAt.toIso8601String(),
      'mealType': mealType,
      'title': title,
      'calories': calories,
      'carbsG': carbsG,
      'proteinG': proteinG,
      'fatG': fatG,
    };
  }

  static MealEntry fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: (json['id'] ?? '').toString(),
      loggedAt: DateTime.tryParse((json['loggedAt'] ?? '').toString()) ??
          DateTime.now(),
      mealType: (json['mealType'] ?? 'Meal').toString(),
      title: (json['title'] ?? '').toString(),
      calories: _asInt(json['calories']),
      carbsG: _asInt(json['carbsG']),
      proteinG: _asInt(json['proteinG']),
      fatG: _asInt(json['fatG']),
    );
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}

