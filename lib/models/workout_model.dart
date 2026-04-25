// lib/models/workout_model.dart
// Data classes for workout sessions and individual exercises.

/// Represents a single exercise within a workout (e.g. Bench Press).
class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final double weightKg;    // Weight used in kg (0 if bodyweight)
  bool isCompleted;         // Tracks if this exercise is done in current session

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weightKg,
    this.isCompleted = false,
  });
}

/// Represents a full workout session (e.g. "Push Day – Chest & Triceps").
class WorkoutSession {
  final String id;
  final String title;         // e.g. "Push Day · Chest & Triceps"
  final String category;      // e.g. "Strength", "Cardio", "HIIT"
  final int durationMinutes;  // Estimated duration
  final List<Exercise> exercises;
  final DateTime date;        // Date of the session
  bool isActive;              // Whether session is currently running

  WorkoutSession({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.exercises,
    required this.date,
    this.isActive = false,
  });

  /// Returns how many exercises have been marked as completed
  int get completedCount => exercises.where((e) => e.isCompleted).length;

  /// Returns progress as a value between 0.0 and 1.0
  double get progress =>
      exercises.isEmpty ? 0 : completedCount / exercises.length;
}

/// Sample/mock workout data for demonstration and development purposes.
/// In production, this would be fetched from an API or local database.
class WorkoutData {
  static List<Exercise> get sampleExercises => [
    Exercise(id: 'e1', name: 'Bench Press',        sets: 4, reps: 10, weightKg: 60),
    Exercise(id: 'e2', name: 'Incline Dumbbell',   sets: 3, reps: 12, weightKg: 22),
    Exercise(id: 'e3', name: 'Tricep Pushdown',    sets: 3, reps: 15, weightKg: 15),
    Exercise(id: 'e4', name: 'Cable Fly',          sets: 3, reps: 15, weightKg: 12),
    Exercise(id: 'e5', name: 'Overhead Press',     sets: 3, reps: 10, weightKg: 40),
    Exercise(id: 'e6', name: 'Dips',               sets: 3, reps: 12, weightKg: 0),
  ];

  static List<WorkoutSession> get sampleHistory => [
    WorkoutSession(
      id: 'w1',
      title: 'Push Day · Chest & Triceps',
      category: 'Strength',
      durationMinutes: 50,
      exercises: sampleExercises,
      date: DateTime.now(),
    ),
    WorkoutSession(
      id: 'w2',
      title: 'Pull Day · Back & Biceps',
      category: 'Strength',
      durationMinutes: 45,
      exercises: [
        Exercise(id: 'e7',  name: 'Deadlift',         sets: 4, reps: 6,  weightKg: 100),
        Exercise(id: 'e8',  name: 'Barbell Row',      sets: 4, reps: 8,  weightKg: 60),
        Exercise(id: 'e9',  name: 'Lat Pulldown',     sets: 3, reps: 12, weightKg: 55),
        Exercise(id: 'e10', name: 'Bicep Curl',       sets: 3, reps: 15, weightKg: 14),
      ],
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    WorkoutSession(
      id: 'w3',
      title: 'Leg Day · Quads & Glutes',
      category: 'Strength',
      durationMinutes: 55,
      exercises: [
        Exercise(id: 'e11', name: 'Squat',            sets: 4, reps: 8,  weightKg: 80),
        Exercise(id: 'e12', name: 'Leg Press',        sets: 3, reps: 12, weightKg: 120),
        Exercise(id: 'e13', name: 'Romanian Deadlift',sets: 3, reps: 10, weightKg: 60),
        Exercise(id: 'e14', name: 'Calf Raises',      sets: 4, reps: 20, weightKg: 40),
      ],
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    WorkoutSession(
      id: 'w4',
      title: 'HIIT Cardio',
      category: 'Cardio',
      durationMinutes: 30,
      exercises: [
        Exercise(id: 'e15', name: 'Jumping Jacks',    sets: 3, reps: 30, weightKg: 0),
        Exercise(id: 'e16', name: 'Burpees',          sets: 3, reps: 15, weightKg: 0),
        Exercise(id: 'e17', name: 'Mountain Climbers', sets: 3, reps: 20, weightKg: 0),
      ],
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
