import 'package:flutter/material.dart';
import '../data/models/grocery_item.dart';
import '../data/models/meal_plan.dart';
import '../data/services/grocery_service.dart';
import '../data/services/storage_service.dart';

/// Manages grocery checklist state with persistent checkboxes.
class GroceryProvider extends ChangeNotifier {
  List<GroceryItem> _items = [];

  List<GroceryItem> get items => _items;
  int get totalItems => _items.length;
  int get purchasedCount => _items.where((i) => i.isPurchased).length;
  double get progressPercent =>
      totalItems > 0 ? purchasedCount / totalItems : 0;

  /// Generate grocery list from a meal plan.
  Future<void> generateFromPlan(MealPlan plan, int numberOfPeople) async {
    _items = GroceryService.generateGroceryList(plan, numberOfPeople);

    // Restore checkbox states from localStorage
    final checkedMap = await StorageService.loadGroceryChecked();
    for (final item in _items) {
      item.isPurchased = checkedMap[item.name] ?? false;
    }

    notifyListeners();
  }

  /// Toggle purchase state for an item.
  Future<void> togglePurchased(int index) async {
    if (index < 0 || index >= _items.length) return;
    _items[index].isPurchased = !_items[index].isPurchased;
    notifyListeners();
    await _persistCheckboxes();
  }

  /// Uncheck all items.
  Future<void> uncheckAll() async {
    for (final item in _items) {
      item.isPurchased = false;
    }
    notifyListeners();
    await _persistCheckboxes();
  }

  /// Persist checkbox state map to localStorage.
  Future<void> _persistCheckboxes() async {
    final map = <String, bool>{};
    for (final item in _items) {
      map[item.name] = item.isPurchased;
    }
    await StorageService.saveGroceryChecked(map);
  }

  /// Clear grocery list.
  void clear() {
    _items = [];
    notifyListeners();
  }
}
