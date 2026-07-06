import '../../core/constants/app_constants.dart';
import '../models/user_input.dart';
import '../models/meal_plan.dart';

/// Generates financial optimization recommendations.
class OptimizationService {
  OptimizationService._();

  /// Analyze spending and generate actionable tips.
  static List<String> generateRecommendations(UserInput input, MealPlan plan) {
    final List<String> tips = [];

    final homeCookingCost = plan.totalCost(input.numberOfPeople);
    final eatingOutCostPerWeek =
        input.eatingOutMealsPerWeek * AppConstants.avgEatingOutCostPerMeal;
    final weeks = input.durationInDays / 7.0;
    final totalEatingOutCost = eatingOutCostPerWeek * weeks;
    final combinedCost = homeCookingCost + totalEatingOutCost;

    // ── Core budget warning ──
    if (combinedCost > input.totalBudget) {
      final overshoot = combinedCost - input.totalBudget;
      final mealsToSwap =
          (overshoot / (AppConstants.avgEatingOutCostPerMeal - plan.totalCostPerPerson / 21))
              .ceil()
              .clamp(1, input.eatingOutMealsPerWeek * weeks.ceil());
      final savedAmount = mealsToSwap *
          (AppConstants.avgEatingOutCostPerMeal -
              (plan.totalCostPerPerson / 21));
      tips.add(
          '🔄 Swap $mealsToSwap planned outside meal${mealsToSwap > 1 ? 's' : ''} '
          'for home-cooked alternatives to save ₹${savedAmount.toInt()} '
          'and stay within your budget.');
    }

    // ── Eating out frequency advice ──
    if (input.eatingOutMealsPerWeek > 2) {
      final currentWeeklyCost =
          input.eatingOutMealsPerWeek * AppConstants.avgEatingOutCostPerMeal;
      final reducedWeeklyCost =
          2 * AppConstants.avgEatingOutCostPerMeal;
      final weeklySaving = currentWeeklyCost - reducedWeeklyCost;
      tips.add(
          '🍽️ Reducing outside meals from ${input.eatingOutMealsPerWeek} to 2 per week '
          'saves ₹${weeklySaving.toInt()}/week (₹${(weeklySaving * weeks).toInt()} total).');
    }

    // ── Diet-specific tips ──
    if (input.dietaryPreference == 'Veg') {
      tips.add(
          '🥬 Great choice! Vegetarian meals are 30-40% cheaper on average. '
          'Your dal, rice, and seasonal veggie combos maximize savings.');
    } else if (input.dietaryPreference == 'Non-Veg') {
      tips.add(
          '🍗 Tip: Mix 4-5 veg meals per week with non-veg to balance '
          'nutrition and cost. Eggs are the cheapest protein source.');
    }

    // ── Cooking time optimization ──
    if (input.maxCookingTimeMinutes <= 20) {
      if (input.hasFridge) {
        tips.add(
            '⏱️ Short on time? Batch-cook dal and rice on weekends. '
            'Refrigerate portions for quick weekday reheating.');
      } else {
        tips.add(
            '⏱️ Short on time? Choose quick one-pot meals like Khichdi or Poha '
            'to minimize cooking and cleanup.');
      }
    }

    if (!input.hasFridge) {
      tips.add(
          '🚫 No fridge: Buy fresh ingredients in smaller quantities every 2-3 days '
          'to prevent spoilage and food wastage.');
    }

    // ── Savings celebration ──
    if (combinedCost <= input.totalBudget) {
      final saved = input.totalBudget - combinedCost;
      if (saved > 0) {
        tips.add(
            '💰 You\'re projected to save ₹${saved.toInt()} — '
            'that\'s ${(saved / input.totalBudget * 100).toInt()}% under budget! '
            'Consider putting it towards next month\'s groceries.');
      }
    }

    // ── General tips ──
    tips.add(
        '📦 Buy staples (rice, dal, atta) in bulk monthly — '
        'saves 15-20% compared to weekly purchases.');

    return tips;
  }

  /// Calculate projected financial summary.
  static Map<String, double> calculateSummary(UserInput input, MealPlan plan) {
    final homeCookingCost = plan.totalCost(input.numberOfPeople);
    final weeks = input.durationInDays / 7.0;
    final eatingOutCost =
        input.eatingOutMealsPerWeek * AppConstants.avgEatingOutCostPerMeal * weeks;
    final totalProjected = homeCookingCost + eatingOutCost;
    final savings = input.totalBudget - totalProjected;

    return {
      'homeCookingCost': homeCookingCost,
      'eatingOutCost': eatingOutCost,
      'totalProjected': totalProjected,
      'savings': savings,
      'savingsPercent':
          input.totalBudget > 0 ? (savings / input.totalBudget * 100) : 0,
    };
  }
}
