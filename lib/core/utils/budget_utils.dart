import '../../core/constants/app_constants.dart';

/// Pure budget calculation functions — no state.
class BudgetUtils {
  BudgetUtils._();

  /// Calculate daily budget per person.
  static double calculateDailyBudgetPerPerson(
      double totalBudget, int durationDays, int people) {
    if (durationDays <= 0 || people <= 0) return 0;
    return totalBudget / (durationDays * people);
  }

  /// Calculate meal-specific budgets from daily per-person budget.
  static Map<String, double> calculateMealBudgets(double dailyPerPerson) {
    return {
      'Breakfast': dailyPerPerson * AppConstants.breakfastRatio,
      'Lunch': dailyPerPerson * AppConstants.lunchRatio,
      'Dinner': dailyPerPerson * AppConstants.dinnerRatio,
    };
  }

  /// Format a rupee amount for display.
  static String formatRupee(double amount) {
    if (amount == amount.roundToDouble()) {
      return '₹${amount.toInt()}';
    }
    return '₹${amount.toStringAsFixed(1)}';
  }
}
