import 'dart:convert';
import '../../core/constants/app_constants.dart';

/// User input collected from the setup wizard.
class UserInput {
  final double totalBudget;
  final int durationInDays;
  final int numberOfPeople;
  final String dietaryPreference; // "Veg", "Non-Veg", "Eggitarian"
  final int maxCookingTimeMinutes;
  final int eatingOutMealsPerWeek;
  final bool hasFridge;

  const UserInput({
    required this.totalBudget,
    required this.durationInDays,
    required this.numberOfPeople,
    required this.dietaryPreference,
    required this.maxCookingTimeMinutes,
    required this.eatingOutMealsPerWeek,
    this.hasFridge = true,
  });

  // ── Computed budget getters ──

  /// Total person-days
  int get totalPersonDays => durationInDays * numberOfPeople;

  /// Daily budget per person
  double get dailyBudgetPerPerson => totalBudget / totalPersonDays;

  /// Breakfast budget per person per day
  double get breakfastBudget =>
      dailyBudgetPerPerson * AppConstants.breakfastRatio;

  /// Lunch budget per person per day
  double get lunchBudget =>
      dailyBudgetPerPerson * AppConstants.lunchRatio;

  /// Dinner budget per person per day
  double get dinnerBudget =>
      dailyBudgetPerPerson * AppConstants.dinnerRatio;

  /// Budget for a specific meal slot
  double budgetForSlot(String slot) {
    switch (slot) {
      case 'Breakfast':
        return breakfastBudget;
      case 'Lunch':
        return lunchBudget;
      case 'Dinner':
        return dinnerBudget;
      default:
        return lunchBudget;
    }
  }

  // ── Serialization ──

  Map<String, dynamic> toJson() => {
        'totalBudget': totalBudget,
        'durationInDays': durationInDays,
        'numberOfPeople': numberOfPeople,
        'dietaryPreference': dietaryPreference,
        'maxCookingTimeMinutes': maxCookingTimeMinutes,
        'eatingOutMealsPerWeek': eatingOutMealsPerWeek,
        'hasFridge': hasFridge,
      };

  factory UserInput.fromJson(Map<String, dynamic> json) {
    return UserInput(
      totalBudget: (json['totalBudget'] as num).toDouble(),
      durationInDays: json['durationInDays'] as int,
      numberOfPeople: json['numberOfPeople'] as int,
      dietaryPreference: json['dietaryPreference'] as String,
      maxCookingTimeMinutes: json['maxCookingTimeMinutes'] as int,
      eatingOutMealsPerWeek: json['eatingOutMealsPerWeek'] as int,
      hasFridge: json['hasFridge'] as bool? ?? true,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserInput.fromJsonString(String jsonStr) {
    return UserInput.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  UserInput copyWith({
    double? totalBudget,
    int? durationInDays,
    int? numberOfPeople,
    String? dietaryPreference,
    int? maxCookingTimeMinutes,
    int? eatingOutMealsPerWeek,
    bool? hasFridge,
  }) {
    return UserInput(
      totalBudget: totalBudget ?? this.totalBudget,
      durationInDays: durationInDays ?? this.durationInDays,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      maxCookingTimeMinutes: maxCookingTimeMinutes ?? this.maxCookingTimeMinutes,
      eatingOutMealsPerWeek: eatingOutMealsPerWeek ?? this.eatingOutMealsPerWeek,
      hasFridge: hasFridge ?? this.hasFridge,
    );
  }
}
