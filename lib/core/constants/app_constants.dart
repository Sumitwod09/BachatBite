/// Application-wide constants for BachatBite
class AppConstants {
  AppConstants._();

  // ── Budget allocation ratios ──
  static const double breakfastRatio = 0.20;
  static const double lunchRatio = 0.40;
  static const double dinnerRatio = 0.40;

  // ── Fixed assumptions ──
  static const double avgEatingOutCostPerMeal = 200.0; // ₹200/meal
  static const double minBudget = 500.0;
  static const double maxBudget = 50000.0;
  static const int minPeople = 1;
  static const int maxPeople = 8;
  static const int minCookingTime = 10;
  static const int maxCookingTime = 60;
  static const int cookingTimeStep = 5;

  // ── Duration options ──
  static const Map<String, int> durationOptions = {
    '1 Week': 7,
    '2 Weeks': 14,
    '1 Month': 30,
  };

  // ── Days of the week ──
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // ── Meal slots ──
  static const List<String> mealSlots = ['Breakfast', 'Lunch', 'Dinner'];

  // ── Dietary preferences ──
  static const List<String> dietaryPreferences = ['Veg', 'Non-Veg', 'Eggitarian'];

  // ── Grocery categories (display order) ──
  static const List<String> groceryCategories = [
    'Vegetables',
    'Groceries',
    'Dairy/Eggs',
  ];
}
