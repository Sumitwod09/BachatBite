import '../models/recipe.dart';
import '../models/ingredient.dart';

/// Hardcoded repository of 10 budget-friendly Indian recipes.
class RecipeRepository {
  RecipeRepository._();

  static final List<Recipe> _recipes = [
    const Recipe(
      id: 'rec_001',
      name: 'Poha',
      costPerPerson: 15.0,
      type: 'Veg',
      timeMinutes: 15,
      mealSlot: 'Breakfast',
      ingredients: [
        Ingredient(name: 'Flattened Rice (Poha)', baseQuantity: 75, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Onions', baseQuantity: 30, unit: 'grams', category: 'Vegetables'),
        Ingredient(name: 'Peanuts & Spices', baseQuantity: 1, unit: 'tsp', category: 'Groceries'),
      ],
      steps: [
        'Rinse poha in a strainer and drain completely.',
        'Heat oil, fry peanuts, add mustard seeds and chopped onions.',
        'Add turmeric, salt, and drained poha. Mix gently for 3-5 minutes.',
      ],
    ),
    const Recipe(
      id: 'rec_002',
      name: 'Dal Chawal',
      costPerPerson: 30.0,
      type: 'Veg',
      timeMinutes: 25,
      mealSlot: 'Lunch',
      ingredients: [
        Ingredient(name: 'Toor Dal', baseQuantity: 60, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Rice', baseQuantity: 100, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Tomato & Spices', baseQuantity: 1, unit: 'item', category: 'Vegetables'),
      ],
      steps: [
        'Pressure cook washed dal with salt and turmeric for 3 whistles.',
        'Boil rice in a separate pot until fully soft.',
        'Tempering: Heat oil with cumin, garlic, and chopped tomatoes. Pour over cooked dal.',
      ],
    ),
    const Recipe(
      id: 'rec_003',
      name: 'Egg Curry and Roti',
      costPerPerson: 45.0,
      type: 'Non-Veg',
      timeMinutes: 30,
      mealSlot: 'Dinner',
      ingredients: [
        Ingredient(name: 'Eggs', baseQuantity: 2, unit: 'pcs', category: 'Dairy/Eggs'),
        Ingredient(name: 'Atta (Wheat Flour)', baseQuantity: 80, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Onion-Tomato Paste', baseQuantity: 50, unit: 'grams', category: 'Vegetables'),
      ],
      steps: [
        'Boil, peel, and lightly fry the eggs.',
        'Sauté onion-tomato paste with basic spices till oil separates; add water to make gravy.',
        'Simmer fried eggs in the gravy for 5 mins while preparing rotis simultaneously.',
      ],
    ),
    const Recipe(
      id: 'rec_004',
      name: 'Aloo Paratha with Curd',
      costPerPerson: 25.0,
      type: 'Veg',
      timeMinutes: 30,
      mealSlot: 'Breakfast',
      ingredients: [
        Ingredient(name: 'Potatoes', baseQuantity: 100, unit: 'grams', category: 'Vegetables'),
        Ingredient(name: 'Atta (Wheat Flour)', baseQuantity: 80, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Curd', baseQuantity: 50, unit: 'grams', category: 'Dairy/Eggs'),
      ],
      steps: [
        'Boil, mash potatoes, and mix with green chilies and spices.',
        'Stuff the spiced potato mixture inside rolled dough balls.',
        'Roll out flat and roast on a tawa using minimal oil. Serve with fresh curd.',
      ],
    ),
    const Recipe(
      id: 'rec_005',
      name: 'Veg Khichdi',
      costPerPerson: 25.0,
      type: 'Veg',
      timeMinutes: 20,
      mealSlot: 'Lunch/Dinner',
      ingredients: [
        Ingredient(name: 'Rice', baseQuantity: 50, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Moong Dal', baseQuantity: 50, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Mixed Vegetables (Carrot/Peas)', baseQuantity: 50, unit: 'grams', category: 'Vegetables'),
      ],
      steps: [
        'Wash rice and dal together thoroughly.',
        'Heat oil in a pressure cooker, add cumin seeds, and sauté mixed chopped vegetables.',
        'Add rice, dal, water, salt, and pressure cook for 3 whistles.',
      ],
    ),
    const Recipe(
      id: 'rec_006',
      name: 'Oatmeal Upma',
      costPerPerson: 35.0,
      type: 'Veg',
      timeMinutes: 15,
      mealSlot: 'Breakfast',
      ingredients: [
        Ingredient(name: 'Oats', baseQuantity: 60, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Onions & Carrots', baseQuantity: 40, unit: 'grams', category: 'Vegetables'),
        Ingredient(name: 'Mustard seeds & Oil', baseQuantity: 1, unit: 'tsp', category: 'Groceries'),
      ],
      steps: [
        'Dry roast oats for 2 minutes and set aside.',
        'Sauté mustard seeds, curry leaves, chopped onions, and carrots in a pan.',
        'Add water, bring to a boil, then slowly stir in roasted oats until thick.',
      ],
    ),
    const Recipe(
      id: 'rec_007',
      name: 'Chana Masala with Rice',
      costPerPerson: 35.0,
      type: 'Veg',
      timeMinutes: 40,
      mealSlot: 'Lunch/Dinner',
      ingredients: [
        Ingredient(name: 'White Chickpeas (Chana)', baseQuantity: 60, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Rice', baseQuantity: 100, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Onion, Tomato, Ginger', baseQuantity: 60, unit: 'grams', category: 'Vegetables'),
      ],
      steps: [
        'Soak chickpeas overnight; pressure cook until perfectly tender.',
        'Prepare a spicy gravy base using onions, tomatoes, ginger, and chana masala powder.',
        'Simmer cooked chickpeas in the gravy while boiling the standard portion of rice.',
      ],
    ),
    const Recipe(
      id: 'rec_008',
      name: 'Bread Omelette',
      costPerPerson: 22.0,
      type: 'Non-Veg',
      timeMinutes: 10,
      mealSlot: 'Breakfast',
      ingredients: [
        Ingredient(name: 'Eggs', baseQuantity: 2, unit: 'pcs', category: 'Dairy/Eggs'),
        Ingredient(name: 'Bread Slices', baseQuantity: 2, unit: 'pcs', category: 'Groceries'),
        Ingredient(name: 'Onion & Green Chili', baseQuantity: 15, unit: 'grams', category: 'Vegetables'),
      ],
      steps: [
        'Whisk eggs vigorously with finely chopped onions, green chilies, and salt.',
        'Pour mixture into a hot greased pan; place bread slices directly on top.',
        'Flip the entire assembly over to toast the bread face down until eggs are firm.',
      ],
    ),
    const Recipe(
      id: 'rec_009',
      name: 'Soya Chunks Curry & Roti',
      costPerPerson: 28.0,
      type: 'Veg',
      timeMinutes: 25,
      mealSlot: 'Lunch/Dinner',
      ingredients: [
        Ingredient(name: 'Soya Chunks', baseQuantity: 40, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Atta (Wheat Flour)', baseQuantity: 80, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Onion & Tomato', baseQuantity: 50, unit: 'grams', category: 'Vegetables'),
      ],
      steps: [
        'Soak soya chunks in hot water for 10 minutes, then squeeze excess water out.',
        'Sauté spices, onions, and tomatoes to form a thick, aromatic curry base.',
        'Add soya chunks along with water, cook for 10 minutes, and serve with hot rotis.',
      ],
    ),
    const Recipe(
      id: 'rec_010',
      name: 'Misal Pav',
      costPerPerson: 40.0,
      type: 'Veg',
      timeMinutes: 35,
      mealSlot: 'Lunch',
      ingredients: [
        Ingredient(name: 'Sprouted Moth Beans', baseQuantity: 60, unit: 'grams', category: 'Groceries'),
        Ingredient(name: 'Pav (Bread Roll)', baseQuantity: 2, unit: 'pcs', category: 'Groceries'),
        Ingredient(name: 'Farsan (Mix)', baseQuantity: 20, unit: 'grams', category: 'Groceries'),
      ],
      steps: [
        'Cook sprouted beans with turmeric and water.',
        'Prepare a fiery thin gravy base using a spicy coconut-onion paste base.',
        'Combine sprouts with gravy in a bowl, top with crispy farsan, and serve with pav.',
      ],
    ),
  ];

  /// Returns all recipes.
  static List<Recipe> getAllRecipes() => List.unmodifiable(_recipes);

  /// Returns a recipe by ID.
  static Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filters recipes based on constraints.
  static List<Recipe> filterRecipes({
    String? diet,
    int? maxTime,
    double? maxCost,
    String? mealSlot,
    bool? hasFridge,
  }) {
    return _recipes.where((r) {
      // Diet filter
      if (diet != null) {
        if (diet == 'Veg' && r.type != 'Veg') return false;
        if (diet == 'Eggitarian' && r.type == 'Non-Veg' && !r.isEggBased) return false;
        // "Non-Veg" allows everything
      }

      // Time filter
      if (maxTime != null && r.timeMinutes > maxTime) return false;

      // Cost filter
      if (maxCost != null && r.costPerPerson > maxCost) return false;

      // Meal slot filter
      if (mealSlot != null && !r.mealSlotList.contains(mealSlot)) return false;

      // Fridge filter: if user doesn't have a fridge, filter out recipes requiring fridge
      if (hasFridge == false && r.requiresFridge) return false;

      return true;
    }).toList();
  }
}
