import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainer_provider.dart';
import '../utils/app_theme.dart';
import 'booked_trainers_screen.dart';
import 'trainer_detail_screen.dart';

class TrainersScreen extends StatelessWidget {
  const TrainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trainer Marketplace'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'My bookings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookedTrainersScreen()),
              );
            },
            icon: const Icon(Icons.event_available_rounded),
          ),
        ],
      ),
      body: Consumer<TrainerProvider>(
        builder: (context, trainers, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _searchField(
                initial: trainers.searchQuery,
                onChanged: trainers.setSearchQuery,
              ),
              const SizedBox(height: 12),
              _categoryChips(
                categories: trainers.categories,
                selected: trainers.category,
                onTap: trainers.setCategory,
              ),
              const SizedBox(height: 16),
              ...trainers.filtered.map(
                (t) => _TrainerCard(
                  name: t.name,
                  tags: t.tags,
                  years: t.yearsExperience,
                  price: t.pricePerSessionUsd,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TrainerDetailScreen(trainer: t)),
                    );
                  },
                ),
              ),
              if (trainers.filtered.isEmpty) _emptyState(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchField({
    required String initial,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Search trainers...',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );
  }

  Widget _categoryChips({
    required List<String> categories,
    required String selected,
    required ValueChanged<String> onTap,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((c) {
          final isSelected = c == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(c),
              selected: isSelected,
              onSelected: (_) => onTap(c),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : AppColors.textHint.withOpacity(0.25),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Row(
        children: const [
          Icon(Icons.search_off_rounded, color: AppColors.textHint),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'No trainers found. Try a different search or category.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  final String name;
  final List<String> tags;
  final int years;
  final int price;
  final VoidCallback onTap;

  const _TrainerCard({
    required this.name,
    required this.tags,
    required this.years,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${tags.join(' · ')} · $years yrs exp',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$$price / session',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

