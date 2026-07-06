import '../models/recipe.dart';
import '../models/meal_plan.dart';
import '../models/grocery_item.dart';

/// Aggregates ingredients across all planned meals into a consolidated grocery list.
class GroceryService {
  GroceryService._();

  /// Generate a grocery list from a meal plan, scaled for the number of people.
  static List<GroceryItem> generateGroceryList(MealPlan plan, int numberOfPeople) {
    final Map<String, _AggregatedItem> aggregated = {};

    for (final recipe in plan.allRecipes) {
      for (final ingredient in recipe.ingredients) {
        final key = ingredient.name.toLowerCase();
        final scaledQty = ingredient.scaledQuantity(numberOfPeople);

        if (aggregated.containsKey(key)) {
          aggregated[key]!.totalQuantity += scaledQty;
        } else {
          aggregated[key] = _AggregatedItem(
            name: ingredient.name,
            totalQuantity: scaledQty,
            unit: ingredient.unit,
            category: ingredient.category,
          );
        }
      }
    }

    // Sort by category then name
    final items = aggregated.values.map((a) => GroceryItem(
      name: a.name,
      totalQuantity: a.totalQuantity,
      unit: a.unit,
      category: a.category,
    )).toList();

    items.sort((a, b) {
      final catCompare = a.category.compareTo(b.category);
      if (catCompare != 0) return catCompare;
      return a.name.compareTo(b.name);
    });

    return items;
  }
}

class _AggregatedItem {
  final String name;
  double totalQuantity;
  final String unit;
  final String category;

  _AggregatedItem({
    required this.name,
    required this.totalQuantity,
    required this.unit,
    required this.category,
  });
}
