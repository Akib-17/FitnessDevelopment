import 'package:flutter/foundation.dart';

@immutable
class TrainerBooking {
  final String id;
  final String trainerId;
  final DateTime scheduledAt;
  final DateTime createdAt;

  const TrainerBooking({
    required this.id,
    required this.trainerId,
    required this.scheduledAt,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainerId': trainerId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static TrainerBooking fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return TrainerBooking(
      id: (json['id'] ?? '').toString(),
      trainerId: (json['trainerId'] ?? '').toString(),
      scheduledAt: DateTime.tryParse((json['scheduledAt'] ?? '').toString()) ??
          now.add(const Duration(days: 1)),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? now,
    );
  }
}

