import 'recipe.dart';

/// Represents a generated 7-day meal plan.
class MealPlan {
  final String planId;

  /// days['Monday']['Breakfast'] = Recipe
  final Map<String, Map<String, Recipe>> days;

  const MealPlan({
    required this.planId,
    required this.days,
  });

  /// Total estimated cost for one person across all meals
  double get totalCostPerPerson {
    double total = 0;
    for (final dayMeals in days.values) {
      for (final recipe in dayMeals.values) {
        total += recipe.costPerPerson;
      }
    }
    return total;
  }

  /// Total estimated cost for all people
  double totalCost(int numberOfPeople) => totalCostPerPerson * numberOfPeople;

  /// Flat list of all recipes (with duplicates)
  List<Recipe> get allRecipes {
    final List<Recipe> recipes = [];
    for (final dayMeals in days.values) {
      recipes.addAll(dayMeals.values);
    }
    return recipes;
  }

  /// Unique recipes used in this plan
  Set<String> get uniqueRecipeIds {
    return allRecipes.map((r) => r.id).toSet();
  }

  /// Get recipe for a specific day and slot
  Recipe? getRecipe(String day, String slot) {
    return days[day]?[slot];
  }

  /// Create a new plan with one meal replaced
  MealPlan withSwappedMeal(String day, String slot, Recipe newRecipe) {
    final newDays = Map<String, Map<String, Recipe>>.from(
      days.map((k, v) => MapEntry(k, Map<String, Recipe>.from(v))),
    );
    newDays[day]![slot] = newRecipe;
    return MealPlan(planId: planId, days: newDays);
  }
}
