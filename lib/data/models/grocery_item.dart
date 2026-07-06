/// Represents an aggregated grocery list item.
class GroceryItem {
  final String name;
  final double totalQuantity;
  final String unit;
  final String category;
  bool isPurchased;

  GroceryItem({
    required this.name,
    required this.totalQuantity,
    required this.unit,
    required this.category,
    this.isPurchased = false,
  });

  /// Formatted quantity string for display.
  String get formattedQuantity {
    if (unit == 'pcs' || unit == 'item' || unit == 'tsp') {
      return '${totalQuantity == totalQuantity.roundToDouble() ? totalQuantity.toInt() : totalQuantity} $unit';
    }
    // Convert grams to kg if ≥ 1000
    if (unit == 'grams' && totalQuantity >= 1000) {
      final kg = totalQuantity / 1000;
      return '${kg.toStringAsFixed(1)} kg';
    }
    if (totalQuantity == totalQuantity.roundToDouble()) {
      return '${totalQuantity.toInt()} $unit';
    }
    return '${totalQuantity.toStringAsFixed(1)} $unit';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'totalQuantity': totalQuantity,
        'unit': unit,
        'category': category,
        'isPurchased': isPurchased,
      };

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      name: json['name'] as String,
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      isPurchased: json['isPurchased'] as bool? ?? false,
    );
  }
}
