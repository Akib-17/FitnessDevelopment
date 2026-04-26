import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal_model.dart';
import '../providers/nutrition_provider.dart';
import '../utils/app_theme.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();

  String _mealType = 'Breakfast';
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _calCtrl.dispose();
    _carbCtrl.dispose();
    _proteinCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Log meal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Meal details'),
              const SizedBox(height: 12),
              _mealTypePicker(),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Meal name',
                  hintText: 'e.g. Oats + eggs',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter a meal name';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _calCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories (kcal)',
                  hintText: 'e.g. 520',
                ),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n <= 0) return 'Enter calories';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _sectionTitle('Macros (grams)'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _carbCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Carbs'),
                      validator: _nonNegativeInt,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _proteinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Protein'),
                      validator: _nonNegativeInt,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _fatCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fat'),
                      validator: _nonNegativeInt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: _saving ? null : () => _save(context),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _mealTypePicker() {
    const types = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _mealType,
          isExpanded: true,
          icon: const Icon(Icons.expand_more_rounded),
          items: types
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(
                    t,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _mealType = v ?? 'Breakfast'),
        ),
      ),
    );
  }

  String? _nonNegativeInt(String? v) {
    final raw = (v ?? '').trim();
    if (raw.isEmpty) return null;
    final n = int.tryParse(raw);
    if (n == null || n < 0) return '0+ only';
    return null;
  }

  Future<void> _save(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final now = DateTime.now();
    final meal = MealEntry(
      id: 'meal_${now.microsecondsSinceEpoch}',
      loggedAt: now,
      mealType: _mealType,
      title: _titleCtrl.text.trim(),
      calories: int.parse(_calCtrl.text.trim()),
      carbsG: int.tryParse(_carbCtrl.text.trim()) ?? 0,
      proteinG: int.tryParse(_proteinCtrl.text.trim()) ?? 0,
      fatG: int.tryParse(_fatCtrl.text.trim()) ?? 0,
    );

    final provider = context.read<NutritionProvider>();
    await provider.addMeal(meal);

    if (!mounted) return;
    setState(() => _saving = false);
    nav.pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Meal logged'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

