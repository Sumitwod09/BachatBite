import 'ingredient.dart';

/// Represents a budget-optimized Indian recipe.
class Recipe {
  final String id;
  final String name;
  final double costPerPerson;
  final String type; // "Veg" or "Non-Veg"
  final int timeMinutes;
  final String mealSlot; // e.g. "Breakfast", "Lunch", "Lunch/Dinner"
  final List<Ingredient> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.name,
    required this.costPerPerson,
    required this.type,
    required this.timeMinutes,
    required this.mealSlot,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      costPerPerson: (json['costPerPerson'] as num).toDouble(),
      type: json['type'] as String,
      timeMinutes: json['timeMinutes'] as int,
      mealSlot: json['mealSlot'] as String,
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'costPerPerson': costPerPerson,
        'type': type,
        'timeMinutes': timeMinutes,
        'mealSlot': mealSlot,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'steps': steps,
      };

  /// Splits "Lunch/Dinner" → ["Lunch", "Dinner"]
  List<String> get mealSlotList => mealSlot.split('/').map((s) => s.trim()).toList();

  /// Whether this recipe contains only eggs as non-veg component
  bool get isEggBased {
    if (type != 'Non-Veg') return false;
    return ingredients.any((i) =>
        i.name.toLowerCase().contains('egg'));
  }

  /// Whether this recipe requires a fridge/refrigeration for its ingredients
  bool get requiresFridge {
    return ingredients.any((i) {
      final name = i.name.toLowerCase();
      final cat = i.category.toLowerCase();
      return cat == 'dairy/eggs' ||
          name.contains('curd') ||
          name.contains('egg') ||
          name.contains('milk') ||
          name.contains('paneer') ||
          name.contains('cheese');
    });
  }

  /// Total cost for a given number of people
  double totalCost(int people) => costPerPerson * people;
}
