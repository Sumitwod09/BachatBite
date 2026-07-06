import 'dart:math';
import '../../core/constants/app_constants.dart';
import '../models/recipe.dart';
import '../models/meal_plan.dart';
import '../models/user_input.dart';
import '../repositories/recipe_repository.dart';

/// Generates constraint-based 7-day meal plans.
class MealPlanService {
  MealPlanService._();

  static final _random = Random();

  /// Generate a full 7-day meal plan matching user constraints.
  static MealPlan generatePlan(UserInput input) {
    final allRecipes = RecipeRepository.getAllRecipes();
    final Map<String, Map<String, Recipe>> days = {};

    // Track last selected recipe per slot to avoid consecutive repeats
    final Map<String, String?> lastSelectedPerSlot = {
      'Breakfast': null,
      'Lunch': null,
      'Dinner': null,
    };

    for (final day in AppConstants.daysOfWeek) {
      final Map<String, Recipe> dayMeals = {};

      for (final slot in AppConstants.mealSlots) {
        final budget = input.budgetForSlot(slot);

        // Filter recipes for this slot
        List<Recipe> pool = RecipeRepository.filterRecipes(
          diet: input.dietaryPreference,
          maxTime: input.maxCookingTimeMinutes,
          maxCost: budget,
          mealSlot: slot,
          hasFridge: input.hasFridge,
        );

        // Remove the last selected recipe for this slot to avoid consecutive repeats
        final lastId = lastSelectedPerSlot[slot];
        if (lastId != null && pool.length > 1) {
          pool = pool.where((r) => r.id != lastId).toList();
        }

        if (pool.isEmpty) {
          // Fallback: relax cost constraint, keep diet and slot
          pool = RecipeRepository.filterRecipes(
            diet: input.dietaryPreference,
            mealSlot: slot,
            hasFridge: input.hasFridge,
          );
        }

        if (pool.isEmpty) {
          // Ultimate fallback: any recipe for this slot
          pool = allRecipes.where((r) => r.mealSlotList.contains(slot)).toList();
        }

        if (pool.isNotEmpty) {
          final selected = pool[_random.nextInt(pool.length)];
          dayMeals[slot] = selected;
          lastSelectedPerSlot[slot] = selected.id;
        }
      }

      days[day] = dayMeals;
    }

    final planId = 'plan_${DateTime.now().millisecondsSinceEpoch}';
    return MealPlan(planId: planId, days: days);
  }

  /// Swap a single meal in the plan with a different valid recipe.
  static MealPlan swapMeal(
    MealPlan plan,
    String day,
    String slot,
    UserInput input,
  ) {
    final currentRecipe = plan.getRecipe(day, slot);
    final budget = input.budgetForSlot(slot);

    List<Recipe> pool = RecipeRepository.filterRecipes(
      diet: input.dietaryPreference,
      maxTime: input.maxCookingTimeMinutes,
      maxCost: budget,
      mealSlot: slot,
      hasFridge: input.hasFridge,
    );

    // Remove current recipe from pool
    if (currentRecipe != null && pool.length > 1) {
      pool = pool.where((r) => r.id != currentRecipe.id).toList();
    }

    if (pool.isEmpty) {
      pool = RecipeRepository.filterRecipes(
        diet: input.dietaryPreference,
        mealSlot: slot,
        hasFridge: input.hasFridge,
      );
      if (currentRecipe != null && pool.length > 1) {
        pool = pool.where((r) => r.id != currentRecipe.id).toList();
      }
    }

    if (pool.isNotEmpty) {
      final newRecipe = pool[_random.nextInt(pool.length)];
      return plan.withSwappedMeal(day, slot, newRecipe);
    }

    return plan; // No swap possible
  }
}
