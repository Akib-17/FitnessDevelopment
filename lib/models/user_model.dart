// lib/models/user_model.dart
// Defines the User data class.
// This represents a registered/logged-in user in the app.

class UserModel {
  final String id;
  final String name;
  final String email;
  final double weight;   // in kg
  final double height;   // in cm
  final String goal;     // e.g. "Fat loss", "Muscle gain", "Maintenance"
  final String memberSince;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
    required this.goal,
    required this.memberSince,
  });

  // Returns user's initials for the avatar widget (e.g. "RC" for "Rahim Chowdhury")
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // Returns BMI rounded to 1 decimal place
  double get bmi {
    final heightM = height / 100;
    return double.parse((weight / (heightM * heightM)).toStringAsFixed(1));
  }
}
