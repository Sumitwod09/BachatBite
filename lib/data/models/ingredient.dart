/// Represents a single ingredient within a recipe.
class Ingredient {
  final String name;
  final double baseQuantity;
  final String unit;
  final String category;

  const Ingredient({
    required this.name,
    required this.baseQuantity,
    required this.unit,
    required this.category,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      baseQuantity: (json['baseQuantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'baseQuantity': baseQuantity,
        'unit': unit,
        'category': category,
      };

  /// Returns the scaled quantity for a given number of people.
  double scaledQuantity(int people) => baseQuantity * people;

  /// Formats the scaled quantity with unit for display.
  String formattedQuantity(int people) {
    final qty = scaledQuantity(people);
    // Show integer if whole number
    final qtyStr = qty == qty.roundToDouble() ? qty.toInt().toString() : qty.toStringAsFixed(1);
    return '$qtyStr $unit';
  }
}
