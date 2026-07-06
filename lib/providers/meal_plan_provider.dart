import 'package:flutter/material.dart';
import '../data/models/user_input.dart';
import '../data/models/meal_plan.dart';
import '../data/services/meal_plan_service.dart';
import '../data/services/optimization_service.dart';

/// Manages generated meal plan state and financial metrics.
class MealPlanProvider extends ChangeNotifier {
  MealPlan? _currentPlan;
  UserInput? _userInput;
  List<String> _recommendations = [];
  Map<String, double> _summary = {};

  // ── Getters ──
  MealPlan? get currentPlan => _currentPlan;
  UserInput? get userInput => _userInput;
  List<String> get recommendations => _recommendations;
  Map<String, double> get summary => _summary;

  double get totalEstimatedCost => _summary['totalProjected'] ?? 0;
  double get projectedSavings => _summary['savings'] ?? 0;
  double get savingsPercent => _summary['savingsPercent'] ?? 0;
  double get homeCookingCost => _summary['homeCookingCost'] ?? 0;
  double get eatingOutCost => _summary['eatingOutCost'] ?? 0;

  bool get hasPlan => _currentPlan != null;

  /// Generate a new meal plan from user input.
  void generatePlan(UserInput input) {
    _userInput = input;
    _currentPlan = MealPlanService.generatePlan(input);
    _recommendations = OptimizationService.generateRecommendations(input, _currentPlan!);
    _summary = OptimizationService.calculateSummary(input, _currentPlan!);
    notifyListeners();
  }

  /// Swap a meal at the given day/slot.
  void swapMeal(String day, String slot) {
    if (_currentPlan == null || _userInput == null) return;
    _currentPlan = MealPlanService.swapMeal(
      _currentPlan!,
      day,
      slot,
      _userInput!,
    );
    // Recalculate metrics
    _summary = OptimizationService.calculateSummary(_userInput!, _currentPlan!);
    _recommendations =
        OptimizationService.generateRecommendations(_userInput!, _currentPlan!);
    notifyListeners();
  }

  /// Reset plan state.
  void resetPlan() {
    _currentPlan = null;
    _userInput = null;
    _recommendations = [];
    _summary = {};
    notifyListeners();
  }
}
