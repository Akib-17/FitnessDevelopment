// lib/screens/workout_screen.dart
// The Workout Tracking Screen.
// Shows the current workout session, exercise list with completion checkboxes,
// rest timer, and session progress. Based on wireframe screen 3.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout_model.dart';
import '../utils/app_theme.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Active Session & History
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Workout'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ActiveSessionTab(),  // Tab 1: Current workout
            _WorkoutHistoryTab(), // Tab 2: Past sessions
          ],
        ),
      ),
    );
  }
}

// ── Tab 1: Active Workout Session ────────────────────────────────────────────
class _ActiveSessionTab extends StatelessWidget {
  const _ActiveSessionTab();

  @override
  Widget build(BuildContext context) {
    // Using Consumer instead of watch so we only rebuild when needed
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, _) {
        final session = workoutProvider.activeSession;

        if (session == null) {
          return const Center(child: Text('No workout scheduled for today.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Session Title Card ────────────────────────────────
              _buildSessionHeader(context, session, workoutProvider),

              const SizedBox(height: 20),

              // ── Rest Timer (visible only when resting) ─────────────
              if (workoutProvider.isResting)
                _buildRestTimer(context, workoutProvider),

              if (workoutProvider.isResting) const SizedBox(height: 20),

              // ── Exercise Progress Bar ─────────────────────────────
              _buildProgressBar(session),

              const SizedBox(height: 20),

              // ── Exercise List ─────────────────────────────────────
              const Text(
                'Exercise list',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              // Render each exercise as a card
              ...session.exercises.asMap().entries.map((entry) {
                final index = entry.key;
                final exercise = entry.value;

                // Determine if this is the next exercise to do
                final isNext = !exercise.isCompleted &&
                    session.exercises
                        .take(index)
                        .every((e) => e.isCompleted);

                return _ExerciseCard(
                  exercise: exercise,
                  isNext: isNext,
                  onComplete: workoutProvider.sessionStarted
                      ? () => workoutProvider.completeExercise(exercise.id)
                      : null, // Disable if session not started
                );
              }).toList(),

              const SizedBox(height: 20),

              // ── End Session Button ────────────────────────────────
              if (workoutProvider.sessionStarted)
                OutlinedButton(
                  onPressed: () {
                    workoutProvider.endSession();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Great workout! Session saved. 💪'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'End Session',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Session Header Card ───────────────────────────────────────────────────
  Widget _buildSessionHeader(
    BuildContext context,
    WorkoutSession session,
    WorkoutProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF7C86FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${session.exercises.length} exercises · ~${session.durationMinutes} min',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Start/Active state button
          if (!provider.sessionStarted)
            ElevatedButton.icon(
              onPressed: () => provider.startSession(session),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            Row(
              children: [
                const Icon(Icons.circle, color: AppColors.success, size: 12),
                const SizedBox(width: 6),
                const Text(
                  'Session in progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ── Rest Timer Card ───────────────────────────────────────────────────────
  Widget _buildRestTimer(BuildContext context, WorkoutProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          // Countdown circle
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warning.withOpacity(0.15),
            ),
            child: Center(
              child: Text(
                '${provider.restSeconds}s',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Rest time',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Take a breather before the next set',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Skip rest button
          TextButton(
            onPressed: provider.skipRest,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress Bar ──────────────────────────────────────────────────────────
  Widget _buildProgressBar(WorkoutSession session) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              Text(
                '${session.completedCount} / ${session.exercises.length} exercises',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: session.progress,
              minHeight: 8,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Exercise Card Widget ─────────────────────────────────────────────────────
// Displays a single exercise with its details and a complete button.
class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final bool isNext;           // Highlights as "next to do"
  final VoidCallback? onComplete;

  const _ExerciseCard({
    required this.exercise,
    required this.isNext,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: exercise.isCompleted
            ? AppColors.success.withOpacity(0.06)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: exercise.isCompleted
              ? AppColors.success.withOpacity(0.3)
              : isNext
                  ? AppColors.primary.withOpacity(0.4)
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // ── Completion Checkbox ─────────────────────────────────
          GestureDetector(
            onTap: exercise.isCompleted ? null : onComplete,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: exercise.isCompleted
                    ? AppColors.success
                    : Colors.transparent,
                border: Border.all(
                  color: exercise.isCompleted
                      ? AppColors.success
                      : AppColors.textHint,
                  width: 2,
                ),
              ),
              child: exercise.isCompleted
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          // ── Exercise Details ─────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: exercise.isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration: exercise.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  // Show weight if not bodyweight, otherwise just sets x reps
                  exercise.weightKg > 0
                      ? '${exercise.sets} sets · ${exercise.reps} reps · ${exercise.weightKg.toInt()} kg'
                      : '${exercise.sets} sets · ${exercise.reps} reps · bodyweight',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // ── Status Badge ─────────────────────────────────────────
          if (exercise.isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Tab 2: Workout History ────────────────────────────────────────────────────
class _WorkoutHistoryTab extends StatelessWidget {
  const _WorkoutHistoryTab();

  @override
  Widget build(BuildContext context) {
    final history = context.watch<WorkoutProvider>().history;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = history[index];
        return _HistoryCard(session: session);
      },
    );
  }
}

// ── History Card Widget ───────────────────────────────────────────────────────
// Displays a past workout session summary.
class _HistoryCard extends StatelessWidget {
  final WorkoutSession session;

  const _HistoryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    // Format date as "Apr 17" or "Today"
    final now = DateTime.now();
    final diff = now.difference(session.date).inDays;
    final dateLabel = diff == 0
        ? 'Today'
        : diff == 1
            ? 'Yesterday'
            : '${diff} days ago';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _categoryColor(session.category).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _categoryIcon(session.category),
              color: _categoryColor(session.category),
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$dateLabel · ${session.exercises.length} exercises · ${session.durationMinutes} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }

  /// Returns the icon for a workout category
  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run_rounded;
      case 'hiit':
        return Icons.flash_on_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  /// Returns the accent color for a workout category
  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cardio':
        return AppColors.info;
      case 'hiit':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }
}
