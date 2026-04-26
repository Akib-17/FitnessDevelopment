import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/trainer_provider.dart';
import '../utils/app_theme.dart';
import 'trainer_detail_screen.dart';

class BookedTrainersScreen extends StatelessWidget {
  const BookedTrainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<TrainerProvider>(
        builder: (context, provider, _) {
          final bookings = provider.bookings;
          if (!provider.bookingsLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (bookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.event_busy_rounded,
                        color: AppColors.textHint, size: 42),
                    SizedBox(height: 10),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Book a trainer to see it here with a timestamp.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final b = bookings[index];
              final trainer = provider.getTrainerById(b.trainerId);
              final title = trainer?.name ?? 'Trainer';
              final subtitle = DateFormat('EEE, MMM d • h:mm a').format(b.scheduledAt);
              return Container(
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
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Open',
                      onPressed: trainer == null
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TrainerDetailScreen(trainer: trainer),
                                ),
                              );
                            },
                      icon: const Icon(Icons.open_in_new_rounded),
                      color: AppColors.textHint,
                    ),
                    IconButton(
                      tooltip: 'Cancel',
                      onPressed: () => provider.cancelBooking(b.id),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.error,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

