import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/nutrition_provider.dart';
import '../utils/app_theme.dart';
import 'add_meal_screen.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Diet Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Set goal',
            onPressed: () => _showGoalDialog(context),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Consumer<NutritionProvider>(
        builder: (context, nutrition, _) {
          if (!nutrition.isLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _macroRow(
                  carbsG: nutrition.totalCarbsG,
                  proteinG: nutrition.totalProteinG,
                  fatG: nutrition.totalFatG,
                ),
                const SizedBox(height: 14),
                _calorieProgress(
                  current: nutrition.totalCalories,
                  goal: nutrition.dailyGoalKcal,
                  progress: nutrition.calorieProgress,
                ),
                const SizedBox(height: 22),
                const Text(
                  'Meals today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (nutrition.mealsToday.isEmpty)
                  _emptyState()
                else
                  ...nutrition.mealsToday.map((m) => _MealCard(
                        mealType: m.mealType,
                        title: m.title,
                        calories: m.calories,
                        onDelete: () => nutrition.removeMeal(m.id),
                      )),
                const SizedBox(height: 90),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
        child: ElevatedButton(
          onPressed: () => _showLogOptions(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 20),
              SizedBox(width: 8),
              Text('+ Log meal / Scan barcode'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroRow({
    required int carbsG,
    required int proteinG,
    required int fatG,
  }) {
    return Row(
      children: [
        Expanded(
          child: _MacroCard(
            label: 'Carbs',
            value: '${carbsG}g',
            color: AppColors.chartOrange,
            icon: Icons.grain_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MacroCard(
            label: 'Protein',
            value: '${proteinG}g',
            color: AppColors.chartGreen,
            icon: Icons.egg_alt_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MacroCard(
            label: 'Fat',
            value: '${fatG}g',
            color: AppColors.chartBlue,
            icon: Icons.water_drop_rounded,
          ),
        ),
      ],
    );
  }

  Widget _calorieProgress({
    required int current,
    required int goal,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Calories',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(Icons.local_fire_department_rounded,
                  color: AppColors.warning, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$current / $goal kcal',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Row(
        children: const [
          Icon(Icons.restaurant_menu_rounded, color: AppColors.textHint),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'No meals logged yet. Tap the button below to add one.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogOptions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.edit_note_rounded,
                      color: AppColors.primary),
                ),
                title: const Text('Log meal'),
                subtitle: const Text('Add calories & macros'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddMealScreen()),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      color: AppColors.warning),
                ),
                title: const Text('Scan barcode'),
                subtitle: const Text('Coming soon'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Barcode scanning coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showGoalDialog(BuildContext context) async {
    final provider = context.read<NutritionProvider>();
    final ctrl = TextEditingController(text: provider.dailyGoalKcal.toString());

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Daily calorie goal',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'kcal',
            hintText: 'e.g. 2400',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final goal = int.tryParse(ctrl.text.trim()) ?? provider.dailyGoalKcal;
              await provider.setDailyGoalKcal(goal);
              if (context.mounted) Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 44)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String mealType;
  final String title;
  final int calories;
  final VoidCallback onDelete;

  const _MealCard({
    required this.mealType,
    required this.title,
    required this.calories,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _iconForMealType(mealType);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$calories kcal',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.textHint,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }

  IconData _iconForMealType(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }
}

