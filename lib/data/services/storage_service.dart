import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_input.dart';

/// Wraps SharedPreferences for BachatBite local storage.
class StorageService {
  static const _keyUserInput = 'bachatbite_user_input';
  static const _keyGroceryChecked = 'bachatbite_grocery_checked';

  /// Save user input to localStorage.
  static Future<void> saveUserInput(UserInput input) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserInput, input.toJsonString());
  }

  /// Load user input from localStorage.
  static Future<UserInput?> loadUserInput() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyUserInput);
    if (jsonStr == null) return null;
    try {
      return UserInput.fromJsonString(jsonStr);
    } catch (_) {
      return null;
    }
  }

  /// Check if a saved session exists.
  static Future<bool> hasSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUserInput);
  }

  /// Save grocery checkbox states.
  static Future<void> saveGroceryChecked(Map<String, bool> checkedMap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGroceryChecked, jsonEncode(checkedMap));
  }

  /// Load grocery checkbox states.
  static Future<Map<String, bool>> loadGroceryChecked() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyGroceryChecked);
    if (jsonStr == null) return {};
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v as bool));
    } catch (_) {
      return {};
    }
  }

  /// Clear all saved data.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserInput);
    await prefs.remove(_keyGroceryChecked);
  }
}
