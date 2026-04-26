import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_model.dart';

class NutritionProvider extends ChangeNotifier {
  static const _storageKey = 'nutrition_meals_v1';
  static const _goalKey = 'nutrition_goal_kcal_v1';

  final Map<String, List<MealEntry>> _mealsByDay = {};
  int _dailyGoalKcal = 2400;
  DateTime _selectedDay = DateTime.now();
  bool _isLoaded = false;

  NutritionProvider() {
    _load();
  }

  bool get isLoaded => _isLoaded;

  DateTime get selectedDay => _selectedDay;

  int get dailyGoalKcal => _dailyGoalKcal;

  List<MealEntry> get mealsToday {
    final key = _dayKey(_selectedDay);
    final meals = _mealsByDay[key] ?? const [];
    final sorted = meals.toList()..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    return sorted;
  }

  int get totalCalories =>
      mealsToday.fold<int>(0, (sum, m) => sum + m.calories);

  int get totalCarbsG => mealsToday.fold<int>(0, (sum, m) => sum + m.carbsG);
  int get totalProteinG =>
      mealsToday.fold<int>(0, (sum, m) => sum + m.proteinG);
  int get totalFatG => mealsToday.fold<int>(0, (sum, m) => sum + m.fatG);

  double get calorieProgress {
    if (_dailyGoalKcal <= 0) return 0;
    final p = totalCalories / _dailyGoalKcal;
    return p.clamp(0, 1);
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  Future<void> setDailyGoalKcal(int goal) async {
    _dailyGoalKcal = goal <= 0 ? 2400 : goal;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalKey, _dailyGoalKcal);
  }

  Future<void> addMeal(MealEntry meal) async {
    final key = _dayKey(meal.loggedAt);
    final list = (_mealsByDay[key] ?? <MealEntry>[]).toList();
    list.add(meal);
    _mealsByDay[key] = list;
    notifyListeners();
    await _persist();
  }

  Future<void> removeMeal(String mealId) async {
    final key = _dayKey(_selectedDay);
    final list = (_mealsByDay[key] ?? <MealEntry>[]).toList();
    list.removeWhere((m) => m.id == mealId);
    _mealsByDay[key] = list;
    notifyListeners();
    await _persist();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyGoalKcal = prefs.getInt(_goalKey) ?? 2400;

    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          for (final entry in decoded.entries) {
            final dayKey = entry.key;
            final listRaw = entry.value;
            if (listRaw is List) {
              _mealsByDay[dayKey] = listRaw
                  .whereType<Map>()
                  .map((m) => MealEntry.fromJson(Map<String, dynamic>.from(m)))
                  .toList();
            }
          }
        }
      } catch (_) {
        _mealsByDay.clear();
      }
    } else {
      _seedSampleForToday();
    }

    _isLoaded = true;
    notifyListeners();
  }

  void _seedSampleForToday() {
    final now = DateTime.now();
    final key = _dayKey(now);
    _mealsByDay[key] = [
      MealEntry(
        id: 'meal_${now.millisecondsSinceEpoch}_b',
        loggedAt: DateTime(now.year, now.month, now.day, 8, 30),
        mealType: 'Breakfast',
        title: 'Oats + eggs',
        calories: 520,
        carbsG: 55,
        proteinG: 28,
        fatG: 18,
      ),
      MealEntry(
        id: 'meal_${now.millisecondsSinceEpoch}_l',
        loggedAt: DateTime(now.year, now.month, now.day, 13, 10),
        mealType: 'Lunch',
        title: 'Chicken rice',
        calories: 680,
        carbsG: 75,
        proteinG: 45,
        fatG: 14,
      ),
    ];
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, dynamic>{};
    for (final entry in _mealsByDay.entries) {
      map[entry.key] = entry.value.map((m) => m.toJson()).toList();
    }
    await prefs.setString(_storageKey, jsonEncode(map));
  }

  static String _dayKey(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return d.toIso8601String().split('T').first; // yyyy-mm-dd
  }
}

